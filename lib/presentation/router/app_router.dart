import 'package:flutter/material.dart';
import 'package:todo_app/presentation/screens/splash/splash_screen.dart';
import 'package:todo_app/constants/screens.dart' as screens;

import '../screens/home/home_layout.dart';

class AppRouter{
  late Widget startWidget;

  Route? onGenerateRoute(RouteSettings settings){

    startWidget = const SplashScreen();

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => startWidget);
      case screens.HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      default:
        return null;
    }
  }
}