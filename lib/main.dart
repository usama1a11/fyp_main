import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_dashboard.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_login.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
import 'package:furnitureworldapplication/Buyer/register.dart';
import 'package:furnitureworldapplication/Buyer/splash.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'Screen/wishprovider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PersistentShoppingCart().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/selection': (context) => SelectionScreen(),
        '/buyer_home': (context) => HomeScreen(),
        '/admin_Dashboard': (context) => AdminDashboard(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/admin': (context) => AdminLogin(),
      },
      debugShowCheckedModeBanner: false,
      // home: AdminLogin(), // Start with the Splash screen
    );
  }
}
//genmen
class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Panel",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.brown,
          centerTitle: true,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),  // Navigate to Buyer panel
                  );
                },
                child: Text('Buyer Panel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLogin()),  // Navigate to Admin panel
                  );
                },
                child: Text('Admin Panel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();  // Check login status when the screen is loaded
  }

  // Check login status from SharedPreferences
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navigate to Dashboard if user is already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),  // Replace this with your dashboard screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Panel",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.brown,
          centerTitle: true,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),  // Navigate to Buyer panel (Login screen)
                  );
                },
                child: Text('Buyer Panel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLogin()),  // Navigate to Admin panel (Admin login)
                  );
                },
                child: Text('Admin Panel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
//real code for sele..
/*class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Panel"),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/buyer_home');  // Navigate to Buyer panel
              },
              child: Text('Go to Buyer Panel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin_Dashboard');  // Navigate to Admin panel
              },
              child: Text('Go to Admin Panel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_dashboard.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_login.dart';
import 'package:furnitureworldapplication/Admin/Screens/adminregister.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
import 'package:furnitureworldapplication/Buyer/register.dart';
import 'package:furnitureworldapplication/Buyer/splash.dart';
import 'package:furnitureworldapplication/Screen/a_home.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:furnitureworldapplication/screen/main_screen.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
// import 'package:furnitureworldapplication/welcome_pages/page_one.dart';
import 'Screen/wishprovider.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PersistentShoppingCart().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(), // Define your login screen here
        '/register':(context)=> Register(),
        '/': (context) => AdminLogin(),
        'admin_Register': (context) => AdminRegister(),
        '/admin_Dashboard': (context) => AdminDashboard(),
      },
      debugShowCheckedModeBanner: false,
      // home: Splash(),
      home: Splash(),
    );
  }
}*/
