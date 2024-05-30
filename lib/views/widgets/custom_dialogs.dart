import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/views/widgets/common_widgets.dart';
import '../../utils/constants/app_colors.dart';

class CustomDialogs{
  static void showCustomDialog(String title, String content, VoidCallback positive,String positiveButtonTitle,BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 16.sp),),
        content: Text(content,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.black),),
        actions: [
          SizedBox(
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 120.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        WidgetsBinding.instance.addPostFrameCallback((_) => positive());
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(AppColors.secondaryColor),
                          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                      child: Text(positiveButtonTitle ,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white,fontSize:16.sp),),
                    ),
                  ),
                  SizedBox(
                    width: 120.w,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                      child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400,fontSize:16.sp),),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  static void showWinDialog(String title, String playerName, VoidCallback positive,String positiveButtonTitle,BuildContext context){
    showModalBottomSheet(context: context, builder: (context){
      return SelectDare(name: playerName);
    });
  }
}