import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/controller/websocket_server/server.dart';
import 'package:playspace/utils/constants/app_colors.dart';
import '../../widgets/custom_dialogs.dart';
import '../../widgets/odd_number_picker.dart';
import '../../../controller/play_together/players.dart';
import '../../../utils/constants/constants.dart';
class PlayTogetherView extends StatefulWidget {
  const PlayTogetherView({super.key});

  @override
  _PlayTogetherViewState createState() => _PlayTogetherViewState();
}

class _PlayTogetherViewState extends State<PlayTogetherView> with SingleTickerProviderStateMixin{
  late PlayTogetherController playTogetherCont= PlayTogetherController();

  @override
  void initState() {
    super.initState();
    playTogetherCont.initializeGame((){setState(() {});});
  }




  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoke,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton( onPressed : exitGame, icon: Icon(Icons.arrow_back_outlined,color: Colors.white,size: 20.sp,)),
          title:Text("Play Together",style: GoogleFonts.poppins(color: Colors.white,),),
          backgroundColor: AppColors.secondaryColor,
          actions: [
            IconButton(onPressed: (){playTogetherCont.showOptionsMenu(context, setState); }, icon: Icon(Icons.settings,color: Colors.white,size: 20.sp,))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical:0.h,horizontal: 8.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.sp),
                        boxShadow: [
                          BoxShadow(
                            color:Colors.grey.withOpacity(0.5), // shadow color
                            spreadRadius: 1, // spread radius
                            blurRadius: 3, // blur radius
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(8.sp),
                      child: Text(playTogetherCont.currentRound==playTogetherCont.totalRounds?"Final Round":"Round - ${playTogetherCont.currentRound.toString().padLeft(2,'0')}",style: TextStyle(color: AppColors.white,fontSize: 25.sp,
                          fontWeight: FontWeight.w600,shadows: [
                            BoxShadow(
                              color:Colors.grey.withOpacity(0.5), // shadow color
                              spreadRadius: 3, // spread radius
                              blurRadius: 5, // blur radius
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ])),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.grey.withOpacity(0.5), // shadow color
                                      spreadRadius: 1, // spread radius
                                      blurRadius: 3, // blur radius
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(8.sp),
                                child: Text(playTogetherCont.player1Score.toString().padLeft(2,'0'),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.white),)),
                            SizedBox(width: playTogetherCont.player1ScoreChange?8.w:0.w,),
                            Visibility(
                              visible: playTogetherCont.player1ScoreChange,
                              child: AnimatedOpacity(
                                  curve: Curves.fastOutSlowIn,
                                  opacity:playTogetherCont.player1ScoreChange? 1.0:0, duration: Duration(seconds: 1),
                                  child: Text("+1",style: GoogleFonts.poppins(fontSize: 35.sp,color: AppColors.secondaryColor,fontWeight: FontWeight.w600),)),
                            )
                          ],
                        ),
                        SizedBox(height: 16.h,),
                        InkWell(
                          onTap: showEditPlayerNames,
                          child: Row(
                            children: [
                              Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: playTogetherCont.player1=='X'?Colors.yellowAccent:Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(playTogetherCont.player1),
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Text(playTogetherCont.player1Name,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                            ],),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.grey.withOpacity(0.5), // shadow color
                                      spreadRadius: 1, // spread radius
                                      blurRadius: 3, // blur radius
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(8.sp),
                                child: Text(playTogetherCont.player2Score.toString().padLeft(2,'0'),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.white),)),
                            SizedBox(width:playTogetherCont.player2ScoreChange? 8.w:0,),
                            Visibility(
                              visible:playTogetherCont.player2ScoreChange,
                              child: AnimatedOpacity(
                                  curve: Curves.bounceIn,
                                  opacity:playTogetherCont.player2ScoreChange? 1.0:0, duration: Duration(seconds: 1),
                                  child: Text("+1",style: GoogleFonts.poppins(fontSize: 35.sp,color: AppColors.secondaryColor,fontWeight: FontWeight.w600),)),
                            )
                          ],
                        ),
                        SizedBox(height: 16.h,),
                        InkWell(
                          onTap: showEditPlayerNames,
                          child: Row(
                            children: [
                              Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: playTogetherCont.player2=='X'?Colors.yellowAccent:Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(playTogetherCont.player2),
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Text(playTogetherCont.player2Name,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                            ],),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.h,),
                Visibility(
                  visible: !playTogetherCont.gameOver,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color:playTogetherCont.currentPlayer==playTogetherCont.player1? Colors.yellowAccent:Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(5.sp),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            playTogetherCont.currentPlayer==playTogetherCont.player1?'X':'O',
                            style: GoogleFonts.poppins(fontSize: 12.sp,fontWeight:FontWeight.w600),
                          ),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          padding: EdgeInsets.all(8.sp),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                // TextSpan(text: currentPlayer==players.player1?players.player1Name:players.player2Name,
                                //     style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.black,)
                                // ),
                                TextSpan(text: "Turn!",
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 20.sp,color:Colors.black,)
                                ),
                              ]
                            ),
                          ),
                      ),
                      Visibility(
                        visible:playTogetherCont.checkGridIsEmpty(),
                        child: InkWell(
                          onTap: (){
                            if(playTogetherCont.currentPlayer==playTogetherCont.player1){
                              playTogetherCont.currentPlayer=playTogetherCont.player2;
                            }else{
                              playTogetherCont.currentPlayer=playTogetherCont.player1;
                            }
                            setState(() {

                            });
                          },
                          child: Icon(Icons.refresh,color: AppColors.secondaryColor,size: 25.sp,),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height:!playTogetherCont.gameOver? 30.h:77.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   FlipCard(
                     flipOnTouch: false,
                     speed: 1000,
                     key: playTogetherCont.cardKey,
                     front: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(20.sp),
                            boxShadow: [
                              BoxShadow(
                                color:Colors.grey .withOpacity(0.5), // shadow color
                                spreadRadius: 5, // spread radius
                                blurRadius:7, // blur radius
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding:EdgeInsets.all(16.sp),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (row) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(3, (col) {
                                      return GestureDetector(
                                        onTap: () =>playTogetherCont.makeMove(row, col,setState,context),
                                        child:  Container(
                                              width: 70.w,
                                              height: 70.h,
                                              margin: EdgeInsets.all(8.sp),
                                              decoration: BoxDecoration(
                                                color:playTogetherCont.grid[row][col]=='' || !playTogetherCont.getVisibility(row, col)?Colors.white60: playTogetherCont.grid[row][col]=='X'? Colors.yellowAccent:Colors.cyanAccent,
                                                borderRadius: BorderRadius.circular(10.sp),
                                                border: Border.all(color: Colors.white),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  playTogetherCont.grid[row][col],
                                                  style:  GoogleFonts.poppins(fontSize: 30.sp,color: playTogetherCont.getVisibility(row, col,)?Colors.black:Colors.transparent ),
                                                ),
                                              ),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              ),
                              Positioned(
                                  top: 35.h+4.h,
                                  left: 3*8.w,
                                    child: AnimatedContainer(color: Colors.black,height: 3.h,width: playTogetherCont.bowDirection==BowDirection.firstRow?  70.w*3:0, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  top: 70.h+35.h+20.h,
                                  left: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height: 3.h,width:playTogetherCont.bowDirection==BowDirection.secondRow? 70.w*3:0, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  bottom: 35.h+4.h,
                                  left: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height: 3.h,width:playTogetherCont.bowDirection==BowDirection.thirdRow?  70.w*3:0, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  top: 70.h+35.h+20.h,
                                  left: 0.w,
                                  child: Transform.rotate(
                                      angle: -45 * (3.141592653589793 / 180),
                                      child: AnimatedContainer(color: Colors.black,height: 3.h,width:playTogetherCont.bowDirection==BowDirection.antiDiagonal?  70.w*3+8.w*6:0, duration: Duration(milliseconds: 500),))),
                              Positioned(
                                  left: 35.h+4.h,
                                  top: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height:playTogetherCont.bowDirection==BowDirection.firstColumn? 70.h*3 :0,width: 3.w, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  right: 70.h+35.h+20.h,
                                  top: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height:playTogetherCont.bowDirection==BowDirection.secondColumn? 70.h*3 :0,width: 3.w, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  right: 35.h+4.h,
                                  top: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height:playTogetherCont.bowDirection==BowDirection.thirdColumn? 70.h*3:0 ,width: 3.w, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  top: 70.h+35.h+20.h,
                                  left: 0.w,
                                  child: Transform.rotate(
                                      angle: 45 * (3.141592653589793 / 180),
                                      child: AnimatedContainer(color: Colors.black,height: 3.h,width:playTogetherCont.bowDirection==BowDirection.diagonal? 70.w*3+8.w*6:0, duration: Duration(milliseconds: 500),))),
                            ],
                          ),
                        ),
                     back: Container(
                       height: 70.h*3+8.sp*6,
                       width: 70.w*3+8.sp*6,
                     decoration: BoxDecoration(
                         color: AppColors.secondaryColor,
                         borderRadius: BorderRadius.circular(20.sp)
                     ),
                     padding:EdgeInsets.all(16.sp),
                     child: Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Text(playTogetherCont.acknowledgement, style: GoogleFonts.poppins(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.w600,),textAlign: TextAlign.center,),
                           SizedBox(height: 8.h,),
                           IconButton(onPressed: (){ playTogetherCont.resetGame(setState);}, icon: Icon(Icons.refresh_rounded,color: Colors.white,size: 40.sp,))
                         ],
                       ),
                     ),
                   ),
                   ),
                  ],
                ),
                SizedBox(height: 30.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        if(playTogetherCont.currentRound!=1 || !playTogetherCont.checkGridIsEmpty()) {
                          showCustomDialog("Change Rounds ?",
                              "If you change rounds now, the current running game will be auto-restart.", () {
                                playTogetherCont.selectRounds(context,setState);
                                playTogetherCont.restartGame(setState);
                              }, "Restart", context);
                        }else{
                          playTogetherCont.selectRounds(context,setState);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 3.w),
                          borderRadius: BorderRadius.circular(20.sp),
                          color: AppColors.secondaryColor,
                        ),
                        padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 12.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Rounds-${playTogetherCont.totalRounds}",style: GoogleFonts.poppins(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                            SizedBox(width: 4.w,),
                            Icon(Icons.edit,color: Colors.white,size: 18.sp,)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        // if(playTogetherCont.currentRound==playTogetherCont.totalRounds && !playTogetherCont.cardKey.currentState!.isFront){
                        //   playTogetherCont.restartGame(setState);
                        // }else{
                        //   playTogetherCont.restartGameWithPopUp(context,setState);
                        // }
                        CustomDialogs.showWinDialog("Game Over", 'Rehaman', (){}, "Select Dare", context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 3.w),
                          borderRadius: BorderRadius.circular(20.sp),
                          color: AppColors.secondaryColor,
                        ),
                        padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 12.w),
                        child: Row(
                          children: [
                            Text("Restart",style: GoogleFonts.poppins(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                            SizedBox(width: 4.w,),
                            Icon(Icons.refresh_rounded,color: Colors.white,size: 20.sp,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }




  void showEditPlayerNames(){
    TextEditingController player1TE=TextEditingController();
    TextEditingController player2TE=TextEditingController();
      showDialog(context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context,setState2) {
                return PopScope(
                  canPop: true,
                  child: AlertDialog(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Player Names", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: Colors.black),),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: 35.w,
                                height: 35.h,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(10.sp),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(
                                    'X',
                                    style: GoogleFonts.poppins(fontSize: 15.sp,fontWeight:FontWeight.w600),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (text){
                                  setState2((){
                                    player1TE.text=text;
                                  });
                                },
                                textCapitalization: TextCapitalization.sentences,
                                controller: player1TE,
                                decoration: InputDecoration(
                                  hintText: 'Player 1',
                                  hintStyle: GoogleFonts.poppins(color:Colors.grey,fontSize:16.sp),
                                ),
                                onEditingComplete: (){
                                  FocusScope.of(context).nextFocus();
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 35.w,
                              height: 35.h,
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.cyanAccent,
                                borderRadius: BorderRadius.circular(10.sp),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text(
                                  'O',
                                  style: GoogleFonts.poppins(fontSize: 15.sp,fontWeight:FontWeight.w600),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: player2TE,
                                textCapitalization: TextCapitalization.sentences,
                                onChanged: (text){
                                  setState2((){
                                    player2TE.text=text;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'Player 2',
                                    hintStyle: GoogleFonts.poppins(color:Colors.grey,fontSize:16.sp)
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      SizedBox(
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 110.w,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(player2TE.text.isNotEmpty && player1TE.text.isNotEmpty){
                                      playTogetherCont.player1Name=player1TE.text;
                                      playTogetherCont.player2Name=player2TE.text;
                                      setState(() {

                                      });
                                    Navigator.of(context).pop();
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll<Color>(player2TE.text.isNotEmpty && player1TE.text.isNotEmpty? AppColors.secondaryColor:AppColors.secondaryColor.withOpacity(0.5)),
                                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                                  child: Text("Save" ,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white,fontSize:16.sp),),
                                ),
                              ),
                              SizedBox(
                                width: 110.w,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
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
            );
          });
  }


  void showCustomDialog(String title, String content, VoidCallback positive,String positiveButtonTitle,BuildContext context){
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


  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Exit Game ?",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 16.sp),),
          content: Text("Are you sure, you want to exit the game?",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.black),),
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
                          Navigator.of(context).pop(true);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(AppColors.secondaryColor),
                            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                        child: Text("Exit" ,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white,fontSize:16.sp),),
                      ),
                    ),
                    SizedBox(
                      width: 120.w,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: ButtonStyle(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                        child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400,fontSize:16.sp),),
                      ),
                    ),
                  ],
                ))
          ],
        )
    );
  }


  void onPopInvoke(bool didPop) async{
      if (didPop) {
        return;
      }
      final bool shouldPop = await _showBackDialog() ?? false;
      if (context.mounted && shouldPop) {
        Navigator.pop(context);
      }
  }

  void exitGame() async {
    bool? exit= await _showBackDialog();
    if(exit !=null && exit){
      Navigator.of(context).pop();
    }
  }

}