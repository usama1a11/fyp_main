import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Screen/Order/Review.dart';
// import 'package:furnitureworldapplication/Screen/Order/Review.dart';
class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}
class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Current Order", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Orders"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PendingOrdersScreen(),
            OnTheWayOrdersScreen(),
            CompletedOrdersScreen(),
            CanceledOrdersScreen(),
            AllOrdersScreen(),
          ],
        ),
      ),
    );
  }
}
class PendingOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return buildOrdersListView('Pending');
  }

  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return _buildOrderList(snapshot, context);
      },
    );
  }

  Widget _buildOrderList(AsyncSnapshot<DatabaseEvent> snapshot, BuildContext context) {
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
      List<Map<dynamic, dynamic>> orders = [];

      snapshot.data!.snapshot.children.forEach((child) {
        Map order = child.value as Map;
        orders.add({...order, 'key': child.key});
      });

      if (orders.isEmpty) {
        return const Center(child: Text("No orders available"));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return buildOrderCard(order, context);
        },
      );
    } else {
      return const Center(child: Text("No orders available"));
    }
  }

  Widget buildOrderCard(Map order, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: 290,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: order['Image'] != null && order['Image'].toString().isNotEmpty
                        ? Image.network(
                      order['Image'],
                      height: 150,
                      width: 130,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    )
                        : const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    order['Title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Status: ${order['status'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                cancelOrder(order['key'], context); // Pass context for navigation if needed
              },
              icon: const Icon(Icons.cancel_outlined, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cancelOrder(String? orderKey, BuildContext context) async {
    if (orderKey != null) {
      // Navigate to CanceledOrdersScreen or handle the cancellation logic here
      await _dbRef.child(orderKey).update({'status': 'Canceled'}); // Update or directly navigate as needed
      // Navigate to CanceledOrdersScreen if desired
    }
  }
}
class OnTheWayOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return buildOrdersListView('On The Way');
  }

  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return _buildOrderList(snapshot);
      },
    );
  }

  Widget _buildOrderList(AsyncSnapshot<DatabaseEvent> snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
      List<Map<dynamic, dynamic>> orders = [];

      snapshot.data!.snapshot.children.forEach((child) {
        Map order = child.value as Map;
        orders.add({...order, 'key': child.key});
      });

      if (orders.isEmpty) {
        return const Center(child: Text("No orders available"));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return buildOrderCard(order);
        },
      );
    } else {
      return const Center(child: Text("No orders available"));
    }
  }

  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: 355,  // Increased height to accommodate the button
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: order['Image'] != null && order['Image'].toString().isNotEmpty
                        ? Image.network(
                      order['Image'],
                      height: 150,
                      width: 130,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    )
                        : const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    order['Title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Status: ${order['status'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      markAsCompleted(order['key']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade400,
                    ),
                    child: const Text('Received', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> markAsCompleted(String? orderKey) async {
    if (orderKey != null) {
      await _dbRef.child(orderKey).update({
        'status': 'Completed',
      });
    }
  }
}
// Implement CompletedOrdersScreen
class CompletedOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PendingOrdersScreen().buildOrdersListView('Completed'),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: FloatingActionButton(
          onPressed: () {
            _showFeedbackDialog(context);
          },
          backgroundColor: Colors.brown.shade200,
          child: const Icon(Icons.feedback,color: Colors.black,),
        ),
      ),
    );
  }
    void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    double rating = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
          title: const Text('Product Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  hintText: 'Enter your feedback here',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text('Rate the Product'),
              RatingBar.builder(
                itemSize: 35.0,
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                _saveFeedbackToFirebase(feedbackController.text, rating);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedbackScreen())); // Close the dialog after saving
              },
              style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.brown.shade400),
                 child: const Text('Submit',style: TextStyle(color: Colors.black,),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveFeedbackToFirebase(String feedback, double rating) async {
    if (feedback.isNotEmpty && rating > 0.0) {
      final feedbackData = {
        "feedback": feedback,
        "rating": rating,
        "timestamp": DateTime.now().toIso8601String(),
      };
      try {
        await _dbRef.child('feedback').push().set(feedbackData);
        // You can show a success message here if needed
      } catch (e) {
        // Handle the error if the data could not be saved
      }
    }
  }
}
class CanceledOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return buildOrdersListView('Canceled');
  }

  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return _buildOrderList(snapshot);
      },
    );
  }

  Widget _buildOrderList(AsyncSnapshot<DatabaseEvent> snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
      List<Map<dynamic, dynamic>> orders = [];

      snapshot.data!.snapshot.children.forEach((child) {
        Map order = child.value as Map;
        orders.add({...order, 'key': child.key});
      });

      if (orders.isEmpty) {
        return const Center(child: Text("No canceled orders available"));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return buildOrderCard(order);
        },
      );
    } else {
      return const Center(child: Text("No canceled orders available"));
    }
  }

  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: 290,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: order['Image'] != null && order['Image'].toString().isNotEmpty
                        ? Image.network(
                      order['Image'],
                      height: 150,
                      width: 130,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    )
                        : const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    order['Title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Status: ${order['status'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                deleteOrder(order['key']); // Call delete method here
              },
              icon: const Icon(Icons.delete_outline, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteOrder(String? orderKey) async {
    if (orderKey != null) {
      try {
        await _dbRef.child(orderKey).remove(); // Remove the order from Firebase
        Fluttertoast.showToast(msg: "Order deleted successfully");
      } catch (error) {
        Fluttertoast.showToast(msg: "Failed to delete order: $error");
      }
    }
  }
}
// Implement AllOrdersScreen
class AllOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return buildOrdersListView('Pending');
  }
  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return _buildOrderList(snapshot);
      },
    );
  }
  Widget _buildOrderList(AsyncSnapshot<DatabaseEvent> snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
      List<Map<dynamic, dynamic>> orders = [];

      snapshot.data!.snapshot.children.forEach((child) {
        Map order = child.value as Map;
        orders.add({...order, 'key': child.key});
      });

      if (orders.isEmpty) {
        return const Center(child: Text("No orders available"));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return buildOrderCard(order);
        },
      );
    } else {
      return const Center(child: Text("No orders available"));
    }
  }
  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: 290,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: order['Image'] != null && order['Image'].toString().isNotEmpty
                        ? Image.network(
                      order['Image'],  // Load asset image from the stored path
                      height: 150,
                      width: 130,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    )
                        : const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    order['Title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Status: ${order['status'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                cancelOrder(order['key']);
              },
              icon: const Icon(Icons.cancel_outlined, size: 30),
            ),
          ),
        ],
      ),
    );
  }
