import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class WishlistProvider with ChangeNotifier {
  final Set<String> _wishlistItems = {};

  bool isInWishlist(String id) => _wishlistItems.contains(id);

  void addToWishlist(String id) {
    _wishlistItems.add(id);
    notifyListeners();
  }

  void removeFromWishlist(String id) {
    _wishlistItems.remove(id);
    notifyListeners();
  }

  void toggleWishlist(String id) {
    if (isInWishlist(id)) {
      removeFromWishlist(id);
    } else {
      addToWishlist(id);
    }
  }
}

