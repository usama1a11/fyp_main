import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Admin/Screens/Review.dart';
import 'package:furnitureworldapplication/Admin/Screens/dashboard_elements.dart';
import 'package:furnitureworldapplication/Admin/Screens/product_list_page.dart';
import 'package:furnitureworldapplication/Admin/components/drawer.dart';
import 'package:furnitureworldapplication/main.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}
/*class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Admin Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
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
        body: DashboardElements()
      ),
    );
    }
  }*/
class _AdminDashboardState extends State<AdminDashboard> {
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
      onWillPop: _onWillPop, // Attach the custom back button handler
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Admin Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
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
          body: DashboardElements(), // Your custom widget for the dashboard
        ),
      ),
    );
  }
}
