import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
import 'package:furnitureworldapplication/Buyer/recover.dart';
import 'package:furnitureworldapplication/Buyer/register.dart';
// import 'package:furnitureworldapplication/Admin/homepage.dart';
// import 'package:furnitureworldapplication/Admin/recover.dart';
// import 'package:furnitureworldapplication/Admin/register.dart';
// import 'package:furnitureworldapplication/Admin/welcome.dart';
import 'package:furnitureworldapplication/Screen/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final emailc = TextEditingController();
  final passwordc = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  bool hidden = true;

  void CAR() {
    if (formkey.currentState!.validate()) {
      firebaseAuth.signInWithEmailAndPassword(
        email: emailc.text.toString(),
        password: passwordc.text.toString(),
      ).then((value) {
        Fluttertoast.showToast(msg: "User registered"); // Show success message
        FirebaseDatabase.instance.ref('Login/${value.user?.uid}').set({
          'email': emailc.text.toString(),
          'password': passwordc.text.toString(),
          'userId': value.user?.uid,
        }).then((_) {
          Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: "Error saving data: $error");
        });
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(msg: "Something went wrong: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // for remove overflow
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown,
                        Colors.brown.shade900,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 19),
                    child: Text(
                      "Hello\nSign in!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white,
                    ),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 18.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              controller: emailc,
                              obscureText: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.check),
                                label: Text(
                                  "Gmail",
                                  style: TextStyle(
                                    color: Colors.brown.shade500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 18.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              controller: passwordc,
                              obscureText: hidden,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidden = !hidden;
                                    });
                                  },
                                  icon: hidden
                                      ? Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey.withOpacity(0.6),
                                  )
                                      : Icon(
                                    Icons.visibility,
                                    color: Colors.brown.shade500,
                                  ),
                                ),
                                label: Text(
                                  "Password",
                                  style: TextStyle(
                                    color: Colors.brown.shade500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: TextButton(
                                onPressed: () {
                                  // Forgot Password logic
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Recover()));
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.brown.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.brown.shade800,
                                    Colors.brown,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      CAR();
                                    }
                                  },
                                  child: Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Register(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*class _LoginState extends State<Login> {
  final formkey=GlobalKey<FormState>();
  final emailc=TextEditingController();
  final passwordc=TextEditingController();
  final firebaseAuth=FirebaseAuth.instance;
  bool hidden=true;
  void CAR(){
    if(formkey.currentState!.validate()){
      firebaseAuth.signInWithEmailAndPassword(email: emailc.text.toString(), password: passwordc.text.toString()).then((value){
        Fluttertoast.showToast(msg: "User registerd");
      }).onError((error, stackTrace){
        Fluttertoast.showToast(msg: "Something went wrong");
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff881736),
                        Color(0xff281537),
                      ]
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0,left: 19),
                  child: Text("Hello\nSign in!",style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 160.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child:  Form(
                    key: formkey,
                    child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                            child: TextFormField(
                              controller: emailc,
                              obscureText: false,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please enter email";
                                }
                                else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.check),
                                label: Text("Gmail",style: TextStyle(color: Color(0xff881736),fontWeight: FontWeight.bold,),)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                            child: TextFormField(
                              controller: passwordc,
                              obscureText: hidden,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "please enter password";
                                }
                                else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: (){
                                     setState(() {
                                       hidden=!hidden;
                                     });
                                  },
                                  icon: hidden?Icon(Icons.visibility_off,color: Colors.blue.withOpacity(0.6),):Icon(Icons.visibility,color: Colors.black.withOpacity(0.6),),
                                ),
                                  label: Text("Password",style: TextStyle(color: Color(0xff881736),fontWeight: FontWeight.bold),)

                              ),

                              *//*decoration: InputDecoration(
                                suffixIcon: Icon(Icons.visibility_off,color: Color(0xff2c38e),),
                                label: Text("Password",style: TextStyle(color: Color(0xff881736),fontWeight: FontWeight.bold),)
                              ),*//*
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: TextButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Recover()));
                                 },
                                child: Text("Forgot Password?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Color(0xff281537)),)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0,left: 18.0),
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff881736),
                                      Color(0xff281537),
                                    ]
                                )
                              ),
                              child: Center(
                                  child: TextButton(
                                    onPressed: (){
                                      setState((){

                                      });
                                      if(formkey.currentState!.validate()) {
                                        CAR();
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                                      }
                                     *//* if(formkey.currentState!.validate()){
                                        firebaseAuth.signInWithEmailAndPassword(email: emailc.text.toString(), password: passwordc.text.toString()).then((value){
                                          Fluttertoast.showToast(msg: "User registerd");
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Welcome()));
                                        }).onError((error, stackTrace){
                                          Fluttertoast.showToast(msg: "Something went wrong");
                                        });
                                      }*//*
                                    }
                                    ,child: Text("SIGN IN",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17)),)),
                            ),
                          ),
                          SizedBox(
                            height: 215,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  Text("Don't have account?",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                                  TextButton(
                                      onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                                  },
                                    child: Text("Sign up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 170,
              // ),
            ],
          ),
        )
    );
  }
}*/
