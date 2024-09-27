import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Screen/home.dart';

class EmptyCartMsgWidget extends StatefulWidget {
  const EmptyCartMsgWidget({super.key});

  @override
  State<EmptyCartMsgWidget> createState() => _EmptyCartMsgWidgetState();
}

class _EmptyCartMsgWidgetState extends State<EmptyCartMsgWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
          height: size.height * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Cart is empty!',style: TextStyle(fontSize: 18, color: Colors.black54),),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                    Navigator.pop(context);
                  },
                  child: const Text('Shop now')),
            ],
          ),
        ));
  }
}
