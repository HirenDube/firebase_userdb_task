import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_userdb_task/UserDetails.dart';
import 'package:firebase_userdb_task/UpdateUserDetails.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? fetchData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataMethod();
  }

  Future<void> fetchDataMethod() async {
    fetchData = await FirebaseFirestore.instance
        .collection("UserDataBase")
        .get()
        .then((value) {
      return value.docs;
    });

   


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Users",
          style: TextStyle(color: Colors.white),
        )),
        body: StreamBuilder(
          stream: Stream<int>.periodic(Duration(milliseconds: 500),
              (computationCount) {
            fetchDataMethod();
            return computationCount;
          }),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
              ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              Map userDataOmIndex = {};
              if (fetchData != null) {
                try {
                  userDataOmIndex = fetchData![index].data();
                  return Hero(
                    tag: "$index",
                    child: ListTile(
                      onLongPress: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpdateUserDetails(
                                    userDetails: userDataOmIndex,
                                    userId: fetchData![index].id,
                                  ))),
                      onTap: () async {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => UserDetails(
                                      userDetails: userDataOmIndex,
                                      userId: fetchData![index].id,  heroTag: '$index',
                                    )));
                      },
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          "Are you sure you want to remove this user ? "),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              var deleteImage = FirebaseStorage
                                                  .instance
                                                  .ref()
                                                  .child("ProfilePictures")
                                                  .child(userDataOmIndex[
                                                      "E-mail"]);
                                              deleteImage.delete();
                                              var deleteData = FirebaseFirestore
                                                  .instance
                                                  .collection("UserDataBase")
                                                  .doc(fetchData![index].id);
                                              deleteData.delete();
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: Text("Yes")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No")),
                                      ],
                                    ));
                          },
                          icon: Icon(Icons.delete)),
                      title: Text("Name : ${userDataOmIndex["Name"]}"),
                      subtitle: Text("Age : ${userDataOmIndex["Age"]}"),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userDataOmIndex["Image"]),
                      ),
                    ),
                  );
                } catch (e) {
                  print(e);
                  return CircularProgressIndicator();
                }
              }
              return CircularProgressIndicator();
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: fetchData != null ? fetchData!.length : 0,
          ),
        ));
  }
}
