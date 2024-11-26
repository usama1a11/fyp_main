/*import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Buyer/register.dart';
// import 'package:furnitureworldapplication/Admin/login.dart';
// import 'package:furnitureworldapplication/Admin/welcome.dart';
import 'package:furnitureworldapplication/Buyer/welcome.dart';
import 'package:furnitureworldapplication/screen/constants.dart';
import 'package:google_fonts/google_fonts.dart';
class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: defaultPadding*5,bottom: defaultPadding*5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: defaultPadding*2),
                  child: Text("Interior Design\nfor your style",
                    style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Expanded(
                    child: Image.asset("images/sofa.png")
                ),
                SizedBox(
                  height: defaultPadding*3,
                ),
                Center(
                  child: SizedBox(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:ElevatedButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                        )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Get Started",
                          style: GoogleFonts.ubuntu(
                            color: Colors.green.withOpacity(0.7),
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}*/
