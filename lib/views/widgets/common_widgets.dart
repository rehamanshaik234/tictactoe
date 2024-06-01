import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/utils/constants/app_colors.dart';
import 'package:playspace/utils/constants/constants.dart';

class Button extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String title;
  final VoidCallback onTap;
  final IconData? iconData;
  const Button({super.key, required this.padding, required this.title, required this.onTap, required this.margin, required this.iconData});
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
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(iconData,color: Colors.white,size: 20.sp,),
              SizedBox(width: 8.w,),
              Text(title,style: GoogleFonts.poppins(fontSize:16.sp,fontWeight:FontWeight.w500,color:Colors.white),),
          ],
        )),
      ),
    );
  }
}

class SelectDare extends StatefulWidget {
  late String name;
   SelectDare({super.key, required this.name});

  @override
  State<SelectDare> createState() => _SelectDareState();
}

class _SelectDareState extends State<SelectDare> {
  bool isLoading=false;
  GlobalKey<FlipCardState> cardKey= GlobalKey<FlipCardState>();
  String selectedDare='';

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(12.sp),topLeft: Radius.circular(12.sp),)
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Game Over',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20.sp),),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
                width: 1.sw,
                child: Divider(color: Colors.grey,height: 2.h,)),
            SizedBox(height: 60.h,),
            FlipCard(
              key: cardKey,
              front:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( "Congratulations!",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 20.sp),),
                SizedBox(
                  height: 8.h,
                ),
                Text(widget.name,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 25.sp),),
                SizedBox(
                  height: 8.h,
                ),
                Text( " Won 🥳",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 20.sp),),
                SizedBox(height: 16.h,),
                Text( "Note: Winner will select a dare for the looser.",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.grey,fontSize: 14.sp),),
              ],
            ),
              back: Text("\"$selectedDare\"",textAlign: TextAlign.center,),
            ),
            SizedBox(height: 60.h,),
            !isLoading? InkWell(
              onTap: selectDare,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 80.w),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:Colors.grey.withOpacity(0.5), // shadow color
                      spreadRadius: 3, // spread radius
                      blurRadius: 5, // blur radius
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: Colors.white,width: 3.w),
                  borderRadius: BorderRadius.circular(8.sp),
                  color: AppColors.secondaryColor,
                ),
                padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Select Dare",style: GoogleFonts.poppins(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
            ):Container(
              margin: EdgeInsets.symmetric(horizontal: 80.w),
              child: const LinearProgressIndicator(color: AppColors.secondaryColor,),
            ),

          ],
        ),
      ),
    );
  }

  selectDare()async{
    isLoading=true;
    selectedDare='';
    dares.shuffle();
    setState(() {

    });
    await Future.delayed(Duration(
      seconds: 1
    ),(){
      selectedDare=dares.first;
      isLoading=false;
      if(cardKey.currentState!.isFront){
        cardKey.currentState?.toggleCard();
      }
      setState(() {

      });
    });
  }
}

