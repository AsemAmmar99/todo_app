import 'dart:async';
import 'package:todo_app/constants/screens.dart' as screens;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/styles/colors.dart';
import 'package:todo_app/presentation/widgets/default_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pushNamedAndRemoveUntil(screens.HOME_SCREEN, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image(
                    height: 30.h,
                    width: 70.w,
                    image: const AssetImage(
                      "assets/todo.png",
                    ),
                ),
              ),
              Flexible(
                child: DefaultText(
                  text: 'MY TO-DO LIST',
                  color: darkBlue,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
      ),
    );
  }
}
