import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
class AppThemes{
  late BuildContext context;
  late bool isConnected;
  late ThemeData lightTheme;
  late ThemeData darkTheme;
  AppThemes({required this.context, required this.isConnected}){

    lightTheme= ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: isConnected? AppColors.connectedColor: AppColors.disconnectedColor),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
        ),
        dividerColor: Colors.black,
        dialogBackgroundColor: Colors.white,
        primaryColor: AppColors.secondaryColor,
        focusColor: AppColors.secondaryColor,
        textTheme: TextTheme(
            displayLarge: GoogleFonts.montserrat(color: Colors.black,fontWeight:FontWeight.w500,fontSize:60.sp),
            displayMedium: GoogleFonts.montserrat(color: Colors.black,fontWeight:FontWeight.w500,fontSize:30.sp),
            bodyMedium: GoogleFonts.poppins(color: Colors.black,fontSize: 16.sp,fontWeight:FontWeight.w400),
            headlineMedium: GoogleFonts.poppins(color:Colors.black,fontSize:16.sp,fontWeight:FontWeight.w500),
            headlineSmall: GoogleFonts.poppins(color:Colors.black,fontSize:14.sp,fontWeight:FontWeight.w400),
            headlineLarge: GoogleFonts.montserrat(color: Colors.white,fontWeight:FontWeight.w600,fontSize:20.sp),
            titleLarge: GoogleFonts.montserrat(color: Colors.black,fontWeight:FontWeight.w600,fontSize:20.sp)),
        useMaterial3: true,
        cardTheme: CardTheme(color: Colors.grey.shade400),
        scaffoldBackgroundColor: Colors.white
    );

    darkTheme= ThemeData(
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(AppColors.primaryLightColor),

        )
      ),
      appBarTheme: AppBarTheme(backgroundColor:isConnected? AppColors.connectedColor:AppColors.disconnectedColor,),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.primaryLightColor,
      ),
      dividerColor: Colors.grey,
      primaryColor: AppColors.secondaryColor,
      focusColor: AppColors.secondaryColor,
      dialogBackgroundColor: AppColors.primaryLightColor,
      textTheme: TextTheme(
          displayMedium: GoogleFonts.montserrat(color: Colors.white,fontWeight:FontWeight.w500,fontSize:30.sp),
          displayLarge: GoogleFonts.montserrat(color: Colors.white,fontWeight:FontWeight.w500,fontSize:60.sp),
          headlineSmall: GoogleFonts.poppins(color:Colors.white,fontSize:16.sp,fontWeight:FontWeight.w400),
          headlineLarge: GoogleFonts.montserrat(color:Colors.white,fontWeight:FontWeight.w600,fontSize:20.sp),
          bodyMedium: GoogleFonts.poppins(color: Colors.white,fontSize: 12.sp,fontWeight:FontWeight.w400),
          headlineMedium: GoogleFonts.poppins(color:Colors.white,fontSize:16.sp,fontWeight:FontWeight.w500,),
          titleLarge: GoogleFonts.montserrat(color: Colors.white,fontWeight:FontWeight.w600,fontSize:20.sp)
      ),
      cardTheme: CardTheme(color:Colors.grey.shade900),
      scaffoldBackgroundColor: AppColors.primaryLightColor,
      useMaterial3: true,
    );
  }

}