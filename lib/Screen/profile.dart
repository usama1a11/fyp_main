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
}
/*class _ProfileState extends State<Profile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  // Function to show bottom sheet
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.brown.shade100,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Option to pick from Camera
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                      _pickImage(ImageSource.camera); // Pick image from camera
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
                  // Option to pick from Gallery
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                      _pickImage(
                          ImageSource.gallery); // Pick image from gallery
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown.withOpacity(0.7),
        centerTitle: true,
        title: Text('Profile',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              // Display the image or prompt to select an image
              _image != null
                  ? GestureDetector(
                onTap: _showImagePickerOptions, // Show bottom sheet on tap
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(80),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
                  : GestureDetector(
                onTap: _showImagePickerOptions, // Show bottom sheet on tap
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(80),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(Icons.person,size: 40,color: Colors.black.withOpacity(0.5),),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
          
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text("Name",style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 20,fontWeight: FontWeight.w500),),
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text("Usama",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
                                SizedBox(width: 180,),
                                Icon(Icons.edit),
                              ],
                            ),
                          ],
                        ),
          
                      ],
                    ),
                  )
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
                      child: Row(
                        children: [
                          Icon(Icons.mail_outline,size: 40,color: Colors.black.withOpacity(0.5),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
          
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text("Email",style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Text("usamaq@gmail.com",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ],
                          ),
          
                        ],
                      ),
                    )
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
                      child: Row(
                        children: [
                          Icon(Icons.logout,size: 40,color: Colors.black.withOpacity(0.5),),
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: Text("LogOut",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(width: 167,),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    )
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
                      child: Row(
                        children: [
                          Icon(Icons.delete,size: 40,color: Colors.black.withOpacity(0.5),),
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: Text("Delete Account",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(width: 84,),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
