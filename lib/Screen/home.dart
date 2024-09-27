import 'dart:async';
// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furnitureworldapplication/Buyer/detail.dart';
import 'package:furnitureworldapplication/Colors/app_color.dart';
import 'package:furnitureworldapplication/Screen/cart.dart';
import 'package:furnitureworldapplication/Screen/constants.dart';
import 'package:furnitureworldapplication/Screen/tabbar.dart';
import 'package:furnitureworldapplication/Screen/wishprovider.dart';
import 'package:furnitureworldapplication/models/categories_icon.dart';
import 'package:furnitureworldapplication/models/products.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int isselected = 0;
  bool isFavorite = false;
  TextEditingController _searchController = TextEditingController();
  List<Products> filteredProducts = [];

  // Define your all product lists here
  List<Products> AllProducts=[
    Products(title: "Rock Chair", price: 50.00, image: "images/rc.png", review: '*****', id: '12', description: 'The defining feature of a rocking chair is its curved base, or rockers, which allow the chair to sway back and forth smoothly.', quantity: 1),
    Products(title: "Wood Table", price: 88.00, image: "images/wt.png", review: '****',id: '13', description: 'The basic processes of wooden furniture manufacturing include wood cutting, milling, planing, drilling, grinding, assembly, paint finishing, etc.', quantity: 1),
    Products(title: "Foam Sofa", price: 77.00, image: "images/ms.png", review: '****',id: '14', description: 'Foam is used internally in almost all sofas, but it is also used as a cushion filling.', quantity: 1),
    Products(title: "Soft Chair", price: 66.00, image: "images/cap.png", review: '****',id: '15', description: 'A chair is a type of seat, typically designed for one person and consisting of one or more legs, a flat or slightly angled seat and a back-rest.', quantity: 1),
    Products(title: "Luxury Bed", price: 90.00, image: "images/lb.png", review: '****',id: '16', description: 'Velvet and leather are quintessential materials for luxury beds, enhancing both the visual and tactile experience.', quantity: 1),
    Products(title: "Luxury Sofa", price: 65.00, image: "images/ls.png", review: '****',id: '17', description: 'In a nutshell, a luxury sofa should look exceptionally stylish and stand out for its choice of fabrics and finishes.', quantity: 1),
  ];
  List<Products> ChairProducts=[
    Products(title: "Club Chair", price: 30.00, image: "images/clubch.png", review: '*****', id: '6', description: 'A club chair is a type of armchair, usually covered in leather it was created and made in France.', quantity: 1),
    Products(title: "Barber Chair", price: 28.00, image: "images/barch.png", review: '****',id: '7', description: 'A specially constructed chair used in barbershops and usually having a footrest, a backrest that may be lowered to reclining position.', quantity: 1),
    Products(title: "Desk Chair", price: 16.00, image: "images/deskch.png", review: '****',id: '8', description: 'An office chair, or desk chair, is a type of chair that is designed for use at a desk in an office. It is usually a swivel chair.', quantity: 1),
    Products(title: "Winder Chair", price: 25.00, image: "images/winch.png", review: '****',id: '9', description: 'Wooden Windsor dining chairs are characterized by turned spindle backs that are attached to solid, sculpted seats.', quantity: 1),
    Products(title: "Dining Chair", price: 49.00, image: "images/dinch.png", review: '****',id: '10', description: 'Look for dining chair designs with classic features, such as twisted legs or carved details, for traditional dining rooms.', quantity: 1),
    Products(title: "Arm Chair", price: 20.00, image: "images/armch.png", review: '****',id: '11', description: 'Armchairs are variations of common chairs, but are designed with fixed armrests and are often upholstered and cushioned.', quantity: 1),
  ];
  List<Products> TableProducts=[
    Products(title: "Bed Table", price: 20.00, image: "images/bedt.png", review: '*****', id: '18', description: 'An adjustable table or a tray with legs, designed to extend over or rest upon a bed. night table.', quantity: 1),
    Products(title: "Office Table", price: 38.00, image: "images/offt.png", review: '****',id: '19', description: 'An office table is a specific piece of office furniture designed primarily for working or holding items.', quantity: 1),
    Products(title: "Coffee Table", price: 41.00, image: "images/coft.png", review: '****',id: '20',description: 'A coffee table will usually be low and wide and is generally placed in front of a sofa. It is often used as an informal division.', quantity: 1),
    Products(title: "Tea Table", price: 58.00, image: "images/teat.png", review: '****',id: '21', description: 'A small table  holding a tea service and cups, plates, etc.,  several people.', quantity: 1),
    Products(title: "Home Table", price: 60.00, image: "images/homet.png", review: '****',id: '22', description: 'A table is an item of furniture with a raised flat top and is supported most commonly by 1 to 4 legs.', quantity: 1),
    Products(title: "Work Table", price: 40.00, image: "images/wort.png", review: '****',id: '23', description: 'A table for holding working materials and implements. especially : a small table with drawers and other conveniences for needlework', quantity: 1),
  ];
  List<Products> SofaProducts=[
    Products(title: "Chair Sofa", price: 15.00, image: "images/sofap.png", review: '*****', id: '24', description: 'Traditional sofas encompass period details, such as hand turned feet heritage shapes including much loved Chesterfield sofa.', quantity: 1),
    Products(title: "Room Sofa", price:  23.00, image: "images/sofap3.png", review: '****',id: '25', description: 'As its name would suggest, the camelback sofa is characterised by a pronounced hump (or two) on its seat back.', quantity: 1),
    Products(title: "Daybed Sofa", price: 20.00, image: "images/sofap2.png", review: '****',id: '26', description: 'A couch that can be used as a sofa by day and a bed by night. a couch, especially of the 17th or 18th century.', quantity: 1),
    Products(title: "Lawson Sofa", price: 34.00, image: "images/sofap1.png", review: '****',id: '27', description: 'Modern Lawson style sofa that comes as a sectional, chaise end couch or as a 2, 3, 4, 5 or more seater. ', quantity: 1),
    Products(title: "Family Sofa", price: 40.00, image: "images/sofap4.png", review: '****',id: '28', description: 'A long upholstered seat usually with arms and a back and often convertible into a bed.', quantity: 1),
    Products(title: "Modular Sofa", price: 69.00, image: "images/sofap5.png", review: '****',id: '29', description: 'They are designed in separate, easy-to-handle components that effortlessly come together to make your sofa whole.', quantity: 1),
  ];
  List<Products> BedProducts=[
    Products(title: "Dream Haven", price: 30.00, image: "images/bed1.png", review: '*****', id: '30', description: 'A bed dream may also indicate that you are putting in a lot of effort to take your rightful place in this world.', quantity: 1),
    Products(title: "Comfort Zone", price: 78.00, image: "images/bed4.png", review: '****',id: '31', description: 'A comfort zone in its purist term is when a mattress contains various tensions, densities, that has a variety of zones within it.', quantity: 1),
    Products(title: "Sleepy Hollow", price: 71.00, image: "images/bed3.png", review: '****',id: '32', description: 'A piece of furniture upon which or within which a person sleeps, rests, or stays when not well.', quantity: 1),
    Products(title: "Serene Sleep", price: 68.00, image: "images/bed2.png", review: '****',id: '33', description: 'A serene sleep bed is calm, peaceful, or tranquil; unruffled: a serene landscape in which you can feel easily.', quantity: 1),
    Products(title: "Slumber Style", price: 97.00, image: "images/bed5.png", review: '****',id: '34', description: 'A slumber bed is beautiful bed, quiescence, or calm: Vesuvius is slumbering.', quantity: 1),
    Products(title: "Cozy Comfort", price: 69.00, image: "images/bed6.png", review: '****',id: '35', description: 'ComfortableAfter a long journey I was looking forward to sleeping in a comfortable bed.', quantity: 1),
  ];

  List<Map<String, dynamic>> allCategories = [
    {"name": "All", "icon": Icons.all_inclusive},
    {"name": "Chair", "icon": Icons.chair},
    {"name": "Table", "icon": Icons.table_bar},
    {"name": "Sofa", "icon": Icons.chair_alt},
    {"name": "Bed", "icon": Icons.bed},
  ];

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: allCategories.length,
      vsync: this,
      initialIndex: isselected,
    );

    _tabController.addListener(() {
      setState(() {
        isselected = _tabController.index;
        _filterProducts(_searchController.text);
      });
    });

    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });

    // Initialize with all products
    filteredProducts = AllProducts;
  }

  void _filterProducts(String query) {
    List<Products> tempList = [];
    List<Products> currentList;

    switch (isselected) {
      case 0: // All
        currentList = AllProducts;
        break;
      case 1: // Chair
        currentList = ChairProducts;
        break;
      case 2: // Table
        currentList = TableProducts;
        break;
      case 3: // Sofa
        currentList = SofaProducts;
        break;
      case 4: // Bed
        currentList = BedProducts;
        break;
      default:
        currentList = AllProducts;
        break;
    }

    if (query.isNotEmpty) {
      tempList = currentList.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      tempList = currentList;
    }

    setState(() {
      filteredProducts = tempList;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

/*  List<Products> cartList = [];

  // Method to add product to cart
  void addToCart(Products product) {
    setState(() {
      cartList.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Method to remove product from cart
  void removeFromCart(String productId) {
    setState(() {
      cartList.removeWhere((product) => product.id == productId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Product removed from cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Method to check if a product is already in the cart
  bool isInCart(String productId) {
    return cartList.any((product) => product.id == productId);
  }*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageStorage(
        bucket: _bucket,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Find Best\nFurnitures",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2.0,
                                blurRadius: 4.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 22),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          PersistentShoppingCart().showCartItemCountWidget(
                            cartItemCountWidgetBuilder: (itemCount) => IconButton(
                              onPressed: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context) =>  Cart1()));
                              },
                              icon: Badge(
                                label:Text(itemCount.toString()) ,
                                child: const Icon(Icons.shopping_bag_outlined,size: 40,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 99.0),
                  child: Text(
                    "Recommend for you",
                    style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: isselected == index ? Colors.brown.shade700 : Colors.brown.withOpacity(0.5),
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isselected = index;
                              _tabController.animateTo(index);
                              _filterProducts(_searchController.text);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  allCategories[index]["icon"],
                                  color: isselected == index ? Colors.white : Colors.black,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  allCategories[index]["name"],
                                  style: TextStyle(
                                    color: isselected == index ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: TabBarView(
                    key: PageStorageKey('tabBarView'),
                    controller: _tabController,
                    children: [
                      _buildProductGrid(filteredProducts), // All Products
                      _buildProductGrid(filteredProducts), // Chair Products
                      _buildProductGrid(filteredProducts), // Table Products
                      _buildProductGrid(filteredProducts), // Sofa Products
                      _buildProductGrid(filteredProducts), // Bed Products
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildProductGrid(List<Products> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 310,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        String productId = 'product_$index'; // Example product ID
        bool isFavorite = context.watch<WishlistProvider>().isInWishlist(productId);
        Products product= products[index];
        return gridViewCard(products[index]);
      },
    );
  }

  Widget gridViewCard(Products products) {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('Wishlist');
  return Consumer<WishlistProvider>(
    builder: (context, wishlistProvider, child) {
      final isInWishlist = wishlistProvider.isInWishlist(products.id);
      void toggleWishlist() {
        if (isInWishlist) {
          // Remove from wishlist in Firebase
          _databaseReference.child(products.id).remove().then((_) {
            wishlistProvider.toggleWishlist(products.id); // Update local state
            Fluttertoast.showToast(msg: "Removed from wishlist");
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(msg: "Failed to remove from wishlist");
          });
        } else {
          // Add to wishlist in Firebase
          _databaseReference.child(products.id).set({
            'Id': products.id,
            'Title': products.title,
            'Description': products.description,
            'Price': products.price,
            'Image': products.image,
          }).then((_) {
            wishlistProvider.toggleWishlist(products.id); // Update local state
            Fluttertoast.showToast(msg: "Added to wishlist");
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(msg: "Failed to add to wishlist");
          });
        }
      }
      return Stack(
        children: [
          Container(
            height: 380,
            width: 380,
            color: Colors.brown.withOpacity(0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: toggleWishlist,
                      icon: Icon(
                        Icons.favorite,
                        color: isInWishlist? Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(
                                products: Products(
                                  title: products.title,
                                  price: products.price,
                                  image: products.image,
                                  id: products.id,
                                  review: '',
                                  description: products.description,
                                  quantity: 1,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 140,
                          width: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(products.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    products.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    products.price.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 16),
                          Icon(Icons.star, color: Colors.white, size: 16),
                          Icon(Icons.star, color: Colors.white, size: 16),
                          Icon(Icons.star, color: Colors.white, size: 16),
                          Icon(Icons.star, color: Colors.white, size: 16),
                          SizedBox(
                            width: 24,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child:
                            PersistentShoppingCart().showAndUpdateCartItemWidget(
                              inCartWidget: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                    iconSize: 20,
                                    onPressed: (){
                                     PersistentShoppingCart().removeFromCart(products.id).then((value){
                                       Fluttertoast.showToast(msg: "Product remove from cart");
                                     }).onError((error,stackTrace){
                                       Fluttertoast.showToast(msg: "Product not remove to cart $error");
                                     });
                                    },
                                    icon: Icon(Icons.remove),
                                ),
                              ),
                              notInCartWidget: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  iconSize: 20,
                                  onPressed: (){
                                    PersistentShoppingCart().addToCart(
                                      PersistentShoppingCartItem(
                                        productId: products.id,
                                        productName: products.title,
                                        productDescription: products.description,
                                        unitPrice: double.parse(products.price.toString()),
                                        productThumbnail: products.image,
                                        quantity: products.quantity,
                                      ),
                                    ).then((value){
                                      Fluttertoast.showToast(msg: "Product add into cart");
                                    }).onError((error,stackTrace){
                                      Fluttertoast.showToast(msg: "Product not added to cart $error");
                                    });
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ),
                              product: PersistentShoppingCartItem(
                                productId: products.id,
                                productName: products.title,
                                productDescription: products.description,
                                unitPrice: double.parse(products.price.toString()),
                                productThumbnail: products.image,
                                quantity: products.quantity,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
}
/*  List<Products> AllProducts = [
    Products(title: "Rock Chair", price: "\$50.00", image: "images/rc.png", review: '*****', id: '12', description: 'The defining feature of a rocking chair is its curved base, or rockers, which allow the chair to sway back and forth smoothly.', quantity: 1),
    Products(title: "Wood Table", price: "\$88.00", image: "images/wt.png", review: '****',id: '13', description: 'The basic processes of wooden furniture manufacturing include wood cutting, milling, planing, drilling, grinding, assembly, paint finishing, etc.', quantity: 1),
    Products(title: "Foam Sofa", price: "\$77.00", image: "images/ms.png", review: '****',id: '14', description: 'Foam is used internally in almost all sofas, but it is also used as a cushion filling.', quantity: 1),
    Products(title: "Soft Chair", price: "\$66.00", image: "images/cap.png", review: '****',id: '15', description: 'A chair is a type of seat, typically designed for one person and consisting of one or more legs, a flat or slightly angled seat and a back-rest.', quantity: 1),
    Products(title: "Luxury Bed", price: "\$90.00", image: "images/lb.png", review: '****',id: '16', description: 'Velvet and leather are quintessential materials for luxury beds, enhancing both the visual and tactile experience.', quantity: 1),
    Products(title: "Luxury Sofa", price: "\$65.00", image: "images/ls.png", review: '****',id: '17', description: 'In a nutshell, a luxury sofa should look exceptionally stylish and stand out for its choice of fabrics and finishes.', quantity: 1),
  ];
  List<Products> ChairProducts = [
    Products(title: "Club Chair", price: "\$30.00", image: "images/clubch.png", review: '*****', id: '6', description: 'A club chair is a type of armchair, usually covered in leather it was created and made in France.', quantity: 1),
    Products(title: "Barber Chair", price: "\$28.00", image: "images/barch.png", review: '****',id: '7', description: 'A specially constructed chair used in barbershops and usually having a footrest, a backrest that may be lowered to reclining position.', quantity: 1),
    Products(title: "Desk Chair", price: "\$16.00", image: "images/deskch.png", review: '****',id: '8', description: 'An office chair, or desk chair, is a type of chair that is designed for use at a desk in an office. It is usually a swivel chair.', quantity: 1),
    Products(title: "Winder Chair", price: "\$25.00", image: "images/winch.png", review: '****',id: '9', description: 'Wooden Windsor dining chairs are characterized by turned spindle backs that are attached to solid, sculpted seats.', quantity: 1),
    Products(title: "Dining Chair", price: "\$49.00", image: "images/dinch.png", review: '****',id: '10', description: 'Look for dining chair designs with classic features, such as twisted legs or carved details, for traditional dining rooms.', quantity: 1),
    Products(title: "Arm Chair", price: "\$20.00", image: "images/armch.png", review: '****',id: '11', description: 'Armchairs are variations of common chairs, but are designed with fixed armrests and are often upholstered and cushioned.', quantity: 1),
  ];
  List<Products> TableProducts = [
    Products(title: "Bed Table", price: "\$20.00", image: "images/bedt.png", review: '*****', id: '18', description: 'An adjustable table or a tray with legs, designed to extend over or rest upon a bed. night table.', quantity: 1),
    Products(title: "Office Table", price: "\$38.00", image: "images/offt.png", review: '****',id: '19', description: 'An office table is a specific piece of office furniture designed primarily for working or holding items.', quantity: 1),
    Products(title: "Coffe Table", price: "\$41.00", image: "images/coft.png", review: '****',id: '20',description: 'A coffee table will usually be low and wide and is generally placed in front of a sofa. It is often used as an informal division.', quantity: 1),
    Products(title: "Tea Table", price: "\$58.00", image: "images/teat.png", review: '****',id: '21', description: 'A small table  holding a tea service and cups, plates, etc.,  several people.', quantity: 1),
    Products(title: "Home Table", price: "\$60.00", image: "images/homet.png", review: '****',id: '22', description: 'A table is an item of furniture with a raised flat top and is supported most commonly by 1 to 4 legs.', quantity: 1),
    Products(title: "Work Table", price: "\$40.00", image: "images/wort.png", review: '****',id: '23', description: 'A table for holding working materials and implements. especially : a small table with drawers and other conveniences for needlework', quantity: 1),
  ];
  List<Products> SofaProducts = [
    Products(title: "Traditonal Sofa", price: "\$15.00", image: "images/sofap.png", review: '*****', id: '24', description: 'Traditional sofas encompass period details, such as hand turned feet heritage shapes including much loved Chesterfield sofa.', quantity: 1),
    Products(title: "Camelback Sofa", price: "\$23.00", image: "images/sofap3.png", review: '****',id: '25', description: 'As its name would suggest, the camelback sofa is characterised by a pronounced hump (or two) on its seat back.', quantity: 1),
    Products(title: "Daybed Sofa", price: "\$20.00", image: "images/sofap2.png", review: '****',id: '26', description: 'A couch that can be used as a sofa by day and a bed by night. a couch, especially of the 17th or 18th century.', quantity: 1),
    Products(title: "Lawson Sofa", price: "\$34.00", image: "images/sofap1.png", review: '****',id: '27', description: 'Modern Lawson style sofa that comes as a sectional, chaise end couch or as a 2, 3, 4, 5 or more seater. ', quantity: 1),
    Products(title: "Family Sofa", price: "\$40.00", image: "images/sofap4.png", review: '****',id: '28', description: 'A long upholstered seat usually with arms and a back and often convertible into a bed.', quantity: 1),
    Products(title: "Modular Sofa", price: "\$69.00", image: "images/sofap5.png", review: '****',id: '29', description: 'They are designed in separate, easy-to-handle components that effortlessly come together to make your sofa whole.', quantity: 1),
  ];
  List<Products> BedProducts = [
    Products(title: "Dream Haven", price: "\$30.00", image: "images/bed1.png", review: '*****', id: '30', description: 'A bed dream may also indicate that you are putting in a lot of effort to take your rightful place in this world.', quantity: 1),
    Products(title: "Comfort Zone", price: "\$78.00", image: "images/bed4.png", review: '****',id: '31', description: 'A comfort zone in its purist term is when a mattress contains various tensions, densities, that has a variety of zones within it.', quantity: 1),
    Products(title: "Sleepy Hollow", price: "\$71.00", image: "images/bed3.png", review: '****',id: '32', description: 'A piece of furniture upon which or within which a person sleeps, rests, or stays when not well.', quantity: 1),
    Products(title: "Serene Sleep", price: "\$68.00", image: "images/bed2.png", review: '****',id: '33', description: 'A serene sleep bed is calm, peaceful, or tranquil; unruffled: a serene landscape in which you can feel easily.', quantity: 1),
    Products(title: "Slumber Style", price: "\$97.00", image: "images/bed5.png", review: '****',id: '34', description: 'A slumber bed is beautiful bed, quiescence, or calm: Vesuvius is slumbering.', quantity: 1),
    Products(title: "Cozy Comfort", price: "\$69.00", image: "images/bed6.png", review: '****',id: '35', description: 'ComfortableAfter a long journey I was looking forward to sleeping in a comfortable bed.', quantity: 1),
  ];*/
/*PersistentShoppingCart().showAndUpdateCartItemWidget(
                       inCartWidget: Padding(
                          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Padding(padding: const EdgeInsets.only(right: 2),
                              child: Container(
                              height: 35,
                              width: 35,
                            decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: Colors.white,
                   ),
                      child: Text("-",
                         style: TextStyle(
                         color: Colors.black,
                         fontSize: 20),
                   ),
                  ),
                 ),
                ],
               ),
              ),
                       notInCartWidget: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Text("+",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                       product: PersistentShoppingCartItem(
                           productId: products.id,
                           productName: products.title,
                           unitPrice: double.parse(products.price.toString()),
                           quantity: products.quantity)),*/
