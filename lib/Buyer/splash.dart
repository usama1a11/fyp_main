import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
import 'package:furnitureworldapplication/Screen/main_screen.dart';
import 'package:furnitureworldapplication/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}
//asal wala
/*class _SplashState extends State<Splash> {
  void initState() {
    goHome();
    super.initState();
  }
  void goHome() async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SelectionScreen()));
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
}*/
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    goHome();
  }
  void goHome() async {
    await Future.delayed(const Duration(seconds: 2));
    // Check the login state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // Navigate based on login state
    if (isLoggedIn) {
      // If logged in, navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your dashboard screen
      );
    } else {
      // If not logged in, navigate to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Replace with your login screen
      );
    }
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
              decoration: BoxDecoration(shape: BoxShape.circle),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Image.asset("images/logo1.png"),
            ),
          ],
        ),
      ),
    );
  }
}
//real code
/*import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
// import 'package:furnitureworldapplication/Screen/a_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furnitureworldapplication/Screen/main_screen.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Simulate loading for the splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Retrieve the login status from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to the appropriate screen
    if (isLoggedIn) {
      // Navigate to MainScreen if the user is already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Otherwise, navigate to the LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Update this with your login screen
      );
    }
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Image.asset("images/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_dashboard.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Simulate loading for the splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Retrieve the login status and role from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userRole = prefs.getString('userRole'); // Fetching the user role

    // Navigate to the appropriate screen based on the role
    if (isLoggedIn) {
      if (userRole == 'admin') {
        // Navigate to AdminDashboard if the user is an admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        // Navigate to Buyer HomePage if the user is a buyer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      // If not logged in, navigate to the Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset("images/logo.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_dashboard.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Function to check the login session
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Check if the user is logged in and navigate accordingly
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset("images/logo.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
