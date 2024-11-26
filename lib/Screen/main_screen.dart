/*import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Buyer/welcome/page_one.dart';
import 'package:furnitureworldapplication/Buyer/welcome/page_three.dart';
import 'package:furnitureworldapplication/Buyer/welcome/page_two.dart';
import 'package:furnitureworldapplication/screen/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  final PageController pageController=PageController(initialPage: 0);
  int activepage=0;
  final List<Widget> pages= [
     const PageOne(),
     const PageTwo(),
     const PageThree(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageOne(),
          PageView.builder(
              controller: pageController,
              onPageChanged: (int page){
                setState(() {
                  activepage=page;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context,int index){
                return pages[index % pages.length];
              }),
          Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              height: 300,
              child:Center(
                child: SmoothPageIndicator(
                    controller: pageController,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: ElevatedButtonColor,
                      dotColor: Colors.orangeAccent,
                      dotHeight: 12,
                      dotWidth: 12,
                      spacing: 10,
                    ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}*/
