import 'package:flutter/material.dart';
import 'package:iss_cleancare/constants/my_color.dart';
import 'package:iss_cleancare/pages/dashboard_page.dart';
import 'package:iss_cleancare/pages/profile_page.dart';
import 'package:iss_cleancare/pages/works_page.dart';
import 'package:iss_cleancare/widgets/appbar_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

var index = 0;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: [DashboardPage(), WorksPage(), ProfilePage()][index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColor.greyVariant,
        selectedItemColor: MyColor.primary,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Works',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
