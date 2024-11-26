/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance.ref().child(
            'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Add product to Firestore
        await FirebaseFirestore.instance.collection('products').add({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'imageUrl': imageUrl,
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: _image != null
                          ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                          : Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.add_a_photo, size: 100),
                            ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (PKR)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadProduct,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.brown, // Button color
                      ),
                      child: Text(
                        'Add Product',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}*/
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';  // Import for Firebase Realtime Database
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Screen/wishprovider.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}
// real code
/*class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedCategory;  // For holding the selected category
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ]; // Category list

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance.ref().child(
            'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Add product to Firebase Realtime Database
        DatabaseReference databaseRef = FirebaseDatabase.instance.ref('products').push();
        await databaseRef.set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'category': selectedCategory,  // Save selected category
          'imageUrl': imageUrl,
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        setState(() {
          _image = null;
          selectedCategory = null;  // Reset category
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: _image != null
                          ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                          : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add_a_photo, size: 100),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (PKR)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Dropdown for category selection
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      validator: (value) => value == null
                          ? 'Please select a category'
                          : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadProduct,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.brown, // Button color
                      ),
                      child: Text(
                        'Add Product',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}*/
/*class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedCategory;  // For holding the selected category
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ]; // Category list

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Push product data to Firebase Realtime Database
        await FirebaseDatabase.instance.ref('products').push().set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'category': selectedCategory,
          'imageUrl': imageUrl,  // Image URL from Firebase Storage
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields after successful upload
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        setState(() {
          _image = null;
          selectedCategory = null;  // Reset category
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: _image != null
                          ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                          : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add_a_photo, size: 100),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (PKR)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Dropdown for category selection
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      validator: (value) =>
                      value == null ? 'Please select a category' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadProduct,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.brown, // Button color
                      ),
                      child: Text(
                        'Add Product',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}*/
//real ok
/*class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedCategory; // For holding the selected category
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ]; // Category list

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Convert image to base64 string
        final bytes = await _image!.readAsBytes();
        String base64Image = base64Encode(bytes);

        // Push product data to Firebase Realtime Database
        await FirebaseDatabase.instance.ref('products').push().set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'category': selectedCategory,
          'image': base64Image,  // Store base64 image string
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields after successful upload
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        setState(() {
          _image = null;
          selectedCategory = null; // Reset category
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: _image != null
                          ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                          : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add_a_photo, size: 100),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (PKR)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Dropdown for category selection
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      validator: (value) =>
                      value == null ? 'Please select a category' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadProduct,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.brown, // Button color
                      ),
                      child: Text(
                        'Add Product',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}*/
/*class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedCategory;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ];

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Push product data to Firebase Realtime Database
        await FirebaseDatabase.instance.ref('products').push().set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'category': selectedCategory,
          'imageUrl': imageUrl, // Store image URL
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields after successful upload
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        setState(() {
          _image = null;
          selectedCategory = null;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
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
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: _image != null
                            ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                            : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add_a_photo, size: 100),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (PKR)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        validator: (value) =>
                        value == null ? 'Please select a category' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: uploadProduct,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.brown, // Button color
                        ),
                        child: Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}*/
//right all
/*
class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(); // New controller for stock
  String? selectedCategory;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ];

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Push product data to Firebase Realtime Database
        await FirebaseDatabase.instance.ref('products').push().set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'category': selectedCategory,
          'imageUrl': imageUrl, // Store image URL
          'stock': int.parse(stockController.text.trim()),
          'quantity': 1,// Store stock quantity
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields after successful upload
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        stockController.clear(); // Clear the stock field
        setState(() {
          _image = null;
          selectedCategory = null;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose(); // Dispose of the stock controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
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
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: _image != null
                            ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                            : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add_a_photo, size: 100),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (US)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: stockController, // Stock field
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Stock Quantity',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stock quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        validator: (value) =>
                        value == null ? 'Please select a category' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: uploadProduct,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.brown, // Button color
                        ),
                        child: Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}*/
//te to final hai
/*class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(); // New controller for stock
  String? selectedCategory;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ];

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });
      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Push product data to Firebase Realtime Database
        await FirebaseDatabase.instance.ref('products').push().set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'category': selectedCategory,
          'imageUrl': imageUrl, // Store image URL
          'stock': int.parse(stockController.text.trim()),
          'quantity': 1, // Default quantity value is 1
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields after successful upload
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        stockController.clear(); // Clear the stock field
        setState(() {
          _image = null;
          selectedCategory = null;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose(); // Dispose of the stock controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
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
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: _image != null
                            ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                            : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add_a_photo, size: 100),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (US)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: stockController, // Stock field
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Stock Quantity',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stock quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        validator: (value) =>
                        value == null ? 'Please select a category' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: uploadProduct,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.brown, // Button color
                        ),
                        child: Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}*/
class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(); // Controller for stock
  final costPriceController = TextEditingController(); // New controller for cost price
  String? selectedCategory;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final List<String> categories = [
    "All",
    "Chair",
    "Table",
    "Sofa",
    "Bed",
  ];

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future<void> uploadProduct() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please select an image.');
        return;
      }

      if (selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Please select a category.');
        return;
      }

      setState(() {
        isLoading = true;
      });
      try {
        // Upload image to Firebase Storage
        String imageUrl = '';
        Reference ref = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();

        // Push product data to Firebase Realtime Database
        await FirebaseDatabase.instance.ref('products').push().set({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': priceController.text.trim(),
          'costPrice': costPriceController.text.trim(), // Save cost price
          'category': selectedCategory,
          'imageUrl': imageUrl, // Store image URL
          'stock': int.parse(stockController.text.trim()),
          'quantity': 1, // Default quantity value is 1
        });

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Reset fields after successful upload
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        stockController.clear(); // Clear the stock field
        costPriceController.clear(); // Clear the cost price field
        setState(() {
          _image = null;
          selectedCategory = null;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose(); // Dispose of the stock controller
    costPriceController.dispose(); // Dispose of the cost price controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
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
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: _image != null
                            ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                            : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add_a_photo, size: 100),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (US)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: costPriceController, // Cost price field
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Cost Price',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cost price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: stockController, // Stock field
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Stock Quantity',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stock quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        validator: (value) =>
                        value == null ? 'Please select a category' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: uploadProduct,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.brown, // Button color
                        ),
                        child: Text(
                          'Add Product',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

