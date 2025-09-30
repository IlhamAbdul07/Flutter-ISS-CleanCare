import 'package:flutter/material.dart';
import 'package:iss_cleancare/pages/dashboard_page.dart';
import 'package:iss_cleancare/pages/main_page.dart';
import 'package:iss_cleancare/pages/profile_page.dart';
import 'package:iss_cleancare/pages/register_page.dart';
import 'package:iss_cleancare/pages/works_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISS Clean Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/works': (context) => const WorksPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
