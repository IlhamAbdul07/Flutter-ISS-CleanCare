import 'package:flutter/material.dart';
import 'package:iss_cleancare/widgets/verify_user_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _idController = TextEditingController();

  void _onLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return VerifyUserWidget(idController: _idController, onLogin: _onLogin);
  }
}
