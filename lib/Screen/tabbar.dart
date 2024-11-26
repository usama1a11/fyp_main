/*import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Tabbar extends StatefulWidget {
  const Tabbar({super.key});
  @override
  State<Tabbar> createState() => _TabbarState();
}
class _TabbarState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 6,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                backgroundColor: Colors.red,
                unselectedBackgroundColor: Colors.grey[300],
                unselectedLabelStyle: TextStyle(color: Colors.black),
                labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    icon: Icon(Icons.search),
                    text: "All",
                  ),
                  Tab(
                    icon: Icon(Icons.directions_transit),
                    text: "Chair",
                  ),
                  Tab(text:"Table",icon: Icon(Icons.directions_bike)),
                  Tab(text:"Sofa",icon: Icon(Icons.directions_car)),
                  Tab(text:"Bed",icon: Icon(Icons.directions_transit)),
                  Tab(text:"",icon: Icon(Icons.directions_bike)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    // All(),
                    Center(
                      child: Icon(Icons.directions_transit),
                    ),
                    Center(
                      child: Icon(Icons.directions_bike),
                    ),
                    Center(
                      child: Icon(Icons.directions_car),
                    ),
                    Center(
                      child: Icon(Icons.directions_transit),
                    ),
                    Center(
                      child: Icon(Icons.directions_bike),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}*/
