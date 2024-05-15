
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Animation duration
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    // Start the animation
    _controller.forward();
    _animation.addListener(() {

    });
  }
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
                  FadeTransition(
                      opacity: _animation,
                      child: Text('TIC',style: GoogleFonts.permanentMarker(color:Colors.white,fontSize:70.sp,fontWeight:FontWeight.w600,letterSpacing: 5.w),)),
                  FadeTransition(
                      opacity: _animation,
                      child: Text('TAC',style: GoogleFonts.permanentMarker(color:Colors.white,fontSize:70.sp,fontWeight:FontWeight.w600),)),
                  FadeTransition(
                      opacity: _animation,
                  child: Text('TOE',style: GoogleFonts.permanentMarker(color:Colors.white,fontSize:70.sp,fontWeight:FontWeight.w600),)),
                  SizedBox(height: 50.h,),
                  FadeTransition(
                    opacity: _animation,
                    child: Button(padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w), title: "Single Player", onTap: (){
                      Navigator.of(context).pushNamed(RoutesName.singlePlayer);
                    }, margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),),
                  ),
                  FadeTransition(
                      opacity: _animation,
                      child: Button(padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w), title: "Online MultiPlayer", onTap: (){}, margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),)),
                  FadeTransition(
                      opacity: _animation,
                      child: Button(padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w), title: "Offline Multiplayer", onTap: (){}, margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
