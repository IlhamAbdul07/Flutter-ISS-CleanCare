import 'package:flutter/material.dart';
import 'package:iss_cleancare/constants/dialog_box.dart';
import 'package:iss_cleancare/widgets/profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _confirmLogout(BuildContext context) async {
    debugPrint('✅ _confirmLogout() dipanggil');
    await DialogBox.showDialogConfirm(
      context: context,
      icon: const Icon(Icons.logout, color: Colors.white, size: 36),
      title: 'Logout?',
      message: 'Apakah kamu yakin ingin keluar dari akun ini?',
      mainColor: Colors.red,
      subColor: Colors.redAccent.shade100,
      confirmText: 'Ya, keluar',
      cancelText: 'Batal',
      confirmButtonColor: Colors.red.shade700,
      onConfirm: () async {
        Navigator.of(context).pop();
        await _logout(context);
      },
      onCancel: () {
        debugPrint('❌ Tombol Batal ditekan');
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    if (!mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
      // Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.white,
      ),
      body: ProfileWidget(onLogout: () => _confirmLogout(context)),
    );
  }
}
