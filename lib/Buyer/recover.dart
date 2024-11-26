import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/main.dart';

class Recover extends StatefulWidget {
  const Recover({super.key});

  @override
  State<Recover> createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {
  final formkey=GlobalKey<FormState>();
  final emailc=TextEditingController();
  // final passwordc=TextEditingController();
  final firebaseauth=FirebaseAuth.instance;
  // String mediaquery="";
  Future<bool> _onWillPop() async {
    // Navigate to the SelectionScreen when back is pressed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );
    return false; // Prevent the default behavior of closing the app
  }

  @override
  Widget build(BuildContext context) {
    // double height=MediaQuery.of(context).size.height;
    // double width=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.brown,
          body: SafeArea(
            child: Expanded(
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
                          ]
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // height: MediaQuery.of(context).size.height,
                                // width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.brown.shade100,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Text("Please Enter Your Email",style: TextStyle(color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.bold,fontSize: 30),),
                                    Center(
                                      child: Form(
                                        key: formkey,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 260.0),
                                              child: Text("Email:"),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 60,
                                              width: 300,
                                              child: TextFormField(
                                                controller: emailc,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return "Please enter your email"; // Update the error message
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                // onSaved: (val)=>_email=val!,
                                                decoration: InputDecoration(
                                                  // prefixIcon: Icon(Icons.email),
                                                  hintText: 'Email',
                                                  border: OutlineInputBorder(
                                                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              width: 100,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.brown.shade300,
                                                  ),
                                                  onPressed: (){
                                                    setState(() {

                                                    });
                                                    if(formkey.currentState!.validate()){
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                                      // resetPassword();
                                                      try {
                                                        firebaseauth.sendPasswordResetEmail(email: emailc.text.toString());
                                                        Fluttertoast.showToast(msg: "Password sent to email $emailc");
                                                      } catch (error) {
                                                        Fluttertoast.showToast(msg: "Error: $error");
                                                      }
                                                    }
                                                  }, child: Text("Login",style: TextStyle(color: Colors.black),)),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

mixin orientation {

}
