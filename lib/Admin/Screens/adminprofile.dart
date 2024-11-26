import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}
class _AdminProfileState extends State<AdminProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final databaseReference = FirebaseDatabase.instance.ref('/admin'); // Reference to 'admin' node in Firebase
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadImageFromPreferences(); // Load the image from SharedPreferences when the screen loads
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
  void _loadImageFromPreferences() async {
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
  void _showEditPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Password', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
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
                _updateUserPassword();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
  void _updateUserPassword() async {
    if (databaseReference != null) {
      await databaseReference!.update({
        'password': _passwordController.text,
      });
      setState(() {});
    }
  }
  Future<void> _logout() async {
    await databaseReference;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(context, '/admin');
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
          title: Text('Admin Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
                      height: 78,
                      width: double.infinity,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 40, color: Colors.black.withOpacity(0.5)),
                        title: Text(
                          "Password",
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
                              String password = data['password'] ?? 'No name found';

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  maxLines: 1,
                                  password,
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
                          onPressed: _showEditPasswordDialog,
                          icon: Icon(Icons.edit),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*  InkWell(
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
                ),*/
/*  Padding(
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
                ),*/
/* void _updateUserPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.withOpacity(0.7),
          title: Text('Edit Password', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _passwordController,  // Use the correct password controller
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _updateUserPassword();  // Call the update function
                Navigator.of(context).pop();  // Close the dialog after updating
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }*/
/*  void _updateUserPassword() async {
    if (databaseReference != null && _passwordController.text.isNotEmpty) {
      try {
        await databaseReference!.update({
          'password': _passwordController.text.trim(),  // Update the password
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password updated successfully!'),
        ));
        setState(() {});  // Trigger UI update after password change
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating password: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password cannot be empty!'),
      ));
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
  }

  Future<void> _setUserDataReference() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      databaseReference = FirebaseDatabase.instance.ref().child('Admins').child(uid);
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
    Navigator.pushReplacementNamed(context, '/admin_login');
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await databaseReference?.remove();
      await user.delete().then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false); // Set login state to false
        Navigator.pushReplacementNamed(context, '/admin_Register');
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
          title: Text('Admin Profile', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25)),
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
