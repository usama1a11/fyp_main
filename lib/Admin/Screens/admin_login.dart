import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:furnitureworldapplication/Admin/Screens/admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

/*
class _AdminLoginState extends State<AdminLogin> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hiddenPassword = true;
  bool isLoading = false; // State variable for loading

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Admins');

  void loginAdmin() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Set loading to true
      });

      try {
        // Sign in the admin
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          // Check if the user exists in the "Admins" database
          final DatabaseReference adminRef = _dbRef.child(user.uid);
          final DataSnapshot adminSnapshot = await adminRef.get();

          if (adminSnapshot.exists) {
            // Update last login time if admin data already exists
            await adminRef.update({
              'lastLogin': DateTime.now().toIso8601String(),
            });
          } else {
            // If admin data does not exist, create a new record
            await adminRef.set({
              'email': user.email,
              'uid': user.uid,
              'lastLogin': DateTime.now().toIso8601String(),
              'role': 'admin',
            });
          }

          // Navigate to the Admin Dashboard Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      } finally {
        setState(() {
          isLoading = false; // Set loading to false
        });
      }
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
                gradient: LinearGradient(colors: [
                  Colors.brown,
                  Colors.brown.shade900,
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 19),
                child: Text(
                  "Welcome Back Admin\nSign In!",
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
                  key: formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.brown.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: hiddenPassword,
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
                                  hiddenPassword = !hiddenPassword;
                                });
                              },
                              icon: hiddenPassword
                                  ? Icon(Icons.visibility_off, color: Colors.grey.withOpacity(0.6))
                                  : Icon(Icons.visibility, color: Colors.brown),
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.brown.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                              onPressed: loginAdmin,
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
                      SizedBox(height: 93),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to registration page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminRegister(), // Link to Admin Register
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
            // Blur effect and CircularProgressIndicator
            if (isLoading)
              Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
*/


/*class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('admin'); // Reference to 'admin' node in Firebase


  void loginAdmin() async {
    String adminName = nameController.text.trim();  // Trim spaces from input
    String adminPassword = passwordController.text.trim();  // Trim spaces from input

    if (adminName.isNotEmpty && adminPassword.isNotEmpty) {
      // Retrieve admin credentials from Firebase Realtime Database
      DatabaseEvent event = await databaseRef.once();
      Map<dynamic, dynamic>? admin= event.snapshot.value as Map?;

      if (admin!= null) {
        // Print retrieved data for debugging
        print('Stored Admin Name: ${admin['name']}');
        print('Stored Admin Password: ${admin['password']}');

        // Use case-insensitive comparison and trim spaces
        String storedName = admin['name'].toString().trim();
        String storedPassword = admin['password'].toString().trim();

        if (storedName.toLowerCase() == adminName.toLowerCase() &&
            storedPassword == adminPassword) {
          // Successful login
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));

          // Navigate to the dashboard or home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()), // Replace with your dashboard screen
          );
        } else {
          // Invalid credentials, show an error message and stay on login screen
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
        }
      } else {
        // Show an error if admin data is null
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No admin data found')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(passwordController.runtimeType);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Admin Login',style: TextStyle(color: Colors.white),),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown.shade900),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Admin Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: loginAdmin,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.brown.shade800,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

//real function
/*
  void loginAdmin() async {
    String adminName = nameController.text;
    String adminPassword = passwordController.text;

    if (adminName.isNotEmpty && adminPassword.isNotEmpty) {
      // Retrieve admin credentials from Firebase Realtime Database
      DatabaseEvent event = await databaseRef.once();
      Map<dynamic, dynamic>? adminData = event.snapshot.value as Map?;

      if (adminData != null &&
          adminData['name'] == adminName &&
          adminData['password'] == adminPassword) {
        // Successful login
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));
        // Navigate to the dashboard or home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()), // Replace with your dashboard screen
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
  }
*/
// for credential
/*  void loginAdmin() async {
    String adminName = nameController.text;
    String adminPassword = passwordController.text;

    if (adminName.isNotEmpty && adminPassword.isNotEmpty) {
      // Retrieve admin credentials from Firebase Realtime Database
      DatabaseEvent event = await databaseRef.once();
      Map<dynamic, dynamic>? adminData = event.snapshot.value as Map?;

      if (adminData != null &&
          adminData['name'] == adminName &&
          adminData['password'] == adminPassword) {
        // Successful login
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));

        // Navigate to the dashboard or home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()), // Replace with your dashboard screen
        );
      } else {
        // Invalid credentials, show an error message and stay on login screen
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
    }
  }*/
/*void loginAdmin() async {
    String adminName = nameController.text.trim();  // Trim spaces from input
    String adminPassword = passwordController.text.trim();  // Trim spaces from input

    if (adminName.isNotEmpty && adminPassword.isNotEmpty) {
      // Retrieve admin credentials from Firebase Realtime Database
      DatabaseEvent event = await databaseRef.once();
      Map<dynamic, dynamic>? adminData = event.snapshot.value as Map?;

      if (adminData != null) {
        // Use case-insensitive comparison for name and password
        String storedName = adminData['name'].toString().trim();
        String storedPassword = adminData['password'].toString().trim();

        if (storedName.toLowerCase() == adminName.toLowerCase() &&
            storedPassword == adminPassword) {
          // Successful login
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));

          // Navigate to the dashboard or home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()), // Replace with your dashboard screen
          );
        } else {
          // Invalid credentials, show an error message and stay on login screen
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
        }
      } else {
        // Show an error if admin data is null
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No admin data found')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
    }
  }*/
class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('/admin'); // Reference to 'admin' node in Firebase

  void loginAdmin() async {
    String adminName = nameController.text.trim();  // Trim spaces from input
    String adminPassword = passwordController.text.trim();  // Trim spaces from input

    if (adminName.isNotEmpty && adminPassword.isNotEmpty) {
      try {
        // Retrieve admin credentials from Firebase Realtime Database
        DatabaseEvent event = await databaseRef.once();
        Map<dynamic, dynamic>? admin = event.snapshot.value as Map?;

        if (admin != null) {
          // Print retrieved data for debugging
          print('Stored Admin Name: ${admin['name']}');
          print('Stored Admin Password: ${admin['password']}');
          String storedName = admin['name'].toString().trim();
          String storedPassword = admin['password'].toString().trim();
          // Compare the stored credentials with the entered ones
          if (storedName.toLowerCase() == adminName.toLowerCase() &&
              storedPassword == adminPassword) {
            // Successful login
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));

            // Navigate to the dashboard or home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()), // Replace with your dashboard screen
            );
          } else {
            // Invalid credentials, show an error message and stay on login screen
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
          }
        } else {
          // Show an error if admin data is null
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No admin data found')));
        }
      } catch (e) {
        // Handle any errors during the Firebase data retrieval
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error retrieving data: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(passwordController);
    // print(nameController);
    // print()
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Admin Login',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin Login',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Admin Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: loginAdmin,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding:
                  EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.brown.shade800,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
