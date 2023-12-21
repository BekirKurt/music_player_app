import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:music_player_app/views/main_home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music Player App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.white),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Colors.white),
            bodyMedium:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          )),
      home: const MainHomeView(),
    );
  }
}
