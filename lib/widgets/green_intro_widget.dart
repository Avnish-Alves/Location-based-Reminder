import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget greenIntroWidget(){
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/ht.png'),
        fit: BoxFit.cover
      )
    ),
    height: Get.height*0.6,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

          SvgPicture.asset('assets/jg.svg'),

          const SizedBox(
            height: 20,
          ),
        

        
      ],
    ),
  );
}

Widget greenIntroWidgetWithoutLogos({String title = "Profile Settings",String? subtitle}){
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/ht.png'),
            fit: BoxFit.fill
        )
    ),
    height: Get.height*0.3,
    child: Container(
        height: Get.height*0.1,
        width: Get.width,
        margin: EdgeInsets.only(bottom: Get.height*0.05),
        child: Center(child: Text("Profile Settings", style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white) )


        )),

  );
}