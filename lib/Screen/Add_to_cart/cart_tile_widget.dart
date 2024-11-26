/*import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';*/
//asal ti hai na phir
/*class CartTileWidget extends StatelessWidget {
  final PersistentShoppingCartItem data;
  final Products products;
  CartTileWidget({Key? key, required this.data,required this.products}) : super(key: key);

  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Image.asset(data.productThumbnail.toString())),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.productName ,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700 , color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(data.productDescription.toString() ,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12,color: Colors.white),
                  ),
                ),

                Row(
                  children: [
                    Text(
                      "\$ ${data.unitPrice}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () async {
                        bool removed =
                        await _shoppingCart.removeFromCart(data.productId);
                        if (removed) {
                          // Handle successful removal
                          showSnackBar(context, removed);
                        } else {
                          // Handle the case where if product was not found in the cart
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            'Remove',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  _shoppingCart.incrementCartItemQuantity(data.productId);
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
              Text(
                data.quantity.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              InkWell(
                onTap: () {
                  _shoppingCart.decrementCartItemQuantity(data.productId);
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.remove),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, bool removed) {
    final snackBar = SnackBar(
      content: Text(
        removed
            ? 'Product removed from cart.'
            : 'Product not found in the cart.',
      ),
      backgroundColor: removed ? Colors.green : Colors.red,
      duration: const  Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}*/
//low error
/*class CartTileWidget extends StatelessWidget {
  final PersistentShoppingCartItem data;
  final Products products;

  CartTileWidget({Key? key, required this.data, required this.products}) : super(key: key);

  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase reference

  // Function to update stock in Firebase
  Future<void> updateStockInFirebase(String productId, int stock) async {
    try {
      await _dbRef.child('products').child(productId).update({
        'stock': stock,
      });
    } catch (e) {
      print("Error updating stock: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Image.asset(data.productThumbnail.toString())),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.productName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    data.productDescription.toString(),
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$ ${data.unitPrice}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () async {
                        bool removed = await _shoppingCart.removeFromCart(data.productId);
                        if (removed) {
                          // Update stock and Firebase
                          final newStock = products.stock + data.quantity; // Increment stock by the quantity in the cart
                          await updateStockInFirebase(products.productId, newStock);
                          showSnackBar(context, removed);
                        } else {
                          showSnackBar(context, false);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            'Remove',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () async {
                  if (products.stock > 0) {
                    _shoppingCart.incrementCartItemQuantity(data.productId);
                    final newStock = products.stock - 1; // Decrease stock
                    await updateStockInFirebase(products.productId, newStock);
                  } else {
                    Fluttertoast.showToast(msg: "Out of stock!");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
              Text(
                data.quantity.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              InkWell(
                onTap: () async {
                  if (data.quantity > 1) {
                    _shoppingCart.decrementCartItemQuantity(data.productId);
                    final newStock = products.stock + 1; // Increase stock
                    await updateStockInFirebase(products.productId, newStock);
                  } else {
                    Fluttertoast.showToast(msg: "Minimum quantity is 1");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.remove),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, bool removed) {
    final snackBar = SnackBar(
      content: Text(
        removed
            ? 'Product removed from cart.'
            : 'Product not found in the cart.',
      ),
      backgroundColor: removed ? Colors.green : Colors.red,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}*/
