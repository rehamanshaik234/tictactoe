import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/utils/constants/app_colors.dart';

class Button extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String title;
  final VoidCallback onTap;
  const Button({super.key, required this.padding, required this.title, required this.onTap, required this.margin});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white,width: 3.w),
          borderRadius: BorderRadius.circular(20.sp),
          color: AppColors.secondaryColor,
        ),
        padding: padding,
        margin: margin,
        width: 1.sw,
        child: Center(child: Text(title,style: GoogleFonts.poppins(fontSize:16.sp,fontWeight:FontWeight.w500,color:Colors.white),)),
      ),
    );
  }
}
