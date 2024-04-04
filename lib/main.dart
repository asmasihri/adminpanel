import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parck_ease_admin_panel/constants.dart';
import 'package:parck_ease_admin_panel/controllers/MenuAppController.dart';
import 'package:parck_ease_admin_panel/screens/Login.dart';
import 'package:parck_ease_admin_panel/screens/main/main_screen.dart';
import 'package:parck_ease_admin_panel/screens/simple_ui.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAWndRPLcQyvfDV8Rzgk-SgJ_dJ8dQpmbo",
        authDomain: "park-ease-b0335.firebaseapp.com",
        projectId: "park-ease-b0335",
        storageBucket: "park-ease-b0335.appspot.com",
        messagingSenderId: "529813255321",
        appId: "1:529813255321:web:581ea032cd8eb5b85e3408",
        measurementId: "G-TQFX11JT4E"
        ),
  );
  Get.put(SimpleUIController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),

      // home: MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(
      //       create: (context) => MenuAppController(),
      //     ),
      //   ],
      //   // child: MainScreen(),
      //   child: MainScreen(),
      // ),

      home: LoginView(),
    );
  }
}
