import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  Map userDetails;
  String userId;

  UserDetails({required this.userDetails, required this.userId});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

// \nPhone No. : ${userDetails["Phone"].substring(0, 5)} ${userDetails["Phone"].substring(5, 10)}\nE-mail : ${userDetails["E-mail"]}\n
class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "UserDetails",
                child: Container(
                  alignment: Alignment.bottomLeft,
                  height: MediaQuery.of(context).size.width * 3 / 4,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.userDetails["Image"]),
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
                        borderRadius: BorderRadius.circular(15),color: CupertinoColors.systemBlue
                    ),
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                        DataCell(Text(widget.userDetails["Age"],
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Phone",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                        DataCell(Text(widget.userDetails["Phone"],
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("E-mail",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                        DataCell(Text(widget.userDetails["E-mail"],
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("User Id",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                        DataCell(Text(widget.userId,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                      ]),
                    ]),
              ),
            ],
          ),
        ));
  }
}
