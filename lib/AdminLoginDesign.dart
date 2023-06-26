
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLoginDesign extends StatelessWidget {
  const AdminLoginDesign({
    super.key,
    required GlobalKey<FormState> adminValidation,
    required this.adminMail,
    required this.adminPass,
  }) : _adminValidation = adminValidation;

  final GlobalKey<FormState> _adminValidation;
  final TextEditingController adminMail;
  final TextEditingController adminPass;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _adminValidation,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Column(
                  children: [
                    ImageIcon(
                      AssetImage("assets/images/dbadmin.png"),
                      color: CupertinoColors.systemBlue,
                      size: 270,
                    ),
                    Text(
                      "Admin Login",
                      style: TextStyle(
                          color: CupertinoColors.systemBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              TextFormField(
                controller: adminMail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: "Email : ",
                    filled: true,
                    fillColor: Colors.white),
                validator: (mail) {
                  if (mail!.isNotEmpty) {
                    if (mail.toLowerCase() == "dbadmin@gajera.com") {
                      return null;
                    } else {
                      return "! E-mail is wrong !";
                    }
                  } else {
                    return "E-mail can't be empty !!";
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: adminPass,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validator: (password) {
                  if (password!.isNotEmpty) {
                    if (password == "Minato#001") {
                      return null;
                    } else {
                      return "! Wrong Password !";
                    }
                  } else {
                    return "Email can't be empty";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Password : ",
                    filled: true,
                    fillColor: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    // if (_adminValidation.currentState!.validate()) {
                    //   adminMail.clear();
                    //   adminPass.clear();
                    //   Navigator.pushNamed(context, "Users");
                    // }
                    if (true) {
                      adminMail.clear();
                      adminPass.clear();
                      Navigator.pushNamed(context, "Users");
                    }
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}