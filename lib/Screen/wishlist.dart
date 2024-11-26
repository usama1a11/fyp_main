import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Screen/wishprovider.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:provider/provider.dart';
class Wishlist extends StatefulWidget {
  @override
  State<Wishlist> createState() => _WishlistState();
}
class _WishlistState extends State<Wishlist> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('Wishlist');
  late WishlistProvider wishlistProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wishlistProvider = Provider.of<WishlistProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text("Wishlist",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 25),),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DatabaseEvent>(
            stream: _databaseReference.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.brown,
                  ),
                );
              } else {
                final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                if (data == null || data.isEmpty) {
                  return Center(
                    child: Text(
                      'Your wishlist is empty!',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  );
                } else {
                  final list = data.values.toList();
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final price = item['Price'];
                      final id = item['Id'];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              label: "Delete",
                              onPressed: (context) {
                                _databaseReference.child(id).remove().then((_) {
                                  wishlistProvider.removeFromWishlist(id);
                                  setState(() {}); // Update UI after deletion
                                  Fluttertoast.showToast(msg: "Deleted Successfully");
                                }).onError((error, stackTrace) {
                                  Fluttertoast.showToast(msg: "Something went wrong");
                                });
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.brown.withOpacity(0.5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(item['Image']),
                            ),
                            title: Text(
                              item['Title'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                            ),
                            subtitle: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              item['Description'],
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                            ),
                            trailing: Text(
                              "\$$price",
                              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
/*
      ),
    );
  }
}*/
/*class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('Wishlist');
  late  WishlistProvider wishlistProvider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text("Wishlist"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DatabaseEvent>(
            stream: _databaseReference.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.brown,
                  ),
                );
              } else {
                final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                if (data == null || data.isEmpty) {
                  return Center(
                    child: Text(
                      'Your wishlist is empty!',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  );
                } else {
                  final list = data.values.toList();
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final price = item['Price'];
                      final id = item['Id'];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              label: "Delete",
                              onPressed: (context) {
                                _databaseReference.child(id).remove().then((_) {
                                  wishlistProvider.removeFromWishlist(item['id']); // Notify provider
                                  Fluttertoast.showToast(msg: "Deleted Successfully");
                                }).onError((error, stackTrace) {
                                  Fluttertoast.showToast(msg: "Something went wrong");
                                });
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(item['Image']),
                            ),
                            title: Text(
                              item['Title'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                            ),
                            subtitle: Text(
                              item['Description'],
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                            ),
                            trailing: Text(
                              "Rs ${price}",
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );


                    },
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}*/
/* final dref=FirebaseDatabase.instance.ref().child('Wishlist');
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.withOpacity(0.7),
        centerTitle: true,
        title: Text("Wishlist"),
      ),
      body:   Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: dref.onValue,
            builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
              if(!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(
                  color: Colors.brown,
                ));
              }
              else{
                Map<dynamic,dynamic> map=snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list=[];
                list.clear();
                list =map.values.toList();
                  return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context,index){
                        var price=list[index]['Price'];
                        // var id=list[index]['Id'];
                        // print(price.runtimeType);
                        return Slidable(
                          endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  label: "Delete",
                                  onPressed: (context){
                                    setState(() {
                                      dref.child(list[index]['Id']).remove().then((value){
                                        Fluttertoast.showToast(msg: "Deleted Successfully");
                                      }).onError((error, stackTrace){
                                        Fluttertoast.showToast(msg: "Something is wrong");
                                      });
                                    });
                                    // Navigator.pop(context);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                ),
                              ]
                          ), child: Container(
                          child: Card(
                            child: ListTile(
                              // leading: Icon(Icons.person),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage:AssetImage(list[index]['Image']) ,
                              ),
                              title: Text(list[index]['Title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
                              subtitle: Text(list[index]['Description'],style: TextStyle(color: Colors.black.withOpacity(0.5)),),
                              trailing: Text(textAlign: TextAlign.justify,"Rs ${price}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                              // trailing: Text(list[index]['Price']),
                            ),
                          ),
                        ),
                        );
                      });
                }
              }
            ),
      ),
    );
  }*/
/*return Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              label: "Delete",
                              onPressed: (context) {
                                setState(() {
                                  _databaseReference.child(id).remove().then((_) {
                                    Fluttertoast.showToast(msg: "Deleted Successfully");
                                  }).onError((error, stackTrace) {
                                    Fluttertoast.showToast(msg: "Something went wrong");
                                  });
                                });
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.brown.shade100,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(item['Image']),
                            ),
                            title: Text(
                              item['Title'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                            ),
                            subtitle: Text(
                              item['Description'],
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                            ),
                            trailing: Text(
                              "Rs ${price}",
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );*/
/*   body: Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, child) {
            return StreamBuilder<DatabaseEvent>(
              stream: _databaseReference.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.brown,
                    ),
                  );
                } else {
                  final data = snapshot.data!.snapshot.value as Map<
                      dynamic,
                      dynamic>?;
                  if (data == null || data.isEmpty) {
                    return Center(
                      child: Text(
                        'Your wishlist is empty!',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    );
                  } else {
                    final list = data.values.toList();
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final price = item['Price'];
                        final id = item['Id'];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                label: "Delete",
                                onPressed: (context) {
                                  _databaseReference.child(id).remove().then((_) {
                                    wishlistProvider.removeFromWishlist(id); // Correct the id usage
                                    Fluttertoast.showToast(msg: "Deleted Successfully");
                                  }).onError((error, stackTrace) {
                                    Fluttertoast.showToast(msg: "Something went wrong");
                                  });
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: Card(
                            color: Colors.brown.withOpacity(0.5),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(item['Image']),
                              ),
                              title: Text(
                                item['Title'],
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                              subtitle: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                item['Description'],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                              trailing: Text(
                                "Rs $price",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            );
          },
        ),*/

