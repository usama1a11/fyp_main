import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
import 'package:furnitureworldapplication/Buyer/register.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(image: AssetImage("images/splash1.png")),
            TextButton(
                style: ButtonStyle(

                ),
                onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register()));
            }, child: Text("Signup",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.w600),)),
            TextButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
            }, child: Text("Signin",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.w600),)),
          ],
        ),
      ),
    );
  }
}
