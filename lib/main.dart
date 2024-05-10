

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playspace/controller/provider/global_var/global_variables_provider.dart';
import 'package:playspace/utils/constants/app_colors.dart';
import 'package:playspace/utils/routes/RouteNames.dart';
import 'package:playspace/utils/routes/Routes.dart';
import 'package:playspace/views/game/board.dart';
import 'package:provider/provider.dart';

void main()async{
  runApp(
      MultiProvider(
        providers: [
             Provider(create: (context)=> GlobalProvider()),
                    ],
        child: const TicTacToe(),
      )
  );
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
      builder: (context,child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tic Tac Toe',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.secondaryColor
          ),
          onGenerateRoute: Routes.generateRoute,
          initialRoute: RoutesName.splashScreen,
        );
      }
    );
  }
}

