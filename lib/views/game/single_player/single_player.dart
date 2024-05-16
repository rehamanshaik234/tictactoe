import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/controller/websocket_server/server.dart';
import 'package:playspace/utils/constants/app_colors.dart';
import 'package:playspace/views/game/single_player/ai_player.dart';
import 'package:playspace/views/widgets/common_widgets.dart';

import '../../../utils/constants/constants.dart';
class Board extends StatefulWidget {
  const Board({super.key});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin{
  late List<List<String>> grid;
  late String currentPlayer;
  bool gameOver=false;
  WebSocketServer webSocketServer=WebSocketServer();
  AudioPlayer audioPlayer=AudioPlayer();
  late AIPlayer aiPlayer;
  String acknowledgement='';
  final cardKey=GlobalKey<FlipCardState>();
  BowDirection bowDirection = BowDirection.none;
  int userScore=0;
  int robotScore=0;
  bool userScoreChange=false;
  bool computerScoreChange=false;
  int difficultyLevel=1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSelectAvatar());
    initializeGame();
  }

  void initializeGame() async {
    audioPlayer.setSource(AssetSource(Constants.tapSound));
    grid = List.generate(3, (_) => List.filled(3, ''));
    aiPlayer=AIPlayer(grid);
    currentPlayer = aiPlayer.user;
    gameOver = false;
    bowDirection = BowDirection.none;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_outlined,color: Colors.white,size: 20.sp,)),
        title:Text("Single Player",style: GoogleFonts.poppins(color: Colors.white,),),
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
              SizedBox(height: 60.h,),
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
                              child: Text(userScore.toString().padLeft(2,'0'),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.white),)),
                          SizedBox(width: userScoreChange?8.w:0.w,),
                          Visibility(
                            visible: userScoreChange,
                            child: AnimatedOpacity(
                                curve: Curves.fastOutSlowIn,
                                opacity:userScoreChange? 1.0:0, duration: Duration(seconds: 1),
                                child: Text("+1",style: GoogleFonts.poppins(fontSize: 35.sp,color: AppColors.secondaryColor,fontWeight: FontWeight.w600),)),
                          )
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: aiPlayer.user=='X'?Colors.yellowAccent:Colors.cyanAccent,
                              borderRadius: BorderRadius.circular(8.sp),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Text(aiPlayer.user),
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          Text("Your Score",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                        ],),
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
                              child: Text(robotScore.toString().padLeft(2,'0'),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.white),)),
                          SizedBox(width:computerScoreChange? 8.w:0,),
                          Visibility(
                            visible: computerScoreChange,
                            child: AnimatedOpacity(
                                curve: Curves.bounceIn,
                                opacity:computerScoreChange? 1.0:0, duration: Duration(seconds: 1),
                                child: Text("+1",style: GoogleFonts.poppins(fontSize: 35.sp,color: AppColors.secondaryColor,fontWeight: FontWeight.w600),)),
                          )
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: aiPlayer.robot=='X'?Colors.yellowAccent:Colors.cyanAccent,
                              borderRadius: BorderRadius.circular(8.sp),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Text(aiPlayer.robot),
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          Text("Computer Score",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                        ],),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20.h,),
              Visibility(
                visible: !gameOver,
                child: Container( 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    padding: EdgeInsets.all(8.sp),
                    child: Text(currentPlayer==aiPlayer.user?"Your Turn!":"Computer Turn!",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp,color:Colors.black,),)),
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
                         IconButton(onPressed: (){ refreshGame();}, icon: Icon(Icons.refresh_rounded,color: Colors.white,size: 40.sp,))
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
                    onTap: selectDifficultyLevel,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 3.w),
                        borderRadius: BorderRadius.circular(20.sp),
                        color: AppColors.secondaryColor,
                      ),
                      padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 12.w),
                      child: Row(
                        children: [
                          Text(difficultyLevel==1?"Easy":difficultyLevel==2?"Medium":"Hard",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.w600),),
                          SizedBox(width: 4.w,),
                          Icon(Icons.edit,color: Colors.white,size: 20.sp,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: resetGame,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 3.w),
                        borderRadius: BorderRadius.circular(20.sp),
                        color: AppColors.secondaryColor,
                      ),
                      padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 12.w),
                      child: Row(
                        children: [
                          Text("Reset",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.w600),),
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
    );
  }

  Point<int> getBestMove(List<List<String>> grid, int depth) {
    int bestEval = -1000;
    Point<int> bestMove=const Point(0, 0);
    for (var move in aiPlayer.availableMoves()) {
      aiPlayer.makeMove(move.x, move.y, aiPlayer.robot);
      int eval =aiPlayer.minimax(aiPlayer, depth - 1, false, -1000, 1000);
      aiPlayer.makeMove(move.x, move.y, ''); // Undo move
      if (eval > bestEval) {
        bestEval = eval;
        bestMove = move;
      }
    }

    return bestMove;
  }

  void makeMove(int row, int col)async{
    if (!gameOver && grid[row][col] == ''&& currentPlayer==aiPlayer.user){
      grid[row][col] = currentPlayer;
      await audioPlayer.play(AssetSource(Constants.tapSound)).whenComplete(() async {
        if (await checkWinner(row, col)) {
          await _startAnimation(row,col);
          // showCustomDialog("Game Over", "Player $currentPlayer wins!");
        } else if (grid.every((row) => row.every((cell) => cell != ''))) {
          await _startAnimation(row, col);
          // showCustomDialog("Game Over", "It's a draw!");
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          setState(() {

          });
          await Future.delayed(Duration(seconds: 1),(){
            updateAIMove();
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

  void updateAIMove()async{
    Point<int> index= getBestMove(grid, difficultyLevel);
    grid[index.x][index.y]=currentPlayer;
    await audioPlayer.play(AssetSource(Constants.tapSound));
    if (await checkWinner(index.x, index.y)) {
      await _startAnimation(index.x,index.y);
    } else if (grid.every((row) => row.every((cell) => cell != ''))) {
      await _startAnimation(index.x,index.y);
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      setState(() {

      });
    }
  }

  void showSelectAvatar(){
      showDialog(context: context,
          builder: (context) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Choose your Avatar", style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.black),),
                    Text("please select any one of the below",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.grey),),
                  ],
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        aiPlayer.user = 'X';
                        aiPlayer.robot = 'O';
                        currentPlayer = aiPlayer.user;
                        aiPlayer.setUser('X');
                        aiPlayer.setRobot('O');
                        Navigator.of(context).pop();
                        setState(() {

                        });
                      },
                      child: Container(
                        width: 70.w,
                        height: 70.h,
                        margin: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(10.sp),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            'X',
                            style: GoogleFonts.poppins(fontSize: 30.sp,fontWeight:FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        aiPlayer.user = 'O';
                        aiPlayer.robot = 'X';
                        aiPlayer.setUser('O');
                        aiPlayer.setRobot('X');
                        currentPlayer = aiPlayer.user;
                        Navigator.of(context).pop();
                        setState(() {

                        });
                      },
                      child: Container(
                        width: 70.w,
                        height: 70.h,
                        margin: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(10.sp),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            'O',
                            style: GoogleFonts.poppins(fontSize: 30.sp,fontWeight:FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }


  void showCustomDialog(String title, String content, VoidCallback positive ){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 16.sp),),
        content: Text(content,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,color: Colors.black),),
        actions: [
           Expanded(
               child:
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
               ElevatedButton(
                 onPressed: () {
                   Navigator.of(context).pop();
                   positive();
                 },
                 style: ButtonStyle(
                     backgroundColor: MaterialStatePropertyAll<Color>(AppColors.secondaryColor),
                     shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                 child: Text('Confirm',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white),),
               ),
               OutlinedButton(
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
                 style: ButtonStyle(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                 child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.black),),
               ),
             ],
           ))
        ],
      ),
    );
  }

  Future<void> _startAnimation(int row, int col) async {
    String soundPath='';

    if(grid.every((row) => row.every((cell) => cell != '')) && ! await checkWinner(row, col)){
      acknowledgement='Oops! 🥴 \nIts a Draw';
      soundPath=Constants.gameDraw;
    }
    else if(currentPlayer==aiPlayer.user){
      acknowledgement='Congratulations!\nYou Won 🥳';
      userScore=userScore+1;
      soundPath=Constants.gameWon;
      userScoreChange=true;
    }else{
      acknowledgement='Sorry!\nYou Lost ☠️';
      robotScore=robotScore+1;
      computerScoreChange=true;
      soundPath=Constants.gameLost;
    }
    gameOver=true;
    await cardKey.currentState?.toggleCard();
    await audioPlayer.play(AssetSource(soundPath));
    setState(() {

    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      userScoreChange=false;
      computerScoreChange=false;
    });
  }

  void toggleCard() {
    cardKey.currentState?.toggleCard();
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

  Color getTextColor() {
    if(currentPlayer=='X'){
      return Colors.yellowAccent;
    }else if(currentPlayer=='O'){
      return Colors.cyanAccent;
    }else{
     return Colors.white60;
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
              child: Row(
                children: [
                  Icon(Icons.face,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Change Avatar",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              ),onTap: (){
                   if(checkGridIsEmpty()){
                      showSelectAvatar();
                    }else{
                      showCustomDialog("Confirm to Change Avatar", "Your at the middle of game, if you change now game will auto reset.", () {
                        refreshGame();
                        showSelectAvatar();
                      });
                    }
                },),
          PopupMenuItem(
            onTap: (){
              selectDifficultyLevel();
            },
              child: Row(
                children: [
                  Icon(Icons.auto_graph,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Difficulty Level",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              )),
          PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Restart Game",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              ))
        ]);
  }

  void refreshGame(){
    initializeGame();
    if(!cardKey.currentState!.isFront){
      cardKey.currentState?.toggleCard();
    }
  }
  
  void resetGame(){
    showCustomDialog("Confirm to Restart", "please do confirm to restart game",(){
      initializeGame();
      if(!cardKey.currentState!.isFront){
        cardKey.currentState?.toggleCard();
      }
      setState(() {
        userScore=0;
        robotScore=0;
      });
    });
  }

  void selectDifficultyLevel(){
    int level=difficultyLevel;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context,setState2) {
          return AlertDialog(
            title: Text('Difficulty Level',style: GoogleFonts.poppins(color: AppColors.secondaryColor,fontWeight: FontWeight.w600,fontSize: 20.sp),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               RadioListTile(
                   activeColor: AppColors.secondaryColor,
                   title: Text("Easy",style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w500),),
                   value: 1, groupValue: level, onChanged: (val){
                   setState2(() {
                     level=val!;
                   });
               }),
                RadioListTile(
                    activeColor: AppColors.secondaryColor,
                    title: Text("Medium",style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w500),),
                    value: 2, groupValue: level, onChanged: (val){
                  setState2(() {
                    level=val!;
                  });
                }),
                RadioListTile(
                    activeColor: AppColors.secondaryColor,
                    title: Text("Hard",style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w500),),
                    value: 3, groupValue: level, onChanged: (val){
                  setState2(() {
                    level=val!;
                  });
                })
              ],
            ),
            actions: [
              Expanded(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            difficultyLevel=level;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(AppColors.secondaryColor),
                            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                        child: Text(' Save ',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                        child: Text('Cancel',style: GoogleFonts.poppins(color: Colors.black),),
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

}