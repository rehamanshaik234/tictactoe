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
import 'package:playspace/utils/routes/RouteNames.dart';
import 'package:playspace/views/game/play_with_friend/player/odd_number_picker.dart';
import 'package:playspace/views/game/play_with_friend/player/players.dart';
import 'package:playspace/views/game/single_player/ai_player.dart';

import '../../../utils/constants/constants.dart';
class PlayWithFriend extends StatefulWidget {
  const PlayWithFriend({super.key});

  @override
  _PlayWithFriendState createState() => _PlayWithFriendState();
}

class _PlayWithFriendState extends State<PlayWithFriend> with SingleTickerProviderStateMixin{
  late List<List<String>> grid;
  late String currentPlayer;
  bool gameOver=false;
  WebSocketServer webSocketServer=WebSocketServer();
  AudioPlayer audioPlayer=AudioPlayer();
  late Players players= Players();
  String acknowledgement='';
  final cardKey=GlobalKey<FlipCardState>();
  BowDirection bowDirection = BowDirection.none;
  int player1Score=0;
  int player2Score=0;
  bool player1ScoreChange=false;
  bool player2ScoreChange=false;
  int totalRounds=5;
  int currentRound=1;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => showSelectAvatar());
    initializeGame();
  }

  void initializeGame() async {
    audioPlayer.setSource(AssetSource(Constants.tapSound));
    grid = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = players.player1;
    gameOver = false;
    bowDirection = BowDirection.none;
    setState(() {

    });
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
          title:Text("Play With Friend",style: GoogleFonts.poppins(color: Colors.white,),),
          backgroundColor: AppColors.secondaryColor,
          actions: [
            IconButton(onPressed: showOptionsMenu, icon: Icon(Icons.settings,color: Colors.white,size: 20.sp,))
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
                      child: Text(currentRound==totalRounds?"Final Round":"Round - ${currentRound.toString().padLeft(2,'0')}",style: TextStyle(color: AppColors.white,fontSize: 25.sp,
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
                                child: Text(player1Score.toString().padLeft(2,'0'),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.white),)),
                            SizedBox(width: player1ScoreChange?8.w:0.w,),
                            Visibility(
                              visible: player1ScoreChange,
                              child: AnimatedOpacity(
                                  curve: Curves.fastOutSlowIn,
                                  opacity:player1ScoreChange? 1.0:0, duration: Duration(seconds: 1),
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
                                  color: players.player1=='X'?Colors.yellowAccent:Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(players.player1),
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Text(players.player1Name,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),),
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
                                child: Text(player2Score.toString().padLeft(2,'0'),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.white),)),
                            SizedBox(width:player2ScoreChange? 8.w:0,),
                            Visibility(
                              visible: player2ScoreChange,
                              child: AnimatedOpacity(
                                  curve: Curves.bounceIn,
                                  opacity:player2ScoreChange? 1.0:0, duration: Duration(seconds: 1),
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
                                  color: players.player2=='X'?Colors.yellowAccent:Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(players.player2),
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Text(players.player2Name,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                            ],),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.h,),
                Visibility(
                  visible: !gameOver,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color:currentPlayer==players.player1? Colors.yellowAccent:Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(5.sp),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            currentPlayer==players.player1?'X':'O',
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
                        visible: checkGridIsEmpty(),
                        child: InkWell(
                          onTap: (){
                            if(currentPlayer==players.player1){
                              currentPlayer=players.player2;
                            }else{
                              currentPlayer=players.player1;
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
                SizedBox(height:!gameOver? 30.h:77.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   FlipCard(
                     flipOnTouch: false,
                     speed: 1000,
                     key: cardKey,
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
                                        onTap: () => makeMove(row, col),
                                        child:  Container(
                                              width: 70.w,
                                              height: 70.h,
                                              margin: EdgeInsets.all(8.sp),
                                              decoration: BoxDecoration(
                                                color:grid[row][col]=='' || !getVisibility(row, col)?Colors.white60: grid[row][col]=='X'? Colors.yellowAccent:Colors.cyanAccent,
                                                borderRadius: BorderRadius.circular(10.sp),
                                                border: Border.all(color: Colors.white),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  grid[row][col],
                                                  style:  GoogleFonts.poppins(fontSize: 30.sp,color: getVisibility(row, col)?Colors.black:Colors.transparent ),
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
                                    child: AnimatedContainer(color: Colors.black,height: 3.h,width:bowDirection==BowDirection.firstRow?  70.w*3:0, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  top: 70.h+35.h+20.h,
                                  left: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height: 3.h,width:bowDirection==BowDirection.secondRow? 70.w*3:0, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  bottom: 35.h+4.h,
                                  left: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height: 3.h,width:bowDirection==BowDirection.thirdRow?  70.w*3:0, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  top: 70.h+35.h+20.h,
                                  left: 0.w,
                                  child: Transform.rotate(
                                      angle: -45 * (3.141592653589793 / 180),
                                      child: AnimatedContainer(color: Colors.black,height: 3.h,width:bowDirection==BowDirection.antiDiagonal?  70.w*3+8.w*6:0, duration: Duration(milliseconds: 500),))),
                              Positioned(
                                  left: 35.h+4.h,
                                  top: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height:bowDirection==BowDirection.firstColumn? 70.h*3 :0,width: 3.w, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  right: 70.h+35.h+20.h,
                                  top: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height:bowDirection==BowDirection.secondColumn? 70.h*3 :0,width: 3.w, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  right: 35.h+4.h,
                                  top: 3*8.w,
                                  child: AnimatedContainer(color: Colors.black,height:bowDirection==BowDirection.thirdColumn? 70.h*3:0 ,width: 3.w, duration: Duration(milliseconds: 500),)),
                              Positioned(
                                  top: 70.h+35.h+20.h,
                                  left: 0.w,
                                  child: Transform.rotate(
                                      angle: 45 * (3.141592653589793 / 180),
                                      child: AnimatedContainer(color: Colors.black,height: 3.h,width:bowDirection==BowDirection.diagonal? 70.w*3+8.w*6:0, duration: Duration(milliseconds: 500),))),
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
                           Text(acknowledgement, style: GoogleFonts.poppins(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.w600,),textAlign: TextAlign.center,),
                           SizedBox(height: 8.h,),
                           IconButton(onPressed: (){ resetGame();}, icon: Icon(Icons.refresh_rounded,color: Colors.white,size: 40.sp,))
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
                      onTap: selectRounds,
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
                            Text("Rounds-$totalRounds",style: GoogleFonts.poppins(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                            SizedBox(width: 4.w,),
                            Icon(Icons.edit,color: Colors.white,size: 18.sp,)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: restartGame,
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


  void makeMove(int row, int col)async{
    if (!gameOver && grid[row][col] == ''){
      grid[row][col] = currentPlayer;
      await audioPlayer.play(AssetSource(Constants.tapSound)).whenComplete(() async {
        if (await checkWinner(row, col)) {
          await _startAnimation(row,col);
        } else if (grid.every((row) => row.every((cell) => cell != ''))) {
          await _startAnimation(row, col);
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          setState(() {

          });
        }
        setState(() {});
      });
    }
  }

  Future<bool> checkWinner(int row, int col)async{

    // Check row
    if (grid[row].every((cell) => cell == currentPlayer)){
      if(row==0){
        bowDirection=BowDirection.firstRow;
      }else if(row==1){
        bowDirection=BowDirection.secondRow;
      }else if(row==2){
        bowDirection=BowDirection.thirdRow;
      }else{
        bowDirection=BowDirection.none;
      }
      setState(() {

      });
      await Future.delayed(const Duration(milliseconds: 1000));
      return true;
    }


    // Check column
    if (grid.every((row) => row[col] == currentPlayer)){
      if(col==0){
        bowDirection=BowDirection.firstColumn;
      }else if(col==1){
        bowDirection=BowDirection.secondColumn;
      }else if(col==2){
        bowDirection=BowDirection.thirdColumn;
      }else{
        bowDirection=BowDirection.none;
      }
      setState(() {

      });
      await Future.delayed(const Duration(milliseconds: 1000));
      return true;
    }
    // Check diagonal
    if (row == col && checkDiagonal(grid)){
      bowDirection=BowDirection.diagonal;
      setState(() {

      });
      await Future.delayed(const Duration(milliseconds: 1000));
      return true;
    }

    // Check anti-diagonal
    if (row + col == 2 && checkAntiDiagonal(grid)){
      bowDirection=BowDirection.antiDiagonal;
      setState(() {

      });
      await Future.delayed(const Duration(milliseconds: 1000));
      return true;
    }

    bowDirection=BowDirection.none;
    return false;

  }

  bool checkDiagonal(List<List<String>> grid) {
    int counter=0;
    for(int row=0;row<grid.length;row++){
      for(int col=0;col<grid[row].length;col++){
        if(row==col && grid[row][col]==currentPlayer && grid[row].contains(currentPlayer)){
          counter++;
        }
      }
    }
    return counter==3;
  }

  bool checkAntiDiagonal(List<List<String>> grid) {
    int counter=0;
    for(int row=0;row<grid.length;row++){
      for(int col=0;col<grid[row].length;col++){
        if(row + col == 2 && grid[row][col]==currentPlayer && grid[row].contains(currentPlayer)){
          counter++;
        }
      }
    }
    return counter==3;
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
                                      players.player1Name=player1TE.text;
                                      players.player2Name=player2TE.text;
                                      setState(() {

                                      });
                                    Navigator.of(context).pop();
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll<Color>(player2TE.text.isNotEmpty && player1TE.text.isNotEmpty? AppColors.secondaryColor:AppColors.secondaryColor.withOpacity(0.5)),
                                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
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

  Future<void> _startAnimation(int row, int col) async {
      String soundPath = '';
      if (grid.every((row) => row.every((cell) => cell != '')) &&
          !await checkWinner(row, col)) {
        acknowledgement = 'Oops! 🥴 \nIts a Draw';
        soundPath = Constants.gameDraw;
      }
      else if (currentPlayer == players.player1) {
        acknowledgement = 'Congratulations!\n${players.player1Name} Won 🥳';
        player1Score = player1Score + 1;
        soundPath = Constants.gameWon;
        player1ScoreChange = true;
      } else {
        acknowledgement = 'Congratulations!\n${players.player2Name} Won 🥳';
        player2Score = player2Score + 1;
        player2ScoreChange = true;
        soundPath = Constants.gameWon;
      }
      gameOver = true;
      showGameOverDialog(soundPath);
      setState(() {
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        player1ScoreChange = false;
        player2ScoreChange = false;
      });
  }

  bool getVisibility(int row, int col) {

    if(row==0 && col==0){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.firstColumn || bowDirection==BowDirection.firstRow || bowDirection==BowDirection.diagonal){return true;}else {return false;}
    }else if(row==0 && col==1){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.secondColumn || bowDirection==BowDirection.firstRow){return true;}else {return false;}
    }else if(row==0 && col==2){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.thirdColumn || bowDirection==BowDirection.firstRow || bowDirection==BowDirection.antiDiagonal){return true;}else {return false;}
    }else if(row==1 && col==0){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.firstColumn || bowDirection==BowDirection.secondRow){return true;}else {return false;}
    }else if(row==1 && col==1){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.secondColumn || bowDirection==BowDirection.secondRow || bowDirection==BowDirection.diagonal || bowDirection==BowDirection.antiDiagonal){return true;}else {return false;}
    }else if(row==1 && col==2){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.thirdColumn || bowDirection==BowDirection.secondRow){return true;}else {return false;}
    }else if(row==2 && col==0){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.firstColumn || bowDirection==BowDirection.thirdRow || bowDirection==BowDirection.antiDiagonal){return true;}else {return false;}
    }else if(row==2 && col==1){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.secondColumn || bowDirection==BowDirection.thirdRow){return true;}else {return false;}
    }else if(row==2 && col==2){
      if(bowDirection==BowDirection.none|| bowDirection==BowDirection.thirdRow || bowDirection==BowDirection.thirdColumn || bowDirection==BowDirection.diagonal){return true;}else {return false;}
    }else{
      return true;
    }

  }
  
  void showOptionsMenu(){
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          MediaQuery.of(context).size.width - 100,
          20.0,
          0.0,
          0.0,),
        items: [
          PopupMenuItem(
              onTap: changeAvatar,
              child: Row(
                children: [
                  Icon(Icons.edit,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Player Names",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              ),),
          PopupMenuItem(
            onTap: (){
              selectRounds();
            },
              child: Row(
                children: [
                  Icon(Icons.auto_graph,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Difficulty Level",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              )),
          PopupMenuItem(
            onTap: restartGame,
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Restart Game",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              ))
        ]);
  }

  void resetGame(){
    grid = List.generate(3, (_) => List.filled(3, ''));
    gameOver = false;
    bowDirection = BowDirection.none;
      if(currentRound<totalRounds) {
        currentRound = currentRound + 1;
      }else if(currentRound==totalRounds){
        currentRound=1;
        totalRounds=5;
        player1Score=0;
        player2Score=0;
      }
    if(!cardKey.currentState!.isFront){
      cardKey.currentState?.toggleCard();
    }
    setState(() {

    });
  }
  
  void restartGame(){
    showCustomDialog("Restart Game?", "Are you sure you want to restart the game? This will reset your score.",(){
      initializeGame();
      if(!cardKey.currentState!.isFront){
        cardKey.currentState?.toggleCard();
      }
      setState(() {
        player1Score=0;
        player2Score=0;
      });
    },'Confirm',context);
  }

  void selectRounds(){
    int rounds=totalRounds;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context,setState2) {
          return AlertDialog(
            title: Text('Select Rounds',style: GoogleFonts.poppins(color: AppColors.secondaryColor,fontWeight: FontWeight.w600,fontSize: 20.sp),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OddNumberPicker(
                  value: rounds,
                  minValue: getMinRounds(),
                  zeroPad: true,
                  textStyle: TextStyle(color: Colors.black),
                  maxValue: 9,
                  isOdd:true,
                  onChanged: (value) => setState2(() => rounds = value),
                ),
              ],
            ),
            actions: [
              SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 110.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              totalRounds=rounds;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(AppColors.secondaryColor),
                              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                          child: Text('Save',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                      ),
                      SizedBox(
                        width: 110.w,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                          child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.black),),
                        ),
                      ),
                    ],
                  ))
            ],
          );
        }
      ),
    );
  }

  bool checkGridIsEmpty() {
    bool isEmpty=true;
    for(int i=0;i<grid.length;i++){
      for(int j=0;j<grid[i].length;j++){
        if(grid[i][j]=="O" || grid[i][j]=="X"){
          isEmpty=false;
          break;
        }
      }
    }
    return isEmpty;
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

 void changeAvatar() {
    if(checkGridIsEmpty()){
      showEditPlayerNames();
    }else{
      showCustomDialog("Change Avatar?", "Your at the middle of game, if you change avatar now the game will auto reset.", () {
        resetGame();
        showEditPlayerNames();
      },'Confirm',context);
    }
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

 int getMinRounds() {
    if(currentRound==1){
      return currentRound;
    }else if(currentRound==totalRounds){
      return currentRound;
    }else if(currentRound==2){
      return 3;
    }else if(currentRound==3){
      return 3;
    }else if(currentRound==4){
      return 5;
    }else if(currentRound==5){
      return 5;
    }else if(currentRound==6){
      return 7;
    }else if(currentRound==7){
      return 7;
    }else if(currentRound==8){
      return 9;
    }else if(currentRound==9){
      return 9;
    }else{
      return 1;
    }
 }

  void showGameOverDialog(String soundPath)async {
    double halfRounds=totalRounds/2;
    if(halfRounds.ceil()==player1Score ) {
      print("player1 winner");
    } else if(halfRounds.ceil()== player2Score){
      print("player2 winner");
    }else if(currentRound==totalRounds){
      print('draw');
    } else{
      //rounderWin
      if(currentPlayer==players.player1){
        currentPlayer=players.player2;
      }else{
        currentPlayer=players.player1;
      }
      await audioPlayer.play(AssetSource(soundPath));
      resetGame();
    }
  }
}