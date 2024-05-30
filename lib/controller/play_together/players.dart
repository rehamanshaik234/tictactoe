import 'package:audioplayers/audioplayers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playspace/utils/constants/constants.dart';
import 'package:playspace/views/widgets/custom_dialogs.dart';

import '../../utils/constants/app_colors.dart';
import '../../views/widgets/odd_number_picker.dart';

class PlayTogetherController{

  String player2='O';
  String player1='X';
  String player1Name='Player1';
  String player2Name='Player2';

  late List<List<String>> grid;
  late String currentPlayer;
  bool gameOver=false;
  AudioPlayer audioPlayer=AudioPlayer();
  String acknowledgement='';
  final cardKey=GlobalKey<FlipCardState>();
  BowDirection bowDirection = BowDirection.none;
  int player1Score=0;
  int player2Score=0;
  bool player1ScoreChange=false;
  bool player2ScoreChange=false;
  int totalRounds=5;
  int currentRound=1;

  void initializeGame(VoidCallback setState) async {
    audioPlayer.setSource(AssetSource(Constants.tapSound));
    grid = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = player1;
    gameOver = false;
    bowDirection = BowDirection.none;
    setState();
  }

  void setPlayer1(String player1){
    this.player1=player1;
  }

  void setPlayer2(String player2){
    this.player2=player2;
  }

  void setPlayer2Name(String player2Name){
    this.player2Name=player2Name;
  }

  void setPlayer1Name(String player1Name){
    this.player1Name=player1Name;
  }

  void makeMove(int row, int col, Function setState,BuildContext context)async{
    if (!gameOver && grid[row][col] == ''){
      grid[row][col] = currentPlayer;
      await audioPlayer.play(AssetSource(Constants.tapSound)).whenComplete(() async {
        if (await checkWinner(row, col,setState)) {
          await _startAnimation(row,col,setState,context);
        } else if (grid.every((row) => row.every((cell) => cell != ''))) {
          await _startAnimation(row, col,setState,context);
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          setState(() {

          });
        }
      });
    }
  }

  Future<void> _startAnimation(int row, int col,Function setState,BuildContext context) async {
    String soundPath = '';
    if (grid.every((row) => row.every((cell) => cell != '')) && !await checkWinner(row, col,setState)) {
      acknowledgement = 'Oops! 🥴 \nIts a Draw';
      cardKey.currentState?.toggleCard();
      soundPath = Constants.gameDraw;
    }
    else if (currentPlayer == player1) {
      acknowledgement = '$player1Name\nWon!';
      player1Score = player1Score + 1;
      soundPath=Constants.addPoint;
      player1ScoreChange = true;
    } else {
      acknowledgement = '$player2Name\nWon!';
      player2Score = player2Score + 1;
      player2ScoreChange = true;
      soundPath=Constants.addPoint;
    }
    gameOver = true;
    showGameOverDialog(soundPath,context);
    setState(() {
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      player1ScoreChange = false;
      player2ScoreChange = false;
    });
  }

