import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UserDetails.dart';
import 'User Registration Page.dart';
import 'Users.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            const BorderSide(color: CupertinoColors.systemBlue, width: 2));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            background: Colors.white, primary: CupertinoColors.systemBlue,),
        appBarTheme: AppBarTheme(backgroundColor: CupertinoColors.systemBlue),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white60,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10)))),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                side: const BorderSide(color: CupertinoColors.systemBlue, width: 2),
                backgroundColor: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          errorBorder: borderStyle,
          focusedBorder: borderStyle,
          enabledBorder: borderStyle,
        ),
        useMaterial3: true,
      ),
      initialRoute: "UserRegistration",
      routes: {
        "UserRegistration": (context) => UserRegistration(),
        "Users": (context) => Users(),
      },
    );
  }
}
