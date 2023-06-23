// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserDetails extends StatefulWidget {
  Map userDetails;
  String userId;
  UpdateUserDetails({super.key, required this.userDetails,required this.userId});

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController age = TextEditingController();

  bool photoUpdated = false;
  bool submitted = false;

  GlobalKey<FormState> _validation = GlobalKey<FormState>();

  XFile? profilePhoto;

  String downloadURL = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.userDetails["Name"];
    age.text = widget.userDetails["Age"];
    email.text = widget.userDetails["E-mail"];
    phone.text = widget.userDetails["Phone"];
    downloadURL = widget.userDetails["Image"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update User Details"),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _validation,
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            photoUpdated = true;
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                elevation: 5,
                                enableDrag: true,
                                context: context,
                                builder: (context) => Container(
                                      color: Colors.white30,
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                "Choose Profile Photo From : ",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ButtonBar(
                                            alignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    await pickTheImage(
                                                        src: ImageSource.camera);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.camera_alt),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text("Camera")
                                                      ],
                                                    ),
                                                  )),
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    await pickTheImage(
                                                        src: ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.photo_library),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text("Gallery")
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: backgroundImage(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (name) {
                          if (name!.isNotEmpty) {
                            return null;
                          } else {
                            return "Name can't be empty !!";
                          }
                        },
                        controller: name,
                        decoration: const InputDecoration(labelText: "Name : "),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (mail) {
                          if (mail!.isNotEmpty) {
                            if (RegExp(r"[a-z0-9]+@[a-z]+\.[a-z]{2,3}")
                                .hasMatch(mail)) {
                              return null;
                            } else {
                              return "E-mail is in-appropriate !!";
                            }
                          } else {
                            return "E-mail can't be empty !!";
                          }
                        },
                        controller: email,
                        decoration: const InputDecoration(labelText: "E-mail : "),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (no) {
                          if (no!.isNotEmpty) {
                            if (no.length == 10) {
                              return null;
                            } else {
                              return "Phone No. must be of 10 digits only !!";
                            }
                          } else {
                            return "Phone No. can't be empty !!";
                          }
                        },
                        controller: phone,
                        decoration: const InputDecoration(labelText: "Phone : "),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (age) {
                          if (age!.isNotEmpty) {
                            if (age != "0") {
                              if (age.length <= 3) {
                                return null;
                              } else {
                                return "A person age can't be higher than 999 ";
                              }
                            } else {
                              return "Age can't be zero !!";
                            }
                          } else {
                            return "Age can't be empty !!";
                          }
                        },
                        keyboardType: TextInputType.number,
                        controller: age,
                        decoration: const InputDecoration(labelText: "Age : "),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_validation.currentState!.validate()) {
                              try {
                                setState(() {
                                  submitted = true;
                                });
                                var insertProfilePic = FirebaseStorage.instance
                                    .ref()
                                    .child("ProfilePictures")
                                    .child(email.text);
                                if (profilePhoto != null) {
                                  await insertProfilePic
                                      .putFile(File(profilePhoto!.path));
                                }
                                 downloadURL = profilePhoto != null
                                    ? await insertProfilePic.getDownloadURL()
                                    : widget.userDetails["Image"];

                                DocumentReference insertUser = FirebaseFirestore
                                    .instance
                                    .collection("UserDataBase")
                                    .doc(widget.userId);
                                await insertUser.update({
                                  "Image": downloadURL,
                                  "Name": name.text,
                                  "E-mail": email.text,
                                  "Phone": phone.text,
                                  "Age": age.text,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Update success !!")));
                                name.clear();
                                age.clear();
                                phone.clear();
                                email.clear();
                                profilePhoto = null;
                                setState(() {
                                  submitted = false;
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(e.toString().split("]").last)));
                                var deleteProfilePic = FirebaseStorage.instance
                                    .ref()
                                    .child("ProfilePictures");
                                deleteProfilePic.delete();
                                print(e);
                              }
                            }
                          },
                          child: const Text("Update"))
                    ],
                  ),
                ),
              ),
            ),
            submitted ? CircularProgressIndicator() : SizedBox(height: 1,width: 1,)
          ],
        ));
  }

  backgroundImage() {
    if (photoUpdated) {
      return FileImage(File(profilePhoto!.path));
    } else {
      return NetworkImage(downloadURL);
    }
  }

  pickTheImage({required ImageSource src}) async {
    ImagePicker imagePicker = ImagePicker();
    profilePhoto = await imagePicker.pickImage(source: src);
    setState(() {});
    if (profilePhoto != null) {
      print("Photo fetching success");
    }
  }
}
