/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Admin/categories/all.dart';
import 'package:furnitureworldapplication/Admin/categories/bed.dart';
import 'package:furnitureworldapplication/Admin/categories/chair.dart';
import 'package:furnitureworldapplication/Admin/categories/sofa.dart';
import 'package:furnitureworldapplication/Admin/categories/table.dart';
import 'package:furnitureworldapplication/Admin/homepage.dart';
import 'package:provider/provider.dart';
import 'package:furnitureworldapplication/Admin/detail.dart';
import 'package:furnitureworldapplication/Colors/app_color.dart';
import 'package:furnitureworldapplication/Screen/constants.dart';
import 'package:furnitureworldapplication/models/categories_icon.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Screen/cart.dart';
import '../../Screen/home.dart';
import '../../Screen/profile.dart';
import '../../Screen/wishlist.dart';
import '../../Screen/wishprovider.dart';
class Table1 extends StatefulWidget {
  const Table1({super.key});

  @override
  State<Table1> createState() => _Table1State();
}

class _Table1State extends State<Table1> {
  int currentindex = 2;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/1.85,
                  width: double.infinity,
                  child: GridView.builder(
                    itemCount: TableProducts.length,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 310,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return gridViewCard(TableProducts[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget gridViewCard(Products products) {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('Wishlist');

    void _toggleFavorite(bool isFavorite) async {
      if (isFavorite) {
        // Remove specific item from Firebase
        await _databaseReference
            .orderByChild("id")
            .equalTo(products.id)
            .once()
            .then((snapshot) {
          for (var child in snapshot.snapshot.children) {
            child.ref.remove(); // Remove the specific item
          }
        }).then((value) {
          Fluttertoast.showToast(msg: "Removed from Wishlist");
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: "Something went wrong");
        });
      } else {
        // Add to Firebase
        String id = _databaseReference.push().key.toString();
        await _databaseReference.child(id).set({
          "Title": products.title,
          "Image": products.image,
          "Price": products.price,
          "Description": products.description,
          "id": products.id,
          "Id": id,
        }).then((value) {
          Fluttertoast.showToast(msg: "Added to Wishlist");
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: "Something went wrong");
        });
      }
    }

    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final isSelected = wishlistProvider.isInWishlist(products.id);
        return Stack(
          children: [
            Container(
              height: 400,
              width: 200,
              color: Colors.brown.withOpacity(0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          wishlistProvider.toggleWishlist(products.id);
                          _toggleFavorite(isSelected);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: isSelected ? Colors.red : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                  products: Products(
                                    title: products.title,
                                    price: products.price,
                                    image: products.image,
                                    id: products.id,
                                    review: '',
                                    description: products.description,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            width: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(products.image),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      products.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      products.price,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 16),
                            Icon(Icons.star, color: Colors.white, size: 16),
                            Icon(Icons.star, color: Colors.white, size: 16),
                            Icon(Icons.star, color: Colors.white, size: 16),
                            Icon(Icons.star, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // Add to cart functionality
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 20,
                                  ),
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
          ],
        );
      },
    );
  }
}
*/