/*  Future<void> cancelOrder(String? orderKey) async {
    if (orderKey != null) {
      await _dbRef.child(orderKey).remove();
    }
  }*/
  Future<void> cancelOrder(String? orderKey) async {
    if (orderKey != null) {
      try {
        await _dbRef.child(orderKey).remove(); // Remove the order from Firebase
        Fluttertoast.showToast(msg: "Order canceled successfully");
      } catch (error) {
        Fluttertoast.showToast(msg: "Failed to cancel order: $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Order key is null");
    }
  }
}
// Implement CanceledOrdersScreen
//real
/*class CanceledOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return PendingOrdersScreen().buildOrdersListView('Canceled');
  }
}*/
//real can..
/*class CanceledOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return PendingOrdersScreen().buildOrdersListView('Canceled');
  }
}*/
// real pen..
/*class PendingOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return buildOrdersListView('Pending');
  }

  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return _buildOrderList(snapshot);
      },
    );
  }

  Widget _buildOrderList(AsyncSnapshot<DatabaseEvent> snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
      List<Map<dynamic, dynamic>> orders = [];

      snapshot.data!.snapshot.children.forEach((child) {
        Map order = child.value as Map;
        orders.add({...order, 'key': child.key});
      });

      if (orders.isEmpty) {
        return const Center(child: Text("No orders available"));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return buildOrderCard(order);
        },
      );
    } else {
      return const Center(child: Text("No orders available"));
    }
  }

  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: 290,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: order['Image'] != null && order['Image'].toString().isNotEmpty
                        ? Image.network(
                      order['Image'],  // Load asset image from the stored path
                      height: 150,
                      width: 130,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    )
                        : const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    order['Title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Status: ${order['status'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                cancelOrder(order['key']);
              },
              icon: const Icon(Icons.cancel_outlined, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cancelOrder(String? orderKey) async {
    if (orderKey != null) {
      // Instead of deleting, update the status to "Canceled"
      await _dbRef.child(orderKey).update({'status': 'Canceled'});
    }
  }
}*/
// Implement OnTheWayOrdersScreen
//real
/*class OnTheWayOrdersScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return buildOrdersListView('On The Way');
  }

  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return _buildOrderList(snapshot);
      },
    );
  }

  Widget _buildOrderList(AsyncSnapshot<DatabaseEvent> snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text("Error loading orders"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
      List<Map<dynamic, dynamic>> orders = [];

      snapshot.data!.snapshot.children.forEach((child) {
        Map order = child.value as Map;
        orders.add({...order, 'key': child.key});
      });

      if (orders.isEmpty) {
        return const Center(child: Text("No orders available"));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map order = orders[index];
          return buildOrderCard(order);
        },
      );
    } else {
      return const Center(child: Text("No orders available"));
    }
  }

  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: 290,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: order['Image'] != null && order['Image'].toString().isNotEmpty
                        ? Image.network(
                      order['Image'],
                      height: 150,
                      width: 130,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    )
                        : const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    order['Title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Status: ${order['status'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
/*import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}*/
//hogya but screen navigation masla error a jata tha jab navigate krty hn baki ok tha
/*class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  void initState() {
    super.initState();

    // Initialize TabController in the first frame after the widget tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 5, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Current Order", style: TextStyle(color: Colors.white60)),
          backgroundColor: Colors.transparent,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabController != null
                  ? TabBar(
                isScrollable: true, // Enable horizontal scrolling
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        body: _tabController != null
            ? TabBarView(
          controller: _tabController,
          children: [
            buildOrdersListView('Pending'),
            buildOrdersListView('On The Way'),
            buildOrdersListView('Completed'),
            buildOrdersListView('Canceled'),
            buildOrdersListView('All Order'),
          ],
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // Function to fetch and display orders based on the selected tab status
  Widget buildOrdersListView(String status) {
    return StreamBuilder(
      stream: _dbRef.orderByChild('status').equalTo(status == "All Order" ? null : status).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData && snapshot.data!.snapshot.exists) {
          List<Map<dynamic, dynamic>> orders = [];
          Set<String> uniqueProductIds = {};

          snapshot.data!.snapshot.children.forEach((child) {
            Map order = child.value as Map;
            if (!uniqueProductIds.contains(order['Id'])) {
              uniqueProductIds.add(order['Id']);
              orders.add(order);
            }
          });

          if (orders.isEmpty) {
            return const Center(child: Text("No orders available"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map order = orders[index];
              return buildOrderCard(order);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading orders"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Function to build the order card with improved UI
  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          height: 400, // Set minimum height
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.brown.withOpacity(0.1),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: order['Image'] != null && order['Image'].isNotEmpty
                    ? Image.network(
                  order['Image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                )
                    : const Icon(Icons.broken_image, size: 100),
              ),
              const SizedBox(height: 15),
              Text(
                order['Title'] ?? 'No Title',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Text(
                "Status: ${order['status'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16, color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
/*class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');

  @override
  void initState() {
    super.initState();
    // Initialize TabController in the first frame after the widget tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 5, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Current Order", style: TextStyle(color: Colors.white60)),
          backgroundColor: Colors.transparent,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabController != null
                  ? TabBar(
                isScrollable: true,
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        body: _tabController != null
            ? TabBarView(
          controller: _tabController,
          children: [
            buildOrdersListView('Pending'),
            buildOrdersListView('On The Way'),
            buildOrdersListView('Completed'),
            buildOrdersListView('Canceled'),
            buildOrdersListView('All Order'), // For 'All Orders' no filter is applied
          ],
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // Function to fetch and display orders based on the selected tab status
  Widget buildOrdersListView(String? status) {
    return StreamBuilder(
      stream: status == null
          ? _dbRef.onValue // Fetch all orders for 'All Orders' tab
          : _dbRef.orderByChild('status').equalTo(status).onValue, // Filter by status for other tabs
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading orders"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.snapshot.exists) {
          List<Map<dynamic, dynamic>> orders = [];

          snapshot.data!.snapshot.children.forEach((child) {
            Map order = child.value as Map;
            orders.add({...order, 'key': child.key});
          });

          if (orders.isEmpty) {
            return const Center(child: Text("No orders available"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map order = orders[index];
              return buildOrderCard(order);
            },
          );
        } else {
          return const Center(child: Text("No orders available"));
        }
      },
    );
  }

  // Function to build the order card with Firebase Realtime Database image handling
  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.brown.withOpacity(0.1),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: order['ImagePath'] != null
                    ? Image.network(
                  order['ImagePath'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                )
                    : const Icon(Icons.broken_image, size: 100),
              ),
              const SizedBox(height: 15),
              Text(
                order['Title'] ?? 'No Title',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Text(
                "Status: ${order['status'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16, color: Colors.black38),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  cancelOrder(order['key']);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade300),
                child: const Text('Cancel Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to cancel an order by removing it from Firebase
  Future<void> cancelOrder(String? orderKey) async {
    if (orderKey != null) {
      await _dbRef.child(orderKey).remove();
    }
  }
}*/
//syapa ee ay
/*class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders');
  late List<Stream<DatabaseEvent>> _orderStreams; // Cache streams for each tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Cache the streams for each tab
    _orderStreams = [
      _dbRef.orderByChild('status').equalTo('Pending').onValue,
      _dbRef.orderByChild('status').equalTo('On The Way').onValue,
      _dbRef.orderByChild('status').equalTo('Completed').onValue,
      _dbRef.orderByChild('status').equalTo('Canceled').onValue,
      _dbRef.onValue // Fetch all orders for 'All Orders' tab
    ];
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Current Order", style: TextStyle(color: Colors.white60)),
          backgroundColor: Colors.transparent,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildOrdersListView(0),
            buildOrdersListView(1),
            buildOrdersListView(2),
            buildOrdersListView(3),
            buildOrdersListView(4),
          ],
        ),
      ),
    );
  }

  // Build order list based on the cached streams
  Widget buildOrdersListView(int tabIndex) {
    return StreamBuilder(
      stream: _orderStreams[tabIndex],
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading orders"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.snapshot.exists) {
          List<Map<dynamic, dynamic>> orders = [];

          snapshot.data!.snapshot.children.forEach((child) {
            Map order = child.value as Map;
            orders.add({...order, 'key': child.key});
          });

          if (orders.isEmpty) {
            return const Center(child: Text("No orders available"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map order = orders[index];
              return buildOrderCard(order);
            },
          );
        } else {
          return const Center(child: Text("No orders available"));
        }
      },
    );
  }

  // Build individual order card
  Widget buildOrderCard(Map order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.brown.withOpacity(0.1),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: order['ImagePath'] != null
                    ? Image.network(
                  order['ImagePath'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                )
                    : const Icon(Icons.broken_image, size: 100),
              ),
              const SizedBox(height: 15),
              Text(
                order['Title'] ?? 'No Title',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Price: \$${order['Price']?.toStringAsFixed(2) ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Text(
                "Status: ${order['status'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16, color: Colors.black38),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  cancelOrder(order['key']);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade300),
                child: const Text('Cancel Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Cancel order from Firebase
  Future<void> cancelOrder(String? orderKey) async {
    if (orderKey != null) {
      await _dbRef.child(orderKey).remove();
    }
  }
}*/
//Apna real code
/*class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Initialize TabController in the first frame after the widget tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 5, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Current Order", style: TextStyle(color: Colors.white60)),
          backgroundColor: Colors.transparent,
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabController != null
                  ? TabBar(
                isScrollable: true,  // Enable horizontal scrolling
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              )
                  : SizedBox.shrink(),
            ),
          ),
        ),
        body: _tabController != null
            ? TabBarView(
          controller: _tabController,
          children: [
            Center(child: Text("Pending", style: TextStyle(fontSize: 24))),
            Center(child: Text("On The Way", style: TextStyle(fontSize: 24))),
            Center(child: Text("Completed", style: TextStyle(fontSize: 24))),
            Center(child: Text("Canceled", style: TextStyle(fontSize: 24))),
            Center(child: Text("All Order", style: TextStyle(fontSize: 24))),
          ],
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}*/
/*class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Ensures the TabController is available during the widget's first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 5, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Current Order",style: TextStyle(color:Colors.white60),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900,],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabController != null
                  ? TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900,Colors.brown,],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              )
                  : SizedBox.shrink(), // Show empty space until controller is available
            ),
          ),
        ),
        body: _tabController != null
            ? TabBarView(
          controller: _tabController,
          children: [
            Center(child: Text("Pending", style: TextStyle(fontSize: 24))),
            Center(child: Text("On The Way", style: TextStyle(fontSize: 24))),
            Center(child: Text("Completed", style: TextStyle(fontSize: 24))),
            Center(child: Text("Canceled", style: TextStyle(fontSize: 24))),
            Center(child: Text("All Order", style: TextStyle(fontSize: 24))),
          ],
        )
            : Center(child: CircularProgressIndicator()), // Show loading until controller is ready
      ),
    );
  }
}*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Pages/OrderCategare.dart';
import 'package:fyp/Widget/support_widget.dart';
import 'package:fyp/services/database.dart';
import 'package:fyp/services/shared_prefernces.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Current Order",
            style: Appwidget.boldTextFeildStyle(),
          ),
          bottom: TabBar(

            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: primaryColors, // Color of the tab indicator
            labelColor: primaryColors, // Color of the selected tab text
            unselectedLabelColor: Colors.black, // Color of the unselected tab text
            indicatorWeight: 3.0, // Thickness of the tab indicator
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'On The Way'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
              Tab(text: 'All Orders'),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Ordercategare()
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                // child:Ordercate,
                child: OrderCategare(num: 1),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: OrderCategare(num: 4),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: OrderCategare(num: 2),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: OrderCategare(num: 3),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: OrderCategare(num: 0),
              ),
            ), // Placeholder for pending orders
            // Center(child: Text('Completed Orders')), // Placeholder for completed orders
          ],
        ),
      ),
    );
  }
}*/
// zain
/*
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:furnitureworldapplication/Screen/Order/ordercategare.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders'); // Reference to Firebase Realtime Database

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Current Order",
          ),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: primaryColors, // Color of the tab indicator
            labelColor: primaryColors, // Color of the selected tab text
            unselectedLabelColor: Colors.black, // Color of the unselected tab text
            indicatorWeight: 3.0, // Thickness of the tab indicator
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'On The Way'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
              Tab(text: 'All Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderCategoryView('Pending'),
            _buildOrderCategoryView('On The Way'),
            _buildOrderCategoryView('Completed'),
            _buildOrderCategoryView('Canceled'),
            _buildOrderCategoryView('All Orders'),
          ],
        ),
      ),
    );
  }

  // Helper method to build the views for each order category based on status
  Widget _buildOrderCategoryView(String status) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: StreamBuilder(
          stream: _dbRef.orderByChild('status').equalTo(status).onValue, // Query orders by status
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading orders"));
            } else if (!snapshot.hasData || !snapshot.data!.snapshot.exists) {
              return const Center(child: Text("No orders available"));
            }

            // Extract the list of orders from the snapshot
            List<Map<dynamic, dynamic>> orders = [];
            snapshot.data!.snapshot.children.forEach((order) {
              orders.add(Map<dynamic, dynamic>.from(order.value as Map));
            });

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return OrderCategare(
                  orderData: order,
                  num: statusToNum(status), // Pass the status number to OrderCategare widget
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Convert status string to a number for `OrderCategare` widget
  int statusToNum(String status) {
    switch (status) {
      case 'Pending':
        return 1;
      case 'On The Way':
        return 4;
      case 'Completed':
        return 2;
      case 'Canceled':
        return 3;
      case 'All Orders':
        return 0;
      default:
        return 0;
    }
  }
}
*/