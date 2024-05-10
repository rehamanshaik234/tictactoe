
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/utils/constants/app_colors.dart';
import 'package:playspace/utils/routes/RouteNames.dart';
import 'package:playspace/views/widgets/common_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.secondaryColor,
                Colors.white60,
          ]),
        ),
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(20.sp),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('TIC',style: GoogleFonts.permanentMarker(color:Colors.white,fontSize:70.sp,fontWeight:FontWeight.w600,letterSpacing: 5.w),),
                  Text('TAC',style: GoogleFonts.permanentMarker(color:Colors.white,fontSize:70.sp,fontWeight:FontWeight.w600),),
                  Text('TOE',style: GoogleFonts.permanentMarker(color:Colors.white,fontSize:70.sp,fontWeight:FontWeight.w600),),
                  SizedBox(height: 50.h,),
                  Button(padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w), title: "Single Player", onTap: (){
                    Navigator.of(context).pushNamed(RoutesName.singlePlayer);
                  }, margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),),
                  Button(padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w), title: "Online MultiPlayer", onTap: (){}, margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),),
                  Button(padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w), title: "Offline Multiplayer", onTap: (){}, margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
