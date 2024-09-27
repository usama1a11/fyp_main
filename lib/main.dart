import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Buyer/homepage.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furnitureworldapplication/Buyer/login.dart';
import 'package:furnitureworldapplication/Buyer/register.dart';
import 'package:furnitureworldapplication/Buyer/splash.dart';
import 'package:furnitureworldapplication/Screen/home.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:furnitureworldapplication/screen/main_screen.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
// import 'package:furnitureworldapplication/welcome_pages/page_one.dart';
import 'Screen/wishprovider.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = 'pk_test_51Q0KoaRtis4wlRiU3OOA8NLcVqrKm45GhqhZqNRrtxIOrk8lNF4xutSyxXusBdaKK1uIDUBMY8Z4t0t68ShIDSFw00hpI1nLgM';
  await Firebase.initializeApp();
  await PersistentShoppingCart().init();
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_)=>CartProvider()),
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
      routes: {
        '/login': (context) => Login(), // Define your login screen here
        '/register':(context)=> Register(),
      },
      debugShowCheckedModeBanner: false,
      // home: Splash(),
      home: Splash(),
    );
  }
}



