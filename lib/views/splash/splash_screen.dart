import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/utils/routes/RouteNames.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

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
      if(_animation.isCompleted){
        navigateToHomeScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: FadeTransition(
            opacity: _animation,
            child: Hero(
              tag: 'title',
              child: Text('Tic Tac Toe',style: GoogleFonts.adamina(fontSize:30.sp,color:Colors.white),
                      ),
            ),
      ),
      )
    );
  }

  void navigateToHomeScreen()async{
    await Future.delayed(const Duration(seconds: 1),(){
      Navigator.of(context).pushReplacementNamed(RoutesName.homeScreen);
    });
  }
}