//asal wala hai ye code
/*class CartTileWidget extends StatefulWidget {
  final PersistentShoppingCartItem data;
  final Products products;

  CartTileWidget({Key? key, required this.data, required this.products}) : super(key: key);

  @override
  State<CartTileWidget> createState() => _CartTileWidgetState();
}*/
// stock and quantity solve
/*class _CartTileWidgetState extends State<CartTileWidget> {
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();


  *//*Future<void> updateStockInFirebase(String productId, int stock) async {
    try {
      await _dbRef.child('products').child(productId).update({
        'stock': stock,
      });
    } catch (e) {
      print("Error updating stock: $e");
    }
  }*//*

  @override
  Widget build(BuildContext context) {
    // Set the default quantity to 1 if it is not set
    int quantity = widget.data.quantity > 0 ? widget.data.quantity : 1;
    print("123");
    print(widget.data.productThumbnail.toString());
    print("123");
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Image.network(widget.data.productThumbnail.toString())),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.productName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.data.productDescription.toString(),
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$ ${widget.data.unitPrice}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () async {
                        bool removed = await _shoppingCart.removeFromCart(widget.data.productId);
                        if (removed) {
                          // Update stock and Firebase
                          // final newStock = widget.products.stock + quantity; // Increment stock by the quantity in the cart
                          // await updateStockInFirebase(widget.products.id, newStock); // Use the correct product ID
                          showSnackBar(context, removed);
                        } else {
                          showSnackBar(context, false);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            'Remove',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
     *//*     Column(
            children: [
              InkWell(
                onTap: () {
                  if (widget.products.stock > 0) {
                    _shoppingCart.incrementCartItemQuantity(widget.data.productId);
                    final newStock = widget.products.stock - 1; // Decrease stock
                    // updateStockInFirebase(widget.products.id, newStock); // Use the correct product ID
                  } else {
                    Fluttertoast.showToast(msg: "Out of stock!");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
              Text(
                quantity.toString(), // Display quantity instead of stock
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              InkWell(
                onTap: () {
                  if (quantity > 1) {
                    _shoppingCart.decrementCartItemQuantity(widget.data.productId);
                    // final newStock = widget.products.stock + 1; // Increase stock
                    // updateStockInFirebase(widget.products.id, newStock); // Use the correct product ID
                  } else {
                    Fluttertoast.showToast(msg: "Minimum quantity is 1");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.remove),
                ),
              ),
            ],
          ),*//*
        ],
      ),
    );
  }
  void showSnackBar(BuildContext context, bool removed) {
    final snackBar = SnackBar(
      content: Text(
        removed ? 'Product removed from cart.' : 'Product not found in the cart.',
      ),
      backgroundColor: removed ? Colors.green : Colors.red,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}*/





/*class _CartTileWidgetState extends State<CartTileWidget> {
  final PersistentShoppingCart _shoppingCart = PersistentShoppingCart();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Map<String, int> localStockChanges = {}; // Local stock tracking for this widget

  Future<void> updateLocalStock(String productId, int newStock) async {
    setState(() {
      localStockChanges[productId] = newStock; // Update local stock in state
    });
  }

  Future<void> updateStockInFirebase(String productId, int stock) async {
    try {
      await _dbRef.child('products').child(productId).update({
        'stock': stock,
      });
    } catch (e) {
      print("Error updating stock: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int quantity = widget.data.quantity > 0 ? widget.data.quantity : 1;
    int stock = localStockChanges[widget.data.productId] ?? widget.products.stock;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Image.network(widget.data.productThumbnail.toString()),
          ),
          const SizedBox(width: 10),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.productName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.data.productDescription.toString(),
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$ ${widget.data.unitPrice}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () async {
                        bool removed = await _shoppingCart.removeFromCart(widget.data.productId);
                        if (removed) {
                          final newStock = stock + quantity; // Increment stock
                          updateLocalStock(widget.data.productId, newStock);
                          await updateStockInFirebase(widget.data.productId, newStock);
                          showSnackBar(context, removed);
                        } else {
                          showSnackBar(context, false);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            'Remove',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          // Quantity control
          Column(
            children: [
              InkWell(
                onTap: () {
                  if (stock > 0) {
                    _shoppingCart.incrementCartItemQuantity(widget.data.productId);
                    final newStock = stock - 1; // Decrease stock
                    updateLocalStock(widget.data.productId, newStock);
                    updateStockInFirebase(widget.data.productId, newStock);
                  } else {
                    Fluttertoast.showToast(msg: "Out of stock!");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
              Text(
                quantity.toString(), // Display quantity
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              InkWell(
                onTap: () {
                  if (quantity > 1) {
                    _shoppingCart.decrementCartItemQuantity(widget.data.productId);
                    final newStock = stock + 1; // Increase stock
                    updateLocalStock(widget.data.productId, newStock);
                    updateStockInFirebase(widget.data.productId, newStock);
                  } else {
                    Fluttertoast.showToast(msg: "Minimum quantity is 1");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.remove),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, bool removed) {
    final snackBar = SnackBar(
      content: Text(
        removed ? 'Product removed from cart.' : 'Product not found in the cart.',
      ),
      backgroundColor: removed ? Colors.green : Colors.red,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}*/
