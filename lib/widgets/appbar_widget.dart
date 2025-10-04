import 'package:flutter/material.dart';
import 'package:iss_cleancare/constants/my_color.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: null,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/logo.png', height: 40, width: 40),
          const SizedBox(width: 8),
          const Text(
            'Clean Care',
            style: TextStyle(
              color: MyColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey.shade300, height: 1.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
