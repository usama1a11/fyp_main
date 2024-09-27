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
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:furnitureworldapplication/Screen/Add_to_cart/cart_empty_msg.dart';

class Cart1 extends StatefulWidget {

  const Cart1({super.key});

  @override
  State<Cart1> createState() => _Cart1State();
}
// apna neechy with stive but not complete
/*class _Cart1State extends State<Cart1> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();
  Widget Checkout() {
    return Container(
      height: 200,
      color: Colors.grey,
      child: Center(
        child: Text("Checkout Bottom Sheet"),
      ),
    );
  }
  // Function to save the cart items to Firebase
  Future<void> saveCartToFirebase() async {
    try {
      // Retrieve the cart items using getCartData() from PersistentShoppingCart
      Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
      List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

      for (var cartItem in cartItems) {
        // Map cart data to Firebase structure and push to 'orders'
        await _dbRef.child('orders').push().set({
          "orderDate": DateTime.now().toIso8601String(),
          "status": "Pending",
          "Title": cartItem.productName,
          "Price": cartItem.unitPrice,
          "Description": cartItem.productDescription,
          "Image": cartItem.productThumbnail,
          "Id": cartItem.productId,
          "quantity": cartItem.quantity,
        });
      }

      Fluttertoast.showToast(msg: "Cart saved to Firebase");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Display Cart Items here
              Expanded(
                child: PersistentShoppingCart().showCartItems(
                  cartTileWidget: ({required data}) => Card(
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
                                child: Image.asset(
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
                                    r"$" + data.unitPrice.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      PersistentShoppingCart().removeFromCart(data.productId).then((value) {
                                        Fluttertoast.showToast(msg: "Product removed from cart");
                                      }).onError((error, stackTrace) {
                                        Fluttertoast.showToast(msg: "Product not removed: $error");
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                PersistentShoppingCart().decrementCartItemQuantity(data.productId);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(data.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                PersistentShoppingCart().incrementCartItemQuantity(data.productId);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        PersistentShoppingCart().showTotalAmountWidget(
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        maximumSize: const Size(double.infinity, 55),
                      ),
                      onPressed: () async {
                        // Save cart items to Firebase when checking out
                        await saveCartToFirebase();

                        // Example for starting Stripe payment
                        var items = [
                          {
                            "productPrice": 4,
                            "productName": "Apple",
                            "qty": 5,
                          },
                          {
                            "productPrice": 5,
                            "productName": "Pineapple",
                            "qty": 10,
                          }
                        ];
                        await StripeService.stripePaymentCheckout(
                          items,
                          500,  // Replace with the total amount
                          context,
                          mounted,
                          onSuccess: () {
                            print("SUCCESS");
                          },
                          onCancel: () {
                            print("Cancel");
                          },
                          onError: (e) {
                            print("Error: " + e.toString());
                          },
                        );
                      },
                      child: const Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
// everything ok without strive
/*class _Cart1State extends State<Cart1> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();

  Widget Checkout() {
    return Container(
      height: 200,
      color: Colors.grey,
      child: Center(
        child: Text("Checkout Bottom Sheet"),
      ),
    );
  }

  // Function to save the cart items to Firebase
  Future<void> saveCartToFirebase() async {
    try {
      // Retrieve the cart items using getCartData() from PersistentShoppingCart
      Map<String, dynamic> cartData = _shoppingCart.getCartData();
      List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

      for (var cartItem in cartItems) {
        // Map cart data to Firebase structure and push to 'orders'
        await _dbRef.child('orders').push().set({
          "orderDate": DateTime.now().toIso8601String(),
          "status": "Pending",
          "Title": cartItem.productName,
          "Price": cartItem.unitPrice * cartItem.quantity, // Adjusted for quantity
          "Description": cartItem.productDescription,
          "Image": cartItem.productThumbnail,
          "Id": cartItem.productId,
          "quantity": cartItem.quantity,
        });
      }

      Fluttertoast.showToast(msg: "Cart saved to Firebase");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving cart: $e");
    }
  }

  Future<void> removeProductFromFirebase(String productId) async {
    try {
      DatabaseEvent snapshot = await _dbRef.child('orders').orderByChild('Id').equalTo(productId).once();
      if (snapshot.snapshot.exists) {
        snapshot.snapshot.children.forEach((child) {
          _dbRef.child('orders').child(child.key!).remove();
        });
      }
      Fluttertoast.showToast(msg: "Product removed from Firebase");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error removing product: $e");
    }
  }

  // Method to calculate the total amount from the cart items
  double getTotalAmount() {
    double total = 0.0;
    Map<String, dynamic> cartData = _shoppingCart.getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

    for (var item in cartItems) {
      total += item.unitPrice * item.quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Display Cart Items here
              Expanded(
                child: _shoppingCart.showCartItems(
                  cartTileWidget: ({required data}) => Card(
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
                                child: Image.asset(
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
                                    r"$" + (data.unitPrice * data.quantity).toString(), // Adjust price based on quantity
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Remove from Firebase
                                      removeProductFromFirebase(data.productId).then((_) {
                                        _shoppingCart.removeFromCart(data.productId).then((value) {
                                          Fluttertoast.showToast(msg: "Product removed from cart");
                                        });
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _shoppingCart.decrementCartItemQuantity(data.productId);
                                setState(() {}); // Refresh the UI to show updated quantities
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(data.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                _shoppingCart.incrementCartItemQuantity(data.productId);
                                setState(() {}); // Refresh the UI to show updated quantities
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        maximumSize: const Size(double.infinity, 55),
                      ),
                      onPressed: () async {
                        // Save cart items to Firebase when checking out
                        await saveCartToFirebase();

                        // Example for starting Stripe payment
                        var items = []; // Prepare items based on the cart
                        for (var cartItem in _shoppingCart.getCartData()['cartItems']) {
                          items.add({
                            "productPrice": cartItem.unitPrice,
                            "productName": cartItem.productName,
                            "qty": cartItem.quantity,
                          });
                        }
                        await StripeService.stripePaymentCheckout(
                          items,
                          // Calculate total amount for payment
                          getTotalAmount() as int, // Use the new method here
                          context,
                          mounted,
                          onSuccess: () {
                            print("SUCCESS");
                          },
                          onCancel: () {
                            print("Cancel");
                          },
                          onError: (e) {
                            print("Error: " + e.toString());
                          },
                        );
                      },
                      child: const Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
// Final hai koi masla ni hai iss mn mashallah
class _Cart1State extends State<Cart1> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();

  // Function to save the cart items to Firebase
  Future<void> saveCartToFirebase() async {
    try {
      // Retrieve the cart items using getCartData() from PersistentShoppingCart
      Map<String, dynamic> cartData = _shoppingCart.getCartData();
      List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

      for (var cartItem in cartItems) {
        // Map cart data to Firebase structure and push to 'orders'
        await _dbRef.child('orders').push().set({
          "orderDate": DateTime.now().toIso8601String(),
          "status": "Pending",
          "Title": cartItem.productName,
          "Price": cartItem.unitPrice * cartItem.quantity, // Store price based on quantity
          "Description": cartItem.productDescription,
          "Image": cartItem.productThumbnail,
          "Id": cartItem.productId,
          "quantity": cartItem.quantity,
        });
      }

      Fluttertoast.showToast(msg: "Cart saved to Firebase");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving cart: $e");
    }
  }

  // Function to remove a product from Firebase
  Future<void> removeProductFromFirebase(String productId) async {
    try {
      DatabaseEvent snapshot = await _dbRef.child('orders').orderByChild('Id').equalTo(productId).once();
      if (snapshot.snapshot.exists) {
        snapshot.snapshot.children.forEach((child) {
          _dbRef.child('orders').child(child.key!).remove();
        });
        Fluttertoast.showToast(msg: "Product removed from Firebase");
      } else {
        Fluttertoast.showToast(msg: "Product not found in Firebase");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error removing product: $e");
    }
  }

  // Method to calculate the total amount from the cart items
  double getTotalAmount() {
    double total = 0.0;
    Map<String, dynamic> cartData = _shoppingCart.getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

    for (var item in cartItems) {
      total += item.unitPrice * item.quantity; // Calculate total based on unit price and quantity
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Display Cart Items here
              Expanded(
                child: _shoppingCart.showCartItems(
                  cartTileWidget: ({required data}) => Card(
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
                                child: Image.asset(
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
                                    r"$" + (data.unitPrice * data.quantity).toString(), // Adjust price based on quantity
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Remove from Firebase and from cart
                                      removeProductFromFirebase(data.productId).then((_) {
                                        _shoppingCart.removeFromCart(data.productId).then((value) {
                                          Fluttertoast.showToast(msg: "Product removed from cart");
                                        });
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _shoppingCart.decrementCartItemQuantity(data.productId);
                                setState(() {}); // Refresh the UI to show updated quantities
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(data.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                _shoppingCart.incrementCartItemQuantity(data.productId);
                                setState(() {}); // Refresh the UI to show updated quantities
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        maximumSize: const Size(double.infinity, 55),
                      ),
                      onPressed: () async {
                        // Calculate total amount
                        double totalAmount = getTotalAmount(); // Get total amount

                        // Save cart items to Firebase when checking out
                        await saveCartToFirebase();

                        // Prepare items for Stripe payment
                        List<Map<String, dynamic>> items = [];
                        for (var cartItem in _shoppingCart.getCartData()['cartItems']) {
                          items.add({
                            "productPrice": cartItem.unitPrice,
                            "productName": cartItem.productName,
                            "qty": cartItem.quantity,
                          });
                        }

                        // Start Stripe payment
                        await StripeService.stripePaymentCheckout(
                          items,
                          totalAmount.toInt(), // Use the total amount
                          context,
                          mounted,
                          onSuccess: () {
                            print("SUCCESS");
                          },
                          onCancel: () {
                            print("Cancel");
                          },
                          onError: (e) {
                            print("Error: " + e.toString());
                          },
                        );
                      },
                      child: const Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Final hai koi masla ni hai iss mn mashallah ye cpy rakhi hai asal ki
/*class _Cart1State extends State<Cart1> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();

  // Function to save the cart items to Firebase
  Future<void> saveCartToFirebase() async {
    try {
      // Retrieve the cart items using getCartData() from PersistentShoppingCart
      Map<String, dynamic> cartData = _shoppingCart.getCartData();
      List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

      for (var cartItem in cartItems) {
        // Map cart data to Firebase structure and push to 'orders'
        await _dbRef.child('orders').push().set({
          "orderDate": DateTime.now().toIso8601String(),
          "status": "Pending",
          "Title": cartItem.productName,
          "Price": cartItem.unitPrice * cartItem.quantity, // Store price based on quantity
          "Description": cartItem.productDescription,
          "Image": cartItem.productThumbnail,
          "Id": cartItem.productId,
          "quantity": cartItem.quantity,
        });
      }

      Fluttertoast.showToast(msg: "Cart saved to Firebase");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving cart: $e");
    }
  }

  // Function to remove a product from Firebase
  Future<void> removeProductFromFirebase(String productId) async {
    try {
      DatabaseEvent snapshot = await _dbRef.child('orders').orderByChild('Id').equalTo(productId).once();
      if (snapshot.snapshot.exists) {
        snapshot.snapshot.children.forEach((child) {
          _dbRef.child('orders').child(child.key!).remove();
        });
        Fluttertoast.showToast(msg: "Product removed from Firebase");
      } else {
        Fluttertoast.showToast(msg: "Product not found in Firebase");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error removing product: $e");
    }
  }

  // Method to calculate the total amount from the cart items
  double getTotalAmount() {
    double total = 0.0;
    Map<String, dynamic> cartData = _shoppingCart.getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];

    for (var item in cartItems) {
      total += item.unitPrice * item.quantity; // Calculate total based on unit price and quantity
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Display Cart Items here
              Expanded(
                child: _shoppingCart.showCartItems(
                  cartTileWidget: ({required data}) => Card(
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
                                child: Image.asset(
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
                                    r"$" + (data.unitPrice * data.quantity).toString(), // Adjust price based on quantity
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Remove from Firebase and from cart
                                      removeProductFromFirebase(data.productId).then((_) {
                                        _shoppingCart.removeFromCart(data.productId).then((value) {
                                          Fluttertoast.showToast(msg: "Product removed from cart");
                                        });
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                _shoppingCart.decrementCartItemQuantity(data.productId);
                                setState(() {}); // Refresh the UI to show updated quantities
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(data.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                _shoppingCart.incrementCartItemQuantity(data.productId);
                                setState(() {}); // Refresh the UI to show updated quantities
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        maximumSize: const Size(double.infinity, 55),
                      ),
                      onPressed: () async {
                        // Calculate total amount
                        double totalAmount = getTotalAmount(); // Get total amount

                        // Save cart items to Firebase when checking out
                        await saveCartToFirebase();

                        // Prepare items for Stripe payment
                        List<Map<String, dynamic>> items = [];
                        for (var cartItem in _shoppingCart.getCartData()['cartItems']) {
                          items.add({
                            "productPrice": cartItem.unitPrice,
                            "productName": cartItem.productName,
                            "qty": cartItem.quantity,
                          });
                        }

                        // Start Stripe payment
                        await StripeService.stripePaymentCheckout(
                          items,
                          totalAmount.toInt(), // Use the total amount
                          context,
                          mounted,
                          onSuccess: () {
                            print("SUCCESS");
                          },
                          onCancel: () {
                            print("Cancel");
                          },
                          onError: (e) {
                            print("Error: " + e.toString());
                          },
                        );
                      },
                      child: const Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