  Future<bool> checkWinner(int row, int col,Function setState)async{

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

  void showOptionsMenu(BuildContext context,Function setState){
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          MediaQuery.of(context).size.width - 100,
          20.0,
          0.0,
          0.0,),
        items: [
          PopupMenuItem(
            onTap: (){
              showEditPlayerNames(context, setState);
              },
            child: Row(
              children: [
                Icon(Icons.edit,color: AppColors.secondaryColor,size: 20.sp,),
                SizedBox(width: 4.w,),
                Text("Player Names",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
              ],
            ),),
          PopupMenuItem(
              onTap: (){
                if(currentRound!=1 || !checkGridIsEmpty()) {
                  CustomDialogs.showCustomDialog("Change Rounds ?",
                      "If you change rounds now, the current running game will be auto-restart.", () {
                        selectRounds(context,setState);
                        restartGame(setState);
                      }, "Restart", context);
                }else{
                  selectRounds(context,setState);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.leaderboard_outlined,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Change Rounds",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              )
          ),
          PopupMenuItem(
              onTap: (){
                restartGameWithPopUp(context, setState);
              },
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded,color: AppColors.secondaryColor,size: 20.sp,),
                  SizedBox(width: 4.w,),
                  Text("Restart Game",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16.sp,color: AppColors.secondaryColor),),
                ],
              ))
        ]);
  }

  void resetGame(Function setState){
    grid = List.generate(3, (_) => List.filled(3, ''));
    gameOver = false;
    bowDirection = BowDirection.none;
    if(!cardKey.currentState!.isFront){
      cardKey.currentState?.toggleCard();
    }
    setState(() {

    });
  }

  void restartGameWithPopUp(BuildContext context, Function setState){
    CustomDialogs.showCustomDialog("Restart Game?", "Are you sure you want to restart the game? This will reset your score.",(){
      initializeGame((){setState(() {});});
      if(!cardKey.currentState!.isFront){
        cardKey.currentState?.toggleCard();
      }
      setState(() {
        player1Score=0;
        player2Score=0;
        totalRounds=5;
        currentRound=1;
        currentPlayer=player1;
      });
    },'Confirm',context);
  }

  void restartGame(Function setState){
    initializeGame((){setState(() {});});
    if(!cardKey.currentState!.isFront){
      cardKey.currentState?.toggleCard();
    }
    setState(() {
      player1Score=0;
      player2Score=0;
      totalRounds=5;
      currentRound=1;
      currentPlayer=player1;
    });
  }

  void selectRounds(BuildContext context,Function setState){
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
                    selectedTextStyle: GoogleFonts.poppins(color:AppColors.secondaryColor,fontWeight: FontWeight.w500,fontSize: 20.sp) ,
                    textStyle: GoogleFonts.poppins(color:Colors.grey,fontWeight: FontWeight.w400,fontSize: 16.sp),
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
                                backgroundColor: WidgetStatePropertyAll<Color>(AppColors.secondaryColor),
                                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
                            child: Text('Save',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white),),
                          ),
                        ),
                        SizedBox(
                          width: 110.w,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
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

  void showEditPlayerNames(BuildContext context, Function setState){
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
                                      player1Name=player1TE.text;
                                      player2Name=player2TE.text;
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
                                  style: ButtonStyle(shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)))),
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
  

  void showGameOverDialog(String soundPath,BuildContext context)async {
    double halfRounds=totalRounds/2;
    if(halfRounds.ceil()==player1Score) {
      acknowledgement = 'Congratulations! $player1Name Won 🥳';
      CustomDialogs.showWinDialog("Game Over", acknowledgement, (){}, "Select Dare", context);
      audioPlayer.play(AssetSource(Constants.gameWon));
    } else if(halfRounds.ceil()== player2Score){
      acknowledgement = 'Congratulations! $player2Name Won 🥳';
      CustomDialogs.showWinDialog("Game Over", acknowledgement, (){}, "Select Dare", context);
      audioPlayer.play(AssetSource(Constants.gameWon));
    }else if(currentRound==totalRounds){
      if(player1Score>player2Score){
        acknowledgement = 'Congratulations! $player1Name Won 🥳';
        CustomDialogs.showWinDialog("Game Over", acknowledgement, (){}, "Select Dare", context);
        audioPlayer.play(AssetSource(Constants.gameWon));
      }else if(player2Score>player1Score){
        acknowledgement = 'Congratulations! $player2Name Won 🥳';
        CustomDialogs.showWinDialog("Game Over", acknowledgement, (){}, "Select Dare", context);
        audioPlayer.play(AssetSource(Constants.gameWon));
      }else {
        acknowledgement = "Itz a Draw, You both have to select the Dare";
        audioPlayer.play(AssetSource(Constants.gameDraw));
        CustomDialogs.showCustomDialog(
            "Game Draw", acknowledgement, () {}, "Select Dare", context);
      }
    } else{
      if(currentPlayer==player1){
        currentPlayer=player2;
      }else{
        currentPlayer=player1;
      }
      cardKey.currentState?.toggleCard();
      await audioPlayer.play(AssetSource(soundPath));
      currentRound=currentRound+1;
    }
  }



}