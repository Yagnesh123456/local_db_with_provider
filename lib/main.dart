import 'package:flutter/material.dart';
import 'package:local_db_sample/provider/user.dart';
import 'package:local_db_sample/screen/user/show_user_screen.dart';
import 'package:local_db_sample/widget/style_color.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,


        theme: ThemeData.light().copyWith(
          primaryColor: primaryColor,
          backgroundColor: primaryColor,
          scaffoldBackgroundColor: backGroundColor,
          shadowColor: shadowColor,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 3,
            backgroundColor: primaryColor,
          ),
          progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: primaryColor),
          appBarTheme: const AppBarTheme(
            shadowColor: shadowColor,
            backgroundColor: primaryColor,
            elevation: 3,
            centerTitle: true,
          ),
          cardTheme: const CardTheme(
            color: Colors.white,
            elevation: 3,
            shadowColor: shadowColor,
          ),
          indicatorColor: primaryColor,
        ),
        home: const ShowUserScreen(),
      ),
    );
  }
}
