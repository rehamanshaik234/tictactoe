import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/controller/websocket_server/server.dart';
import 'package:playspace/utils/constants/app_colors.dart';
import 'package:playspace/views/game/ai_player.dart';

import '../../utils/constants/constants.dart';
class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin{
  late List<List<String>> grid;
  late String currentPlayer;
  late bool gameOver;
  WebSocketServer webSocketServer=WebSocketServer();
  AudioPlayer audioPlayer=AudioPlayer();
  late AIPlayer aiPlayer;
  late AnimationController _controller;
  late Animation<double> _animation;
  String acknowledgement='';


  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.addStatusListener((status) {
      resetAnimation();
    });
    super.initState();
    initializeGame();
  }

  void initializeGame() async {
    audioPlayer.setSource(AssetSource(Constants.tapSound));
    grid = List.generate(3, (_) => List.filled(3, ''));
    aiPlayer=AIPlayer(grid);
    currentPlayer = aiPlayer.user;
    gameOver = false;
    setState(() {

    });
    WidgetsBinding.instance.addPostFrameCallback((_) => showSelectItem());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Hero(
        tag: 'title',
          child: Text("Single Player",style: GoogleFonts.adamina(color: Colors.white,),)),backgroundColor: AppColors.secondaryColor,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentPlayer==aiPlayer.user?"Its Your Turn!":"Its Computer Turn!",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp),),
          SizedBox(height: 30.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context,child){
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_animation.value * 3.14),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20.sp)
                  ),
                  padding:!gameOver ?EdgeInsets.all(16.sp):EdgeInsets.zero,
                  child:!gameOver?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (col) {
                          return GestureDetector(
                            onTap: () => makeMove(row, col),
                            child: Container(
                                width: 70.w,
                                height: 70.h,
                                margin: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color:grid[row][col]==''?Colors.white60: grid[row][col]=='X'? Colors.yellowAccent:Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(10.sp),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Text(
                                    grid[row][col],
                                    style:  TextStyle(fontSize: 30.sp),
                                  ),
                                ),
                              ),
                          );
                        }),
                      );
                    }),
                  ):Center(
                    child: Text(acknowledgement, style: TextStyle(color: Colors.white,fontSize: 30.sp,fontWeight: FontWeight.w600),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Point<int> getBestMove(List<List<String>> grid, int depth) {
    int bestEval = -1000;
    Point<int> bestMove=const Point(0, 0);
    for (var move in aiPlayer.availableMoves()) {
      aiPlayer.makeMove(move.x, move.y, 'X');
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
        if (checkWinner(row, col)) {
          await _startAnimation();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Game Over'),
              content: Text('Player $currentPlayer wins!'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    initializeGame();
                  },
                  child: Text('Play Again'),
                ),
              ],
            ),
          );
        } else if (grid.every((row) => row.every((cell) => cell != ''))) {
          await _startAnimation();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Game Over'),
              content: Text('It\'s a draw!'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    initializeGame();
                  },
                  child: Text('Play Again'),
                ),
              ],
            ),
          );
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

  bool checkWinner(int row, int col) {

    // Check row
    if (grid[row].every((cell) => cell == currentPlayer)) return true;
    // Check column
    if (grid.every((row) => row[col] == currentPlayer)) return true;
    // Check diagonal
    if (row == col && checkDiagonal(grid)) return true;
    // Check anti-diagonal
    if (row + col == 2 && checkAntiDiagonal(grid)) return true;
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
    Point<int> index= getBestMove(grid, 1);
    grid[index.x][index.y]=currentPlayer;
    audioPlayer.play(AssetSource(Constants.tapSound));
    if (checkWinner(index.x, index.y)) {
      await _startAnimation();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Game Over'),
          content: Text('Player $currentPlayer wins!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                initializeGame();
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    } else if (grid.every((row) => row.every((cell) => cell != ''))) {
      await _startAnimation();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Game Over'),
          content: Text('It\'s a draw!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                initializeGame();
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      setState(() {

      });
    }
  }

  void showSelectItem(){
    showDialog(context: context,
        builder: (context){
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose your Avatar",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp,color: Colors.black),),
                Text("please select any one of the below",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp,color: Colors.grey),),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    aiPlayer.user='X';
                    aiPlayer.robot='O';
                    currentPlayer=aiPlayer.user;
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
                    child:  Center(
                      child: Text(
                        'X',
                        style: TextStyle(fontSize: 30.sp),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    aiPlayer.user='O';
                    aiPlayer.robot='X';
                    currentPlayer=aiPlayer.user;
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
                    child:  Center(
                      child: Text(
                        'O',
                        style: TextStyle(fontSize: 30.sp),
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

  Future<void> _startAnimation() async {

    if(grid.every((row) => row.every((cell) => cell != ''))){
      acknowledgement='Oops!\nIts a Draw';
    }
    ///userWins
    else if(currentPlayer==aiPlayer.user){
      acknowledgement='Congratulations\nYou Win';
      //play win sound;
    }else{
      acknowledgement='Sorry\nYou Lost';
      //play loose sound;
    }
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 500),()=> gameOver==true);
    setState(() {

    });
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void resetAnimation() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reset();
    }
  }
}