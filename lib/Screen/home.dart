import 'dart:async';
// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Admin/Screens/a_home.dart';
import 'package:furnitureworldapplication/Buyer/detail.dart';
import 'package:furnitureworldapplication/Colors/app_color.dart';
import 'package:furnitureworldapplication/Screen/cart.dart';
import 'package:furnitureworldapplication/Screen/constants.dart';
import 'package:furnitureworldapplication/Screen/tabbar.dart';
import 'package:furnitureworldapplication/Screen/wishprovider.dart';
import 'package:furnitureworldapplication/main.dart';
import 'package:furnitureworldapplication/models/categories_icon.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CategoriesIcons {
  final IconData icon;
  final String title;

  CategoriesIcons({required this.icon, required this.title});
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final DatabaseReference _productRef = FirebaseDatabase.instance.ref('products');
  List<Map<dynamic, dynamic>> products = []; // To store products data
  List<String> wishlist = []; // To store wishlist product IDs
  List<CategoriesIcons> allCategories = [
    CategoriesIcons(icon: Icons.search, title: "All"),
    CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
    CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
    CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
    CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
  ];

  String selectedCategory = "All"; // Track the selected category
  bool isFavorite = false;
  String searchQuery = ""; // Store the search query

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    _productRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<dynamic, dynamic>> productList = [];
        data.forEach((key, value) {
          if (value != null && value['name'] != null &&
              value['price'] != null && value['stock'] != null) {
            productList.add({...value, 'id': key}); // Include product ID
          }
        });

        setState(() {
          products = productList;
        });
      }
    });
  }

  // Filter products based on the selected category and search query
  List<Map<dynamic, dynamic>> get filteredProducts {
    List<Map<dynamic, dynamic>> categoryFilteredProducts = selectedCategory == "All"
        ? products
        : products.where((product) => product['category'] == selectedCategory).toList();

    if (searchQuery.isNotEmpty) {
      return categoryFilteredProducts.where((product) =>
          product['name'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
    } else {
      return categoryFilteredProducts;
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
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Find Best\nFurnitures",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade700,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2.0,
                                  blurRadius: 4.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value; // Update the search query
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 22),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            PersistentShoppingCart().showCartItemCountWidget(
                              cartItemCountWidgetBuilder: (itemCount) => IconButton(
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) =>  Cart1()));
                                },
                                icon: Badge(
                                  label:Text(itemCount.toString()) ,
                                  child: const Icon(Icons.shopping_bag_outlined,size: 40,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 99.0),
                    child: Text(
                      "Recommend for you",
                      style: GoogleFonts.ubuntu(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: allCategories.length,
                      itemBuilder: (context, index) {
                        final category = allCategories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category.title; // Update selected category
                            });
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: selectedCategory == category.title
                                  ? Colors.brown
                                  : Colors.brown.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 4),
                                Icon(
                                  category.icon,
                                  color: selectedCategory == category.title
                                      ? Colors.white
                                      : Colors.black,
                                  size: 25,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  category.title,
                                  style: TextStyle(
                                      color: selectedCategory == category.title
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Products List
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: filteredProducts.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 335,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Container(
                            height: 100,
                            width: double.infinity,
                            color: Colors.brown.withOpacity(0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                 /* Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () => _showUpdateDialog(product),
                                        icon: Icon(Icons.update),
                                      ),
                                      //favorite ui
                                    ],
                                  ),*/
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [
                               Consumer<WishlistProvider>(
                           builder: (context, wishlistProvider, child) {
                           final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('Wishlist');
                           final bool isInWishlist = wishlistProvider.isInWishlist(product['id']);
                           void toggleWishlist() {
                           if (isInWishlist) {
                           // Remove from wishlist in Firebase
                            _databaseReference.child(product['id']).remove().then((_) {
                           wishlistProvider.toggleWishlist(product['id']); // Update local state
                            Fluttertoast.showToast(msg: "Removed from wishlist");
                            }).onError((error, stackTrace) {
                              Fluttertoast.showToast(msg: "Failed to remove from wishlist");
                            });
                           } else {
                            // Add to wishlist in Firebase
                             _databaseReference.child(product['id']).set({
                               'Id': product['id'],
                               'Title': product['name'],
                               'Description': product['description'],
                               'Price': product['price'].toString(),
                               'Image': product['imageUrl'].toString(),
                             }).then((_) {
                               wishlistProvider.toggleWishlist(product['id']); // Update local state
                               Fluttertoast.showToast(msg: "Added to wishlist");
                             }).onError((error, stackTrace) {
                               Fluttertoast.showToast(msg: "Failed to add to wishlist");
                             });
                           }
                           }
                           return IconButton(
                             onPressed: toggleWishlist,
                             icon: Icon(
                               Icons.favorite,
                               color: isInWishlist ? Colors.red : Colors.white,
                             ),
                           );
                           },
                               ),
                                    ],
                                  ),
                                  // Display product image wrapped with InkWell
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(
                                        products: Products(
                                          title: product['name']??"",
                                          price: double.parse(product['price'].toString())??0.0,
                                          image: product['imageUrl']??"".toString(),
                                          id: product['id']??"",
                                          review: product['rating']??"",
                                          description: product['description']??"",
                                          stock: product['stock'],
                                          quantity: 0,
                                        ),
                                      ),
                                        ),
                                      );
                                    },
                                    child:
                                    Container(
                                      height: 140,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: product['imageUrl'] != null &&
                                              product['imageUrl'].isNotEmpty
                                              ? NetworkImage(product['imageUrl'].toString())
                                              : AssetImage('assets/placeholder.png') as ImageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Display product details
                                  Text(
                                    product['name'] ?? 'Unnamed Product',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Price: \$${product['price'] .toString()?? 0}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  // Add other product details as needed...
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            size: 16,
                                            index < (product['rating'] ?? 0) ? Icons
                                                .star_border : Icons.star,
                                            color: Colors.white,
                                          );
                                        }),
                                      ),
                                      SizedBox(width: 11),
                                    //real code for add to cart
                                   /*   Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: PersistentShoppingCart().showAndUpdateCartItemWidget(
                                                inCartWidget: Container(
                                                  height: 36,
                                                  width: 36,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(color: Colors.red),
                                                    borderRadius: BorderRadius.circular(
                                                        20),
                                                  ),
                                                  child: IconButton(
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      PersistentShoppingCart()
                                                          .removeFromCart(product['id'])
                                                          .then((value) {
                                                        Fluttertoast.showToast(
                                                            msg: "Product removed from cart");
                                                      }).onError((error, stackTrace) {
                                                        Fluttertoast.showToast(
                                                            msg: "Product not removed from cart $error");
                                                      });
                                                    },
                                                    icon: Icon(Icons.remove),
                                                  ),
                                                ),
                                                notInCartWidget: Container(
                                                  height: 36,
                                                  width: 36,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius.circular(
                                                        20),
                                                  ),
                                                  child: IconButton(
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      PersistentShoppingCart().addToCart(
                                                        PersistentShoppingCartItem(
                                                          productId: product['id'],
                                                          productName: product['name'],
                                                          productDescription: product['description'],
                                                          unitPrice: double.parse(
                                                              product['price']
                                                                  .toString()),
                                                          productThumbnail: product['imageUrl']??"",
                                                          quantity: 1,
                                                        ),
                                                      ).then((value) {
                                                        Fluttertoast.showToast(
                                                            msg: "Product added to cart");
                                                      }).onError((error, stackTrace) {
                                                        Fluttertoast.showToast(
                                                            msg: "Product not added to cart $error");
                                                      });
                                                    },
                                                    icon: Icon(Icons.add),
                                                  ),
                                                ),
                                                product: PersistentShoppingCartItem(
                                                  productId: product['id'],
                                                  productName: product['name'],
                                                  productDescription: product['description'],
                                                  unitPrice: double.parse(
                                                      product['price'].toString()),
                                                  productThumbnail: product['imageUrl']??"",
                                                  quantity: 1,
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),*/
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: PersistentShoppingCart().showAndUpdateCartItemWidget(
                                              inCartWidget: Container(
                                                height: 36,
                                                width: 36,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.red),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: IconButton(
                                                  iconSize: 20,
                                                  onPressed: () {
                                                    PersistentShoppingCart()
                                                        .removeFromCart(product['id'])
                                                        .then((value) {
                                                      Fluttertoast.showToast(msg: "Product removed from cart");
                                                    }).onError((error, stackTrace) {
                                                      Fluttertoast.showToast(
                                                          msg: "Product not removed from cart $error");
                                                    });
                                                  },
                                                  icon: Icon(Icons.remove),
                                                ),
                                              ),
                                              notInCartWidget: Container(
                                                height: 36,
                                                width: 36,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.green),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: IconButton(
                                                  iconSize: 20,
                                                  onPressed: () {
                                                    // Check if stock is available before adding the product
                                                    if (product['stock'] > 0) {
                                                      PersistentShoppingCart().addToCart(
                                                        PersistentShoppingCartItem(
                                                          productId: product['id'],
                                                          productName: product['name'],
                                                          productDescription: product['description'],
                                                          unitPrice: double.parse(product['price'].toString()),
                                                          productThumbnail: product['imageUrl'] ?? "".toString(),
                                                          quantity: 0,
                                                        ),
                                                      ).then((value) {
                                                        Fluttertoast.showToast(msg: "Product added to cart");
                                                      }).onError((error, stackTrace) {
                                                        Fluttertoast.showToast(msg: "Product not added to cart $error");
                                                      });
                                                    } else {
                                                      // Show message that stock is low
                                                      Fluttertoast.showToast(
                                                          msg: "Stock is low. Product cannot be added to the cart.");
                                                    }
                                                  },
                                                  icon: Icon(Icons.add),
                                                ),
                                              ),
                                              product: PersistentShoppingCartItem(
                                                productId: product['id'],
                                                productName: product['name'],
                                                productDescription: product['description'],
                                                unitPrice: double.parse(product['price'].toString()),
                                                productThumbnail: product['imageUrl'] ?? "".toString(),
                                                quantity: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

