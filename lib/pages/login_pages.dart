import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/ktextfeild.dart';
//import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  final void Function()? ontap;

  const LoginPage({Key? key, required this.ontap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void signIn() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      await Provider.of<AuthServices>(context, listen: false)
          .signIn(_emailController.text, _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      _isLoading = false; // Set loading state to false after sign-in attempt
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[400],
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat,
                  size: 100,
                  color: Colors.grey[800],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Welcome back you have been missed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                KtextField(
                    type: TextInputType.emailAddress,
                    controller: _emailController,
                    hintText: "email",
                    obscureText: false),
                const SizedBox(
                  height: 15,
                ),
                KtextField(
                    type: TextInputType.visiblePassword,
                    controller: _passwordController,
                    hintText: "password",
                    obscureText: true),
                const SizedBox(
                  height: 15,
                ),
                // Show loading indicator when _isLoading is true
                _isLoading
                    ? const CircularProgressIndicator()
                    : Kbutton(ontap: signIn, text: "Sign in"),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member? "),
                    GestureDetector(
                      onTap: widget.ontap,
                      child: const Text("Sign up ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
