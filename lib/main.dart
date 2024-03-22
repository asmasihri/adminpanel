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
              apiKey: "AIzaSyDz7Hv7C43H21_x57g9ywv3m7inG9UJ2i8",
              authDomain: "parking-52853.firebaseapp.com",
              projectId: "parking-52853",
              storageBucket: "parking-52853.appspot.com",
              messagingSenderId: "553083218206",
              appId: "1:553083218206:web:e86f3f66662917f91e410f",
              measurementId: "G-Y6R8Z2CSX1"),
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
