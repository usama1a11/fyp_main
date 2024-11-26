/*
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Screen/Add_to_cart/cart_empty_msg.dart';
import 'package:furnitureworldapplication/Buyer/Payment_Method/checkout.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class Cart1 extends StatefulWidget {
  const Cart1({super.key});

  @override
  State<Cart1> createState() => _Cart1State();
}
class _Cart1State extends State<Cart1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // This will expand and allow scrolling when there are cart items
              Expanded(
                child: PersistentShoppingCart().showCartItems(
                  cartTileWidget: ({required data}) => Card(
                    color: Colors.brown.withOpacity(0.5),
                    child: Row(
                      children: [
                        // Product Image
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Image.asset(
                                  data.productThumbnail.toString(),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Product Details
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.productName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data.productDescription.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    r"$" + data.unitPrice.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      PersistentShoppingCart()
                                          .removeFromCart(data.productId)
                                          .then((value) {
                                        Fluttertoast.showToast(
                                            msg: "Product removed from cart");
                                      }).onError((error, stackTrace) {
                                        Fluttertoast.showToast(
                                            msg: "Product not removed from cart: $error");
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Quantity Control
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                PersistentShoppingCart()
                                    .decrementCartItemQuantity(data.productId);
                              },
                              icon: Icon(Icons.remove),
                            ),
                            Text(data.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                PersistentShoppingCart()
                                    .incrementCartItemQuantity(data.productId);
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  showEmptyCartMsgWidget: Center(child: EmptyCartMsgWidget()),
                ),
              ),
              // Checkout Widget at the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Checkout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase
import 'package:furnitureworldapplication/Buyer/Payment_Method/stripe_service.dart';
import 'package:furnitureworldapplication/Screen/Add_to_cart/cart_tile_widget.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:furnitureworldapplication/Screen/Add_to_cart/cart_empty_msg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Cart1 extends StatefulWidget {

  const Cart1({super.key});

  @override
  State<Cart1> createState() => _Cart1State();
}
class _Cart1State extends State<Cart1>{
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();

  // Function to save the cart items to Firebase and update stock during checkout
  Future<void> saveCartToFirebase() async {
    try {
      Map<String, dynamic> cartData = _shoppingCart.getCartData();
      List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

      for (var cartItem in cartItems) {
        int currentStock = await fetchProductStock(cartItem.productId); // Fetch the current stock
        int newStock = currentStock - cartItem.quantity; // Decrement stock by the quantity

        // Save the order to Firebase
        await _dbRef.child('orders').push().set({
          "orderDate": DateTime.now().toIso8601String(),
          "status": "Pending",
          "Title": cartItem.productName,
          "Price": cartItem.unitPrice * cartItem.quantity,
          "costPrice":cartItem.totalPrice.toString(),
          "Description": cartItem.productDescription,
          "Image": cartItem.productThumbnail.toString(),
          "Id": cartItem.productId,
          "quantity": cartItem.quantity,
        });

        // Update the stock in Firebase during checkout
        await _dbRef.child('products').child(cartItem.productId).child('stock').set(newStock);
      }

      Fluttertoast.showToast(msg: "Cart saved to Firebase, stock updated");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving cart: $e");
    }
  }

  // Function to fetch stock for each product
  Future<int> fetchProductStock(String productId) async {
    try {
      DataSnapshot snapshot = await _dbRef.child('products').child(productId).child('stock').get();
      if (snapshot.exists && snapshot.value != null) {
        return snapshot.value as int;
      } else {
        return 10; // Default stock value when no stock information is found
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching stock: $e");
      return 10; // Default stock value in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the cart is empty
    bool isCartEmpty = _shoppingCart.getCartData()['cartItems'].isEmpty;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
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
        body: Column(
          children: [
            // Display Cart Items here
            Expanded(
              child: _shoppingCart.showCartItems(
                cartTileWidget: ({required data}) => FutureBuilder<int>(
                  future: fetchProductStock(data.productId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text("Error loading stock");
                    } else {
                      int stock = snapshot.data ?? 10; // Default stock set to 10

                      // Check if stock is low
                      bool isLowStock = stock == 0;

                      return Card(
                        color: Colors.brown.withOpacity(0.5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    child: Image.network(
                                      data.productThumbnail.toString(),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.productName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    data.productDescription.toString(),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        r"$" + (data.unitPrice * data.quantity).toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await _shoppingCart.removeFromCart(data.productId);
                                          Fluttertoast.showToast(msg: "Product removed from cart");
                                          setState(() {}); // Only update UI after removal
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Stock: $stock", // Show stock
                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                // Disable the "add" button if the quantity is equal to the stock
                                IconButton(
                                  onPressed: data.quantity < stock ? () async {
                                    await _shoppingCart.incrementCartItemQuantity(data.productId);
                                    setState(() {}); // Only update UI
                                  }
                                      : () {
                                    Fluttertoast.showToast(
                                      msg: "Stock Low", // Show stock low message
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.redAccent,
                                      textColor: Colors.white,
                                    );
                                  }, // Show stock low message when button is disabled
                                  icon: Icon(
                                    Icons.add,
                                    color: data.quantity < stock ? Colors.black : Colors.grey, // Change icon color when disabled
                                  ),
                                ),
                                Text(data.quantity.toString()),
                                IconButton(
                                  onPressed: () async {
                                    if (data.quantity > 0) {
                                      await _shoppingCart.decrementCartItemQuantity(data.productId);
                                      setState(() {}); // Only update UI after quantity decremented
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                showEmptyCartMsgWidget: const Center(child: EmptyCartMsgWidget()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      _shoppingCart.showTotalAmountWidget(
                        cartTotalAmountWidgetBuilder: (totalAmount) {
                          return Visibility(
                            visible: totalAmount == 0.0 ? false : true,
                            child: Text(
                              r"$" + totalAmount.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Checkout button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCartEmpty ? Colors.grey : Colors.black,
                      maximumSize: const Size(double.infinity, 55),
                    ),
                    onPressed: isCartEmpty
                        ? null // Disable the button when cart is empty
                        : () async {
                      await saveCartToFirebase();

                      double totalAmount = getTotalAmount();

                      List<Map<String, dynamic>> items = [];
                      for (var cartItem in _shoppingCart.getCartData()['cartItems']) {
                        items.add({
                          "productPrice": cartItem.unitPrice,
                          "productName": cartItem.productName,
                          "qty": cartItem.quantity,
                        });
                      }

                      await StripeService.stripePaymentCheckout(
                        items,
                        totalAmount.toInt(),
                        context,
                        mounted,
                        onSuccess: () {
                          print("SUCCESS");
                          _shoppingCart.clearCart();
                          setState(() {}); // Update UI after checkout
                        },
                        onCancel: () {
                          print("Cancel");
                        },
                        onError: (e) {
                          print("Error: " + e.toString());
                        },
                      );
                    },
                    child: const Text("Checkout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  double getTotalAmount(){
    double total = 0.0;
    Map<String, dynamic> cartData = _shoppingCart.getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];
    for (var item in cartItems) {
      total += item.unitPrice * item.quantity;
    }
    return total;
  }
}
//Fyp ky liye final ki copy rakhi..
/*class _Cart1State extends State<Cart1> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();

  // Function to save the cart items to Firebase and update stock during checkout
  Future<void> saveCartToFirebase() async {
    try {
      Map<String, dynamic> cartData = _shoppingCart.getCartData();
      List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

      for (var cartItem in cartItems) {
        int currentStock = await fetchProductStock(cartItem.productId); // Fetch the current stock
        int newStock = currentStock - cartItem.quantity; // Decrement stock by the quantity

        // Save the order to Firebase
        await _dbRef.child('orders').push().set({
          "orderDate": DateTime.now().toIso8601String(),
          "status": "Pending",
          "Title": cartItem.productName,
          "Price": cartItem.unitPrice * cartItem.quantity,
          "Description": cartItem.productDescription,
          "Image": cartItem.productThumbnail.toString(),
          "Id": cartItem.productId,
          "quantity": cartItem.quantity,
        });

        // Update the stock in Firebase during checkout
        await _dbRef.child('products').child(cartItem.productId).child('stock').set(newStock);
      }

      Fluttertoast.showToast(msg: "Cart saved to Firebase, stock updated");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving cart: $e");
    }
  }

  // Function to fetch stock for each product
  Future<int> fetchProductStock(String productId) async {
    try {
      DataSnapshot snapshot = await _dbRef.child('products').child(productId).child('stock').get();
      if (snapshot.exists && snapshot.value != null) {
        return snapshot.value as int;
      } else {
        return 10; // Default stock value when no stock information is found
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching stock: $e");
      return 10; // Default stock value in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the cart is empty
    bool isCartEmpty = _shoppingCart.getCartData()['cartItems'].isEmpty;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
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
        body: Column(
          children: [
            // Display Cart Items here
            Expanded(
              child: _shoppingCart.showCartItems(
                cartTileWidget: ({required data}) => FutureBuilder<int>(
                  future: fetchProductStock(data.productId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text("Error loading stock");
                    } else {
                      int stock = snapshot.data ?? 10; // Default stock set to 10

                      // Check if stock is low
                      bool isLowStock = stock == 0;

                      return Card(
                        color: Colors.brown.withOpacity(0.5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    child: Image.network(
                                      data.productThumbnail.toString(),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.productName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    data.productDescription.toString(),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        r"$" + (data.unitPrice * data.quantity).toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await _shoppingCart.removeFromCart(data.productId);
                                          Fluttertoast.showToast(msg: "Product removed from cart");
                                          setState(() {}); // Only update UI after removal
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Stock: $stock", // Show stock
                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                // Disable the "add" button if the quantity is equal to the stock
                                IconButton(
                                  onPressed: data.quantity < stock
                                      ? () async {
                                    await _shoppingCart.incrementCartItemQuantity(data.productId);
                                    setState(() {}); // Only update UI
                                  }
                                      : () {
                                    Fluttertoast.showToast(
                                      msg: "Stock Low", // Show stock low message
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.redAccent,
                                      textColor: Colors.white,
                                    );
                                  }, // Show stock low message when button is disabled
                                  icon: Icon(
                                    Icons.add,
                                    color: data.quantity < stock ? Colors.black : Colors.grey, // Change icon color when disabled
                                  ),
                                ),
                                Text(data.quantity.toString()),
                                IconButton(
                                  onPressed: () async {
                                    if (data.quantity > 0) {
                                      await _shoppingCart.decrementCartItemQuantity(data.productId);
                                      setState(() {}); // Only update UI after quantity decremented
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                showEmptyCartMsgWidget: const Center(child: EmptyCartMsgWidget()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      _shoppingCart.showTotalAmountWidget(
                        cartTotalAmountWidgetBuilder: (totalAmount) {
                          return Visibility(
                            visible: totalAmount == 0.0 ? false : true,
                            child: Text(
                              r"$" + totalAmount.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Checkout button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCartEmpty ? Colors.grey : Colors.black,
                      maximumSize: const Size(double.infinity, 55),
                    ),
                    onPressed: isCartEmpty
                        ? null // Disable the button when cart is empty
                        : () async {
                      await saveCartToFirebase();

                      double totalAmount = getTotalAmount();

                      List<Map<String, dynamic>> items = [];
                      for (var cartItem in _shoppingCart.getCartData()['cartItems']) {
                        items.add({
                          "productPrice": cartItem.unitPrice,
                          "productName": cartItem.productName,
                          "qty": cartItem.quantity,
                        });
                      }

                      await StripeService.stripePaymentCheckout(
                        items,
                        totalAmount.toInt(),
                        context,
                        mounted,
                        onSuccess: () {
                          print("SUCCESS");
                          _shoppingCart.clearCart();
                          setState(() {}); // Update UI after checkout
                        },
                        onCancel: () {
                          print("Cancel");
                        },
                        onError: (e) {
                          print("Error: " + e.toString());
                        },
                      );
                    },
                    child: const Text("Checkout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getTotalAmount() {
    double total = 0.0;
    Map<String, dynamic> cartData = _shoppingCart.getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

    for (var item in cartItems) {
      total += item.unitPrice * item.quantity;
    }

    return total;
  }
}*/