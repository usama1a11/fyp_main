/*import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Colors/app_color.dart';
import 'package:furnitureworldapplication/Screen/constants.dart';
import 'package:furnitureworldapplication/Screen/home.dart';
import 'package:furnitureworldapplication/Screen/wishprovider.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class Detail extends StatefulWidget {
  final Products products;
  const Detail({Key? key,required this.products}) : super(key: key);
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int isselected=0;
  bool isFavorite = false;
  late Products products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:      Colors.brown.withOpacity(0.4),
      body: Container(
        padding: EdgeInsets.only(top: defaultPadding * 4,
            bottom: defaultPadding * 2,
            left: defaultPadding,
            right: defaultPadding),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      padding: EdgeInsets.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Image.asset(widget.products.image),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0,left: 10.0,bottom: 10.0,right: 10.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(80)),
                              ),
                              child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                icon:Icon(Icons.arrow_back_ios_new, size: 25,color: Colors.black,),
                              ),
                            ),
                            Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(80)),
                                ),
                                child: IconButton(
                                  onPressed: (){

                                  },
                                  icon:  Icon(Icons.favorite,),
                                    color: Colors.white,
                                ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                // padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Text(widget.products.review, style: GoogleFonts.ubuntu(
                        color: Colors.black, fontSize: 16),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.products.title,
                          style: GoogleFonts.ubuntu(color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(widget.products.price,
                          style: GoogleFonts.ubuntu(color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                          height: 150,
                          width: 350,
                          decoration: BoxDecoration(
                           color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text("Description:",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),   textAlign: TextAlign.left,),
                                ),
                                Text(widget.products.description,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ubuntu(
                                      color: Colors.black,
                                      fontSize: 16,
                                      ),
                                 ),
                              ],
                            ),
                          ),
                        ),
                    SizedBox(
                      height: 5,
                    ),
                       Text("Review",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 18),
                        Icon(Icons.star, color: Colors.yellow, size: 18),
                        Icon(Icons.star, color: Colors.yellow, size: 18),
                        Icon(Icons.star, color: Colors.yellow, size: 18),
                        Icon(Icons.star, color: Colors.grey, size: 18),
                        Text("(4)"),
                      ],
                    ),
                    SizedBox(height: 5,)
                        ],
                       ),
                      ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        color: Colors.grey.withOpacity(0.2),
        child: Container(
          width: double.infinity,
           child: Column(
             children: [
               Container(
                 height: 56,
                 width: 140,
                 // color: Colors.brown,
                 decoration: BoxDecoration(
                   color: Colors.brown.withOpacity(0.4),
                   borderRadius: BorderRadius.all(Radius.circular(25))
                 ),
                 child: TextButton(
                   onPressed: (){},
                   child: Text("Add To Cart",style: GoogleFonts.ubuntu(
                     color: Colors.black,
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                   ),),
                 ),
               ),
             ],
           ),
        ),
      ),
    );
  }
}*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Screen/cart.dart';
// import 'package:furnitureworldapplication/Screen/cart_provider.dart';
import 'package:furnitureworldapplication/Screen/constants.dart';
import 'package:furnitureworldapplication/Screen/wishprovider.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';

class Detail extends StatefulWidget {
  late final Products products;

  Detail({required this.products});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('Wishlist');

  @override
  int currentindex=1;
  Widget build(BuildContext context) {
    // final provider=CartProvider.of(context);
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final isInWishlist = wishlistProvider.isInWishlist(widget.products.id);

        void toggleWishlist() {
          if (isInWishlist) {
            // Remove from wishlist in Firebase
            databaseReference.child(widget.products.id).remove().then((_) {
              wishlistProvider.toggleWishlist(widget.products.id); // Update local state
              Fluttertoast.showToast(msg: "Removed from wishlist");
            }).onError((error, stackTrace) {
              Fluttertoast.showToast(msg: "Failed to remove from wishlist");
            });
          } else {
            // Add to wishlist in Firebase
            databaseReference.child(widget.products.id).set({
              'Id': widget.products.id,
              'Title': widget.products.title,
              'Description': widget.products.description,
              'Price': widget.products.price,
              'Image': widget.products.image,
            }).then((_) {
              wishlistProvider.toggleWishlist(widget.products.id); // Update local state
              Fluttertoast.showToast(msg: "Added to wishlist");
            }).onError((error, stackTrace) {
              Fluttertoast.showToast(msg: "Failed to add to wishlist");
            });
          }
        }

        return Scaffold(
          // Your existing UI code...
          body: Container(
            padding: EdgeInsets.only(
              top: defaultPadding * 4,
              bottom: defaultPadding * 2,
              left: defaultPadding,
              right: defaultPadding,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: EdgeInsets.all(defaultPadding / 2),
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Image.asset(widget.products.image),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            bottom: 10.0,
                            right: 10.0
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(80)),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(80)),
                                ),
                                child: IconButton(
                                  onPressed: toggleWishlist,
                                  icon: Icon(
                                    Icons.favorite,
                                    color: isInWishlist ? Colors.red : Colors.white, // Color changes based on state
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
                // Rest of your UI...
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.products.title,
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.products.price.toString(),
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 150,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    "Description:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Text(
                                  widget.products.description,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Review",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 18),
                            Icon(Icons.star, color: Colors.yellow, size: 18),
                            Icon(Icons.star, color: Colors.yellow, size: 18),
                            Icon(Icons.star, color: Colors.yellow, size: 18),
                            Icon(Icons.star, color: Colors.grey, size: 18),
                            Text("(4)"),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
          bottomSheet: BottomAppBar(
            color: Colors.grey.withOpacity(0.2),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                    PersistentShoppingCart().showAndUpdateCartItemWidget(
                      inCartWidget: Center(
                        child: Container(
                          height: 38,
                          width: 115,
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.4),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: (){
                              PersistentShoppingCart().removeFromCart(widget.products.id).then((value){
                                Fluttertoast.showToast(msg: "Product remove from cart");
                              }).onError((error,stackTrace){
                                Fluttertoast.showToast(msg: "Product not remove to cart $error");
                              });
                            },
                            child: Center(child: Text("Remove",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                          ),
                        ),
                      ),
                      notInCartWidget: Center(
                        child: Container(
                          height: 40,
                          width: 125,
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.4),
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: (){
                              PersistentShoppingCart().addToCart(
                                PersistentShoppingCartItem(
                                  productId: widget.products.id,
                                  productName: widget.products.title,
                                  productDescription: widget.products.description,
                                  unitPrice: double.parse(widget.products.price.toString()),
                                  productThumbnail: widget.products.image,
                                  quantity: widget.products.quantity,
                                ),
                              ).then((value){
                                Fluttertoast.showToast(msg: "Product add into cart");
                              }).onError((error,stackTrace){
                                Fluttertoast.showToast(msg: "Product not added to cart $error");
                              });
                            },
                            child: Center(child: Text("Add to cart",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                          ),
                        ),
                      ),
                      product: PersistentShoppingCartItem(
                        productId: widget.products.id,
                        productName: widget.products.title,
                        productDescription: widget.products.description,
                        unitPrice: double.parse(widget.products.price.toString()),
                        productThumbnail: widget.products.image,
                        quantity: widget.products.quantity,
                      ),
                    ),
                  ),
                    /* Align(
                          alignment: Alignment.centerRight,
                          child: PersistentShoppingCart().showAndUpdateCartItemWidget(
                            inCartWidget: GestureDetector(
                              onTap: (){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Product added to cart'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                              },
                              child: Center(
                                child: Container(
                                  height: 38,
                                  width: 115,
                                  decoration: BoxDecoration(
                                    color: Colors.brown.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            notInCartWidget: Center(
                              child: Container(
                                height: 40,
                                width: 125,
                                decoration: BoxDecoration(
                                  color: Colors.brown.withOpacity(0.4),
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Center(
                                    child: Text(
                                      'Add To Cart',
                                      style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            product: PersistentShoppingCartItem(
                              productId: widget.products.id,
                              productName: widget.products.title,
                              productDescription: widget.products.description,
                              unitPrice: double.parse(widget.products.price.toString()),
                              productThumbnail: widget.products.image,
                              quantity: widget.products.quantity,
                            ),
                          ),
                        ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
