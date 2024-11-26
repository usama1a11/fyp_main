import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:furnitureworldapplication/Admin/categories/all.dart';
// import 'package:furnitureworldapplication/Admin/categories/bed.dart';
// import 'package:furnitureworldapplication/Admin/categories/chair.dart';
// import 'package:furnitureworldapplication/Admin/categories/sofa.dart';
// import 'package:furnitureworldapplication/Admin/categories/table.dart';
import 'package:furnitureworldapplication/Screen/cart.dart';
import 'package:furnitureworldapplication/Screen/home.dart';
import 'package:furnitureworldapplication/Screen/Order/order.dart';
import 'package:furnitureworldapplication/Screen/profile.dart';
import 'package:furnitureworldapplication/Screen/wishlist.dart';
import 'package:provider/provider.dart';
// import 'package:furnitureworldapplication/Admin/detail.dart';
import 'package:furnitureworldapplication/Colors/app_color.dart';
import 'package:furnitureworldapplication/Screen/constants.dart';
import 'package:furnitureworldapplication/models/categories_icon.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Screen/wishprovider.dart';
// import 'wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> pages = [
    Home(),
    Wishlist(),
    Cart1(),
    Profile1(),
    Order(),
  ];
  Widget bottomItem({required int index, required IconData icon}) {
    return Icon(icon, size: 30, color: _pageIndex == index ? Colors.white : Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 70.0,
        items: <Widget>[
          bottomItem(index: 0, icon: Icons.home),
          bottomItem(index: 1, icon: Icons.favorite_border),
          bottomItem(index: 2, icon: Icons.shopping_cart_outlined),
          bottomItem(index: 3, icon: Icons.person),
          bottomItem(index: 4, icon: Icons.shopping_cart_checkout),
        ],
        color: Colors.brown,
        buttonBackgroundColor: Colors.brown,
        backgroundColor: Colors.brown.withOpacity(0.5),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: pages,
      ),
    );
  }
}
/*class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    const Home(),
    const Wishlist(),
    const Cart(),
    const Profile(),
  ];
  int _pageindex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageindex,
        height: 60.0,
        items: <Widget>[
          bottomItem(index: 0, icon: Icons.home),
          bottomItem(index: 1, icon: Icons.favorite_border),
          bottomItem(index: 2, icon: Icons.shopping_cart_checkout),
          // bottomItem(index: 3, title: "Search", icon: Icons.search),
          bottomItem(index: 3, icon: Icons.person),
        ],
        color: Colors.brown,
        buttonBackgroundColor: Colors.brown,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageindex = index;
          });

        },
        letIndexChange: (index) => true,
      ),
       body: pages[_pageindex],
    );
  }
  Widget bottomItem({required int index, required IconData icon}) {
    if (index == _pageindex) {
      return Icon(
        icon,
        size: 30,
        color: Colors.white,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
          ],
        ),
      );
    }
  }
}*/

