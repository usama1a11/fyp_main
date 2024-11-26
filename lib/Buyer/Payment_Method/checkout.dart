// import 'package:flutter/material.dart';
// import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
// import 'package:furnitureworldapplication/Buyer/Payment_Method/stripe_service.dart';
// class Checkout extends StatefulWidget {
//
//   @override
//   State<Checkout> createState() => _CheckoutState();
// }
//
// class _CheckoutState extends State<Checkout> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 130,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.brown.withOpacity(0.6),
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(30),
//           topLeft: Radius.circular(30),
//         ),
//       ),
//       padding: EdgeInsets.all(20),
//       child:
//       Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Total:",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 25,
//                 ),
//               ),
//               PersistentShoppingCart().showTotalAmountWidget(cartTotalAmountWidgetBuilder: (totalAmount){
//                 return Visibility(
//                     visible: totalAmount==0.0? false:true,
//                     child: Text(r"$"+totalAmount.toString(),style: TextStyle(fontSize: 20),));
//               })
//             ],
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               maximumSize: Size(double.infinity, 55),
//             ),
//             onPressed: () async{
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
              // var items = [
    // {
    // "productPrice": 4,
    // "productName": "Apple",
    // "qty": 5,
    // },
    // {
    // "productPrice": 5,
    // "productName": "Pineapple",
    // "qty": 10,
    // }
    // ];
    // await StripeService.stripePaymentCheckout(
    // items,
    // 500,
    // context,
    // mounted,
    // onSuccess: () {
    // print("SUCCESS");
    // },
    // onCancel: () {
    // print("Cancel");
    // },
    // onError: (e) {
    // print("Error: " + e.toString());
    // },
    // );
    // },
    //         child: Text("Check Out",
    //           style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 16,
    //               color: Colors.white
    //           ),),),
    //     ],
    //   ),
    // );
  // }

// Future<void> stripePaymentCheckout(
//     List<Map<String, dynamic>> items,
//     int amount,
//     BuildContext context,
//     bool mounted,
//     {required Function onSuccess, required Function onCancel, required Function onError}
//     ) async {
//
//   Check for null values if necessary
  // assert(items.isNotEmpty, 'Items cannot be empty');
  // assert(amount > 0, 'Amount must be greater than zero');
  //
  // try {
  //   Example of Stripe payment processing logic
    // print("Processing payment for amount: $amount");
    //
    // If successful
    // onSuccess();
  // } catch (e) {
  //   onError(e);
  // }
// }
// }
/*
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Screen/cart_provider.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.brown.shade100,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtotal",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "\$${provider.totalprice(Products as Products).toStringAsFixed(2)}",  // Format as currency
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.black),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "\$${provider.totalprice(Products as Products).toStringAsFixed(2)}",  // Format as currency
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade100,
                  maximumSize: Size(double.infinity, 55),
                ),
                onPressed: () {
                  // Handle check out
                },
                child: Text(
                  "Check Out",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

*/
/*
 Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Text(
                provider.totalprice().toString(),  // Format as currency
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.black),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(provider.totalprice().toString(), // Format as currency
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade100,
              maximumSize: Size(double.infinity, 55),
            ),
            onPressed: () {},
            child: Text(
              "Check Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
*//*


*/
/*
 final Widget build(BuildContext context) {
    final provider = CartProvider.of(context);

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Text(provider.totalprice().toStringAsFixed(2),  // Use toStringAsFixed(2) to format as currency
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.black),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                provider.totalprice().toStringAsFixed(2),  // Use toStringAsFixed(2) to format as currency
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade100,
              maximumSize: Size(double.infinity, 55),
            ),
            onPressed: () {},
            child: Text(
              "Check Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }*//*


*/
/*  Widget build(BuildContext context) {
    final provider=CartProvider.of(context);
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
         *//*

*/
/* TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 5,horizontal: 15,
              ),
              filled: true,
              fillColor: Colors.brown.shade100,
              hintText: "",
            ),
          ),*//*

*/
/*
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
              ),
              Text("\$${provider.totalprice().toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Divider(color: Colors.black,),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text("\$${provider.totalprice().toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade100,
              maximumSize: Size(double.infinity, 55),
            ),
            onPressed: (){},
            child: Text("Check Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white
              ),),),
        ],
      ),
    );
  }*//*
}
*/
