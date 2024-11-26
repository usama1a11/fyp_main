import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class FeedbackScreen extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('orders/feedback');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Feedback'),
        backgroundColor: Colors.brown.shade400,
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: _dbRef.once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error retrieving feedback'));
          }
          // Check if there's data and retrieve it
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No feedback available'));
          }
          // Extract feedback data
          final feedbackData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final feedbackList = feedbackData.entries.map((entry) {
            final feedback = entry.value;
            final double rating = feedback['rating']?.toDouble() ?? 0.0;

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feedback['feedback']),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Displaying the rating as stars
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: rating,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 4),
                        Text("(${feedback['rating']})"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList();
          return ListView(children: feedbackList);
        },
      ),
    );
  }
}