import 'package:flutter/material.dart';
import 'package:iss_cleancare/pages/dashboard_page.dart';
import 'package:iss_cleancare/pages/login_page.dart';
import 'package:iss_cleancare/pages/main_page.dart';
import 'package:iss_cleancare/pages/profile_page.dart';
import 'package:iss_cleancare/pages/register_page.dart';
import 'package:iss_cleancare/pages/works_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISS Clean Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data! ? const MainPage() : const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/works': (context) => const WorksPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
