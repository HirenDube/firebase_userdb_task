import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class UserDetails extends StatefulWidget {
  Map userDetails;
  String userId;
  String heroTag;

  UserDetails(
      {required this.heroTag, required this.userDetails, required this.userId});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

// \nPhone No. : ${userDetails["Phone"].substring(0, 5)} ${userDetails["Phone"].substring(5, 10)}\nE-mail : ${userDetails["E-mail"]}\n
class _UserDetailsState extends State<UserDetails> {
  String videoUrl = "";
  List<VideoPlayerController> videoBeingPlayedNow = [];
  List videoUrls = [];
  bool videoUploading = false, pageLoading = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> videos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingVideos();
  }

  Future<void> gettingVideos() async {
    setState(() {
      pageLoading = true;
    });
    videos = await FirebaseFirestore.instance
        .collection("UserDataBase")
        .doc(widget.userId)
        .collection("Shorts")
        .get()
        .then((value) {
      return value.docs;
    });

    if (videos.length != 0) {
      videos.forEach((element) {
        String urlLink = element.data()["Url"];
        videoUrls.add(urlLink);
        videoBeingPlayedNow.add(VideoPlayerController.network(urlLink));
      });
      videoBeingPlayedNow.forEach((element) {
        element..initialize().then((value) => setState(() {}));
      });

      setState(() {
        pageLoading = false;
      });
    }
    setState(() {
      pageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              XFile? shortVid = await ImagePicker().pickVideo(
                  source: ImageSource.gallery,
                  maxDuration: Duration(seconds: 30));
              if (shortVid != null) {
                setState(() {
                  videoUploading = true;
                });
                var insertVideo = FirebaseStorage.instance
                    .ref()
                    .child("ShortVideos")
                    .child(DateTime.now().microsecondsSinceEpoch.toString());
                await insertVideo.putFile(File(shortVid.path));
                videoUrl = await insertVideo.getDownloadURL();
                var vidLink = FirebaseFirestore.instance
                    .collection("UserDataBase")
                    .doc(widget.userId)
                    .collection("Shorts")
                    .doc(shortVid.name);
                vidLink.set({"Url": videoUrl});
                await gettingVideos();
                setState(() {
                  videoUploading = false;
                });
              }
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: videoUploading || pageLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: "${widget.heroTag}",
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: MediaQuery.of(context).size.width * 3 / 4,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                          ),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage(widget.userDetails["Image"]),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            border: TableBorder.all(
                                borderRadius: BorderRadius.circular(15),
                                color: CupertinoColors.systemBlue),
                            columns: [
                              DataColumn(
                                  label: Text("Name ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20))),
                              DataColumn(
                                  label: Text(widget.userDetails["Name"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20))),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text("Age",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                                DataCell(Text(widget.userDetails["Age"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("Phone",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                                DataCell(Text(widget.userDetails["Phone"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("E-mail",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                                DataCell(Text(widget.userDetails["E-mail"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("User Id",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                                DataCell(Text(widget.userId,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                              ]),
                            ]),
                      ),
                      ...List.generate(videoBeingPlayedNow.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: singleChildRenderObjectWidget(index: index),
                          ))
                    ],
                  ),
                ),
        ));
  }

  SingleChildRenderObjectWidget singleChildRenderObjectWidget(
      {required int index}) {
    if (videoBeingPlayedNow.length != 0) {
      if (videoBeingPlayedNow[index].value.isInitialized) {
        return AspectRatio(
          aspectRatio: videoBeingPlayedNow[index].value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  videoBeingPlayedNow[index].value.isPlaying
                      ? videoBeingPlayedNow[index].pause()
                      : videoBeingPlayedNow[index].play();
                  setState(() {});
                },
                child: VideoPlayer(
                  videoBeingPlayedNow[index],
                ),
              ),
              Icon(
                videoBeingPlayedNow[index].value.isPlaying
                    ? CupertinoIcons.play_arrow_solid
                    : CupertinoIcons.pause_fill,
                color: CupertinoColors.systemGrey5,
                size: 70,
              )
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }
}
