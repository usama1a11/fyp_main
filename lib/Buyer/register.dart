/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
import '../Screen/a_home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final namec = TextEditingController();
  final addressc = TextEditingController();
  final emailc = TextEditingController();
  final passwordc = TextEditingController();
  final firebaseauth = FirebaseAuth.instance;
  bool hidden = true;

  void Display() {
    firebaseauth.createUserWithEmailAndPassword(
      email: emailc.text.toString(),
      password: passwordc.text.toString(),
    ).then((value) {
      Fluttertoast.showToast(msg: "User Registered");
      FirebaseDatabase.instance
          .ref('Register/${value.user?.uid}')
          .set({
        'name': namec.text.toString(),
        'address': addressc.text.toString(),
        'email': emailc.text.toString(),
        'password': passwordc.text.toString(),
        'userId': value.user?.uid,
      })
          .then((_) {
        // Navigate to the login screen after successful registration and data save
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(msg: "Error saving data: $error");
      });
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          // Email is already in use, show a message but do not navigate to login
          Fluttertoast.showToast(
              msg: "Email already in use. Please use a different email.");
        } else {
          // Handle other Firebase authentication errors
          Fluttertoast.showToast(
              msg: "Something went wrong: ${error.message}");
        }
      } else {
        // Handle any other types of errors
        Fluttertoast.showToast(msg: "An unexpected error occurred.");
      }
    });
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
                gradient: LinearGradient(colors: [
                  Colors.brown,
                  Colors.brown.shade900,
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 19),
                child: Text(
                  "Hello\nSign up!",
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
                height: double.infinity,
                width: double.infinity,
                child: Form(
                  key: formkey,
                  child: ListView(
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: namec,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check),
                            label: Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.brown.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: addressc,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter address";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check),
                            label: Text(
                              "Address",
                              style: TextStyle(
                                color: Colors.brown.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: emailc,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check),
                            label: Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.brown.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: passwordc,
                          obscureText: hidden,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidden = !hidden;
                                });
                              },
                              icon: hidden
                                  ? Icon(Icons.visibility_off,
                                  color: Colors.grey.withOpacity(0.6))
                                  : Icon(Icons.visibility,
                                  color: Colors.brown),
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
                      SizedBox(height: 40),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: [
                              Colors.brown.shade900,
                              Colors.brown,
                            ]),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  Display();
                                }
                              },
                              child: Text(
                                "SIGN UP",
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
                      SizedBox(height: 93),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:furnitureworldapplication/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Adjust this import according to your project structure

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final namec = TextEditingController();
  final addressc = TextEditingController();
  final emailc = TextEditingController();
  final passwordc = TextEditingController();
  final firebaseauth = FirebaseAuth.instance;
  bool hidden = true;

  void Display() async {
    if (formkey.currentState!.validate()) {
      try {
        UserCredential value = await firebaseauth.createUserWithEmailAndPassword(
          email: emailc.text.trim(),
          password: passwordc.text.trim(),
        );
        // Save user data to Firebase Database
        await FirebaseDatabase.instance.ref('Register/${value.user?.uid}').set({
          'name': namec.text.trim(),
          'address': addressc.text.trim(),
          'email': emailc.text.trim(),
          'password': passwordc.text.trim(),
          'userId': value.user?.uid,
        });

        // Store user session data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', value.user?.uid ?? ''); // Store userId if needed

        Fluttertoast.showToast(msg: "User Registered");
        // Navigate to the login screen after successful registration and data save
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      } catch (error) {
        if (error is FirebaseAuthException) {
          if (error.code == 'email-already-in-use') {
            Fluttertoast.showToast(msg: "Email already in use. Please use a different email.");
          } else {
            Fluttertoast.showToast(msg: "Something went wrong: ${error.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "An unexpected error occurred.");
        }
      }
    }
  }
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.brown,
                    Colors.brown.shade900,
                  ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 19),
                  child: Text(
                    "Hello\nSign up!",
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
                  height: double.infinity,
                  width: double.infinity,
                  child: Form(
                    key: formkey,
                    child: ListView(
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: namec,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.check),
                              label: Text(
                                "Name",
                                style: TextStyle(
                                  color: Colors.brown.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: addressc,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.check),
                              label: Text(
                                "Address",
                                style: TextStyle(
                                  color: Colors.brown.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: emailc,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.check),
                              label: Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.brown.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: passwordc,
                            obscureText: hidden,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidden = !hidden;
                                  });
                                },
                                icon: hidden
                                    ? Icon(Icons.visibility_off, color: Colors.grey.withOpacity(0.6))
                                    : Icon(Icons.visibility, color: Colors.brown),
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
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.brown.shade900,
                                Colors.brown,
                              ]),
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  Display();
                                },
                                child: Text(
                                  "SIGN UP",
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
                        SizedBox(height: 93),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()),
                                    );
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 15),
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
    );
  }
}
