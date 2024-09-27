import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}
class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Initialize TabController in the first frame after the widget tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 5, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Current Order", style: TextStyle(color: Colors.white60)),
          backgroundColor: Colors.transparent,
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabController != null
                  ? TabBar(
                isScrollable: true,  // Enable horizontal scrolling
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              )
                  : SizedBox.shrink(),
            ),
          ),
        ),
        body: _tabController != null
            ? TabBarView(
          controller: _tabController,
          children: [
            Center(child: Text("Pending", style: TextStyle(fontSize: 24))),
            Center(child: Text("On The Way", style: TextStyle(fontSize: 24))),
            Center(child: Text("Completed", style: TextStyle(fontSize: 24))),
            Center(child: Text("Canceled", style: TextStyle(fontSize: 24))),
            Center(child: Text("All Order", style: TextStyle(fontSize: 24))),
          ],
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/*class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Ensures the TabController is available during the widget's first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: 5, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Current Order",style: TextStyle(color:Colors.white60),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900,],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabController != null
                  ? TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900,Colors.brown,],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "Pending"),
                  Tab(text: "On The Way"),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                  Tab(text: "All Order"),
                ],
              )
                  : SizedBox.shrink(), // Show empty space until controller is available
            ),
          ),
        ),
        body: _tabController != null
            ? TabBarView(
          controller: _tabController,
          children: [
            Center(child: Text("Pending", style: TextStyle(fontSize: 24))),
            Center(child: Text("On The Way", style: TextStyle(fontSize: 24))),
            Center(child: Text("Completed", style: TextStyle(fontSize: 24))),
            Center(child: Text("Canceled", style: TextStyle(fontSize: 24))),
            Center(child: Text("All Order", style: TextStyle(fontSize: 24))),
          ],
        )
            : Center(child: CircularProgressIndicator()), // Show loading until controller is ready
      ),
    );
  }
}*/

