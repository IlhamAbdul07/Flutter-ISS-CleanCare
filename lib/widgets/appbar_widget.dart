import 'package:flutter/material.dart';
import 'package:iss_cleancare/constants/my_color.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.5),
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
        child: Image.asset('assets/icons/logo.png', height: 32, width: 32),
      ),
      backgroundColor: MyColor.greyVariant,
      title: const Text(
        'Clean Care',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 2.0,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
