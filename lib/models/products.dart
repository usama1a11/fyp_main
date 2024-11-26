import 'package:flutter/cupertino.dart';
class Products{
  final String title,image,review,description,id;
  double price;
  final int quantity,stock;
   Products({
    required this.title,
    required this.price,
    required this.image,
    required this.review,
    required this.id,
    required this.description,
    required this.quantity,
    required this.stock,
  });
  // Factory constructor to create a Products instance from a Map
/*  factory Products.fromMap(Map<dynamic, dynamic> data) {
    return Products(
      id: data['id'] as String? ?? '',
      title: data['name'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? '',
      image: data['imageUrl'] as String? ?? '', review: '', quantity: 1,stock: 10,
    );
  }*/
  // Optionally, add a method to convert a Products instance to a Map
/*  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'price': price,
      'description': description,
      'imageUrl': image,
    };
  }*/
}
/*
List AllProducts=[
  Products(title: "Rock Chair", price: 50.00, image: "images/rc.png", review: '*****', id: '12', description: 'The defining feature of a rocking chair is its curved base, or rockers, which allow the chair to sway back and forth smoothly.', quantity: 1, stock: 10),
  Products(title: "Wood Table", price: 88.00, image: "images/wt.png", review: '****',id: '13', description: 'The basic processes of wooden furniture manufacturing include wood cutting, milling, planing, drilling, grinding, assembly, paint finishing, etc.', quantity: 1,stock: 10),
  Products(title: "Foam Sofa", price: 77.00, image: "images/ms.png", review: '****',id: '14', description: 'Foam is used internally in almost all sofas, but it is also used as a cushion filling.', quantity: 1,stock: 10),
  Products(title: "Soft Chair", price: 66.00, image: "images/cap.png", review: '****',id: '15', description: 'A chair is a type of seat, typically designed for one person and consisting of one or more legs, a flat or slightly angled seat and a back-rest.', quantity: 1,stock: 10),
  Products(title: "Luxury Bed", price: 90.00, image: "images/lb.png", review: '****',id: '16', description: 'Velvet and leather are quintessential materials for luxury beds, enhancing both the visual and tactile experience.', quantity: 1,stock: 10),
  Products(title: "Luxury Sofa", price: 65.00, image: "images/ls.png", review: '****',id: '17', description: 'In a nutshell, a luxury sofa should look exceptionally stylish and stand out for its choice of fabrics and finishes.', quantity: 1,stock: 10),
];
List ChairProducts=[
  Products(title: "Club Chair", price: 30.00, image: "images/clubch.png", review: '*****', id: '6', description: 'A club chair is a type of armchair, usually covered in leather it was created and made in France.', quantity: 1,stock: 10),
  Products(title: "Barber Chair", price: 28.00, image: "images/barch.png", review: '****',id: '7', description: 'A specially constructed chair used in barbershops and usually having a footrest, a backrest that may be lowered to reclining position.', quantity: 1,stock: 10),
  Products(title: "Desk Chair", price: 16.00, image: "images/deskch.png", review: '****',id: '8', description: 'An office chair, or desk chair, is a type of chair that is designed for use at a desk in an office. It is usually a swivel chair.', quantity: 1,stock: 10),
  Products(title: "Winder Chair", price: 25.00, image: "images/winch.png", review: '****',id: '9', description: 'Wooden Windsor dining chairs are characterized by turned spindle backs that are attached to solid, sculpted seats.', quantity: 1,stock: 10),
  Products(title: "Dining Chair", price: 49.00, image: "images/dinch.png", review: '****',id: '10', description: 'Look for dining chair designs with classic features, such as twisted legs or carved details, for traditional dining rooms.', quantity: 1,stock: 10),
  Products(title: "Arm Chair", price: 20.00, image: "images/armch.png", review: '****',id: '11', description: 'Armchairs are variations of common chairs, but are designed with fixed armrests and are often upholstered and cushioned.', quantity: 1,stock: 10),
];
List TableProducts=[
  Products(title: "Bed Table", price: 20.00, image: "images/bedt.png", review: '*****', id: '18', description: 'An adjustable table or a tray with legs, designed to extend over or rest upon a bed. night table.', quantity: 1,stock: 10),
  Products(title: "Office Table", price: 38.00, image: "images/offt.png", review: '****',id: '19', description: 'An office table is a specific piece of office furniture designed primarily for working or holding items.', quantity: 1,stock: 10),
  Products(title: "Coffee Table", price: 41.00, image: "images/coft.png", review: '****',id: '20',description: 'A coffee table will usually be low and wide and is generally placed in front of a sofa. It is often used as an informal division.', quantity: 1,stock: 10),
  Products(title: "Tea Table", price: 58.00, image: "images/teat.png", review: '****',id: '21', description: 'A small table  holding a tea service and cups, plates, etc.,  several people.', quantity: 1,stock: 10),
  Products(title: "Home Table", price: 60.00, image: "images/homet.png", review: '****',id: '22', description: 'A table is an item of furniture with a raised flat top and is supported most commonly by 1 to 4 legs.', quantity: 1,stock: 10),
  Products(title: "Work Table", price: 40.00, image: "images/wort.png", review: '****',id: '23', description: 'A table for holding working materials and implements. especially : a small table with drawers and other conveniences for needlework', quantity: 1,stock: 10),
];
List SofaProducts=[
  Products(title: "Chair Sofa", price: 15.00, image: "images/sofap.png", review: '*****', id: '24', description: 'Traditional sofas encompass period details, such as hand turned feet heritage shapes including much loved Chesterfield sofa.', quantity: 1,stock: 10),
  Products(title: "Room Sofa", price:  23.00, image: "images/sofap3.png", review: '****',id: '25', description: 'As its name would suggest, the camelback sofa is characterised by a pronounced hump (or two) on its seat back.', quantity: 1,stock: 10),
  Products(title: "Daybed Sofa", price: 20.00, image: "images/sofap2.png", review: '****',id: '26', description: 'A couch that can be used as a sofa by day and a bed by night. a couch, especially of the 17th or 18th century.', quantity: 1,stock: 10),
  Products(title: "Lawson Sofa", price: 34.00, image: "images/sofap1.png", review: '****',id: '27', description: 'Modern Lawson style sofa that comes as a sectional, chaise end couch or as a 2, 3, 4, 5 or more seater. ', quantity: 1,stock: 10),
  Products(title: "Family Sofa", price: 40.00, image: "images/sofap4.png", review: '****',id: '28', description: 'A long upholstered seat usually with arms and a back and often convertible into a bed.', quantity: 1,stock: 10),
  Products(title: "Modular Sofa", price: 69.00, image: "images/sofap5.png", review: '****',id: '29', description: 'They are designed in separate, easy-to-handle components that effortlessly come together to make your sofa whole.', quantity: 1,stock: 10),
];
List BedProducts=[
  Products(title: "Dream Haven", price: 30.00, image: "images/bed1.png", review: '*****', id: '30', description: 'A bed dream may also indicate that you are putting in a lot of effort to take your rightful place in this world.', quantity: 1,stock: 10),
  Products(title: "Comfort Zone", price: 78.00, image: "images/bed4.png", review: '****',id: '31', description: 'A comfort zone in its purist term is when a mattress contains various tensions, densities, that has a variety of zones within it.', quantity: 1,stock: 10),
  Products(title: "Sleepy Hollow", price: 71.00, image: "images/bed3.png", review: '****',id: '32', description: 'A piece of furniture upon which or within which a person sleeps, rests, or stays when not well.', quantity: 1,stock: 10),
  Products(title: "Serene Sleep", price: 68.00, image: "images/bed2.png", review: '****',id: '33', description: 'A serene sleep bed is calm, peaceful, or tranquil; unruffled: a serene landscape in which you can feel easily.', quantity: 1,stock: 10),
  Products(title: "Slumber Style", price: 97.00, image: "images/bed5.png", review: '****',id: '34', description: 'A slumber bed is beautiful bed, quiescence, or calm: Vesuvius is slumbering.', quantity: 1,stock: 10),
  Products(title: "Cozy Comfort", price: 69.00, image: "images/bed6.png", review: '****',id: '35', description: 'ComfortableAfter a long journey I was looking forward to sleeping in a comfortable bed.', quantity: 1,stock: 10),
];*/
