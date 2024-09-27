import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Screen/main_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    goHome();
    super.initState();
  }
  void goHome() async{
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Image.asset("images/logo.png"),
            ),
          ]
        ),
      ),
    );
  }
}
