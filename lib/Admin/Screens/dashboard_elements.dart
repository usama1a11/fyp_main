import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Admin/Screens/admin_order.dart';
import 'package:furnitureworldapplication/Admin/Screens/adminprofile.dart';
import 'package:furnitureworldapplication/Admin/Screens/reports.dart';
import 'package:furnitureworldapplication/Admin/components/productListPage.dart';
import 'package:furnitureworldapplication/Screen/home.dart';
import 'Review.dart';
import 'add_product_page.dart';
import 'a_home.dart';

class DashboardElements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Add Products
            DashboardGridItem(
              icon: Icons.add_circle,
              title: "Add Products",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
            ),
            // Admin Items
            DashboardGridItem(
              icon: Icons.supervised_user_circle,
              title: "Admin Items",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHome()),
                );
              },
            ),
            // All Orders
            DashboardGridItem(
              icon: Icons.update,
              title: "All Order",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Order()),
                );
              },
            ),
            // Admin Profile
            DashboardGridItem(
              icon: Icons.reviews,
              title: "Admin Profile",
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminProfile()),
                );
              },
            ),
            // Review
            DashboardGridItem(
              icon: Icons.analytics,
              title: "Review",
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminReview()),
                );
              },
            ),
            // Reports
            DashboardGridItem(
              icon: Icons.bookmarks_outlined,
              title: "Reports",
              color: Colors.pinkAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminReports()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for Grid Item
class DashboardGridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Function() onTap;

  const DashboardGridItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}