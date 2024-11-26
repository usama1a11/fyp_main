/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DatabaseReference? databaseReference;
  TextEditingController _nameController = TextEditingController(); // Controller for the name field

  @override
  void initState() {
    super.initState();
    _setUserDataReference();
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Register').child(uid);
      // Set the initial value of the name controller with the current user's name
      databaseReference!.child('name').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          _nameController.text = snapshot.snapshot.value.toString();
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.camera),
                        ),
                        SizedBox(height: 10),
                        Text("Camera", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.photo),
                        ),
                        SizedBox(height: 10),
                        Text("Gallery", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show the dialog for editing name
  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Name',style: TextStyle(color: Colors.black),),
          content: TextField(
            controller: _nameController, // Use the name controller
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel',style: TextStyle(color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                _updateUserName(); // Update the user's name in Firebase
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save',style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

  // Function to update the user's name in Firebase
  void _updateUserName() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'name': _nameController.text, // Update the name in Firebase
      });
      setState(() {
        // Update UI after name is changed
      });
    }
  }
  // Function to log out the user and go back to login screen
  Future<void> _logout() async {
    await _auth.signOut(); // Log out from Firebase
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
  }
  // Delete Account functionality
  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Delete user data from Realtime Database
      await databaseReference?.remove();
      // Delete user from Firebase Auth
      await user.delete().then((val){
        Navigator.pushReplacementNamed(context, '/register'); // Navigate to register screen
        setState(() {

        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text('Profile Screen',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                _image != null
                    ? GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child:
                    Container(
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title:  Text("Name",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(
                                  snapshot.data!.snapshot.value as Map);
                              String name = data['name'] ?? 'No name found';
      
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                    maxLines: 1,
                                    name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20)),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                        trailing:  IconButton(
                          onPressed: _showEditNameDialog, // Call the dialog
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
                // ... other widgets (email, logout, etc.)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListTile(
                        leading:Icon(Icons.mail_outline, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text("Email", style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w500)),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(
                                  snapshot.data!.snapshot.value as Map);
                              String name = data['email'] ?? 'No name found';
      
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                    maxLines: 1,
                                    name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _logout,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 40, color: Colors.black.withOpacity(0.5)),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text("LogOut", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(width: 120),
                              Icon(Icons.arrow_forward_ios,size: 25,color: Colors.black.withOpacity(0.5),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 40, color: Colors.black.withOpacity(0.5)),
                              Padding(
                                padding: const EdgeInsets.only(left: 19.0),
                                child: Text("Delete Account", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(width: 37,),
                              Icon(Icons.arrow_forward_ios,size: 25,color: Colors.black.withOpacity(0.5),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Profile1 extends StatefulWidget {
  @override
  _Profile1State createState() => _Profile1State();
}
/*class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DatabaseReference? databaseReference;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserDataReference();
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Register').child(uid);
      databaseReference!.child('name').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          _nameController.text = snapshot.snapshot.value.toString();
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.camera),
                        ),
                        SizedBox(height: 10),
                        Text("Camera", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.photo),
                        ),
                        SizedBox(height: 10),
                        Text("Gallery", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Name', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _updateUserName();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _updateUserName() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'name': _nameController.text,
      });
      setState(() {});
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await databaseReference?.remove();
      await user.delete().then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Set login state to false
        Navigator.pushReplacementNamed(context, '/register');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text('Profile Screen', style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 25)),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                _image != null
                    ? GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String name = data['name'] ?? 'No name found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                        trailing: IconButton(
                          onPressed: _showEditNameDialog,
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.mail_outline, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text("Email", style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w500)),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String email = data['email'] ?? 'No email found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _logout,
                  child:    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.logout, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: _showEditNameDialog,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.delete, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: _showEditNameDialog,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
/*class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DatabaseReference? databaseReference;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserDataReference();
    _loadImageFromPreferences(); // Load the image when initializing the state
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Register').child(uid);
      databaseReference!.child('name').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          _nameController.text = snapshot.snapshot.value.toString();
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToPreferences(_image!); // Save the picked image to preferences
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImageToPreferences(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);
    await prefs.setString('profileImage', base64String);
  }

  Future<void> _loadImageFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final base64String = prefs.getString('profileImage');
    if (base64String != null) {
      final bytes = base64Decode(base64String);
      setState(() {
        _image = File.fromRawPath(bytes);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.camera),
                        ),
                        SizedBox(height: 10),
                        Text("Camera", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.photo),
                        ),
                        SizedBox(height: 10),
                        Text("Gallery", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Name', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _updateUserName();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _updateUserName() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'name': _nameController.text,
      });
      setState(() {});
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await databaseReference?.remove();
      await user.delete().then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Set login state to false
        Navigator.pushReplacementNamed(context, '/register');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text('Profile Screen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                _image != null
                    ? GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Rest of your profile widgets...
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String name = data['name'] ?? 'No name found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                        trailing: IconButton(
                          onPressed: _showEditNameDialog,
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.mail_outline, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text("Email", style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w500)),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String email = data['email'] ?? 'No email found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _logout,
                  child:    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.logout, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: _showEditNameDialog,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.delete, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: _showEditNameDialog,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
//ok but image same ata hai admin mn
/*
class _Profile1State extends State<Profile1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DatabaseReference? databaseReference;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserDataReference();
    _loadImageFromPreferences1(); // Load the image from SharedPreferences when the screen loads
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Register').child(uid);
      databaseReference!.child('name').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          _nameController.text = snapshot.snapshot.value.toString();
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToPreferences(pickedFile.path); // Save image path to SharedPreferences
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveImageToPreferences(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  void _loadImageFromPreferences1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.camera),
                        ),
                        SizedBox(height: 10),
                        Text("Camera", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.photo),
                        ),
                        SizedBox(height: 10),
                        Text("Gallery", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Name', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _updateUserName();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _updateUserName() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'name': _nameController.text,
      });
      setState(() {});
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await databaseReference?.remove();
      await user.delete().then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Set login state to false
        Navigator.pushReplacementNamed(context, '/register');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                _image != null
                    ? GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                // Rest of the widget code...
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String name = data['name'] ?? 'No name found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                        trailing: IconButton(
                          onPressed: _showEditNameDialog,
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.mail_outline, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text("Email", style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w500)),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String email = data['email'] ?? 'No email found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _logout,
                  child:    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.logout, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: _showEditNameDialog,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.delete, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: _showEditNameDialog,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
// real code
/*class _Profile1State extends State<Profile1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DatabaseReference? databaseReference;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserDataReference();
    _loadImageFromPreferences(); // Load the image from SharedPreferences when the screen loads
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Register').child(uid);
      databaseReference!.child('name').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          _nameController.text = snapshot.snapshot.value.toString();
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToPreferences(pickedFile.path); // Save image path to SharedPreferences
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveImageToPreferences(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    // Save the image separately for each user/admin using their UID or role
    if (user != null) {
      await prefs.setString('profile_image_${user.uid}', imagePath);
    }
  }

  void _loadImageFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    // Load the image based on the user's UID or role
    if (user != null) {
      String? imagePath = prefs.getString('profile_image_${user.uid}');
      if (imagePath != null) {
        setState(() {
          _image = File(imagePath);
        });
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.camera),
                        ),
                        SizedBox(height: 10),
                        Text("Camera", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.photo),
                        ),
                        SizedBox(height: 10),
                        Text("Gallery", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Name', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _updateUserName();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _updateUserName() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'name': _nameController.text,
      });
      setState(() {});
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await databaseReference?.remove();
      await user.delete().then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Set login state to false
        Navigator.pushReplacementNamed(context, '/register');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                _image != null
                    ? GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                // Rest of the widget code...
                SizedBox(height: 20),
                // Rest of your profile widgets...
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String name = data['name'] ?? 'No name found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                        trailing: IconButton(
                          onPressed: _showEditNameDialog,
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.mail_outline, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text("Email", style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w500)),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String email = data['email'] ?? 'No email found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _logout,
                  child:    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.logout, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.delete, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
class _Profile1State extends State<Profile1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DatabaseReference? databaseReference;
  TextEditingController _nameController = TextEditingController();
  String? _email;

  @override
  void initState() {
    super.initState();
    _setUserDataReference();
    _loadProfileData(); // Load both image and user data when screen loads
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Register').child(uid);
      databaseReference!.child('name').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          _nameController.text = snapshot.snapshot.value.toString();
        }
      });

      // Load the email from Firebase
      databaseReference!.child('email').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          setState(() {
            _email = snapshot.snapshot.value.toString();
          });
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToPreferences(pickedFile.path); // Save image path to SharedPreferences
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveImageToPreferences(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    // Save the image separately for each user/admin using their UID
    if (user != null) {
      await prefs.setString('profile_image_${user.uid}', imagePath);
    }
  }

  void _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    // Load the image and user data based on the user's UID
    if (user != null) {
      String? imagePath = prefs.getString('profile_image_${user.uid}');
      if (imagePath != null) {
        setState(() {
          _image = File(imagePath);
        });
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.camera),
                        ),
                        SizedBox(height: 10),
                        Text("Camera", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.photo),
                        ),
                        SizedBox(height: 10),
                        Text("Gallery", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Name', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _updateUserName();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _updateUserName() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'name': _nameController.text,
      });
      setState(() {}); // Force rebuild to reflect updated name
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await databaseReference?.remove();
      await user.delete().then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Set login state to false
        Navigator.pushReplacementNamed(context, '/register');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                _image != null
                    ? GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: StreamBuilder(
                          stream: databaseReference?.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              String name = data['name'] ?? 'No name found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading...");
                            } else {
                              return Text("No data available");
                            }
                          },
                        ),
                        trailing: IconButton(
                          onPressed: _showEditNameDialog,
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.mail_outline, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            maxLines: 1,
                            _email ?? 'No email found',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _logout,
                  child:    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.logout, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        height: 78,
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.delete, size: 40, color: Colors.black.withOpacity(0.5)),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
