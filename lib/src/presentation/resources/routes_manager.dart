import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/common/di.dart';
import 'package:your_dictionary/src/presentation/detail_page/detail_screen.dart';
import 'package:your_dictionary/src/presentation/settings_page/settings_screen.dart';

import '../../bloc/definition/definition_bloc.dart';
import '../../bloc/radio_toggle/radio_toggle_bloc.dart';
import '../../bloc/text_to_speech/text_to_speech_bloc.dart';
import '../../bloc/validate/validate_cubit.dart';
import '../add_page/add_screen.dart';
import '../edit_page/edit_screen.dart';
import '../home/home_screen.dart';
import '../splash/splash_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String addWordRoute = '/add-word';
  static const String editWordRoute = '/edit-word';
  static const String wordDetailRoute = '/word-detail';
  static const String settingsRoute = '/settings';
}

class RouteGenerator {
  static Route getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.addWordRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => RadioToggleBloc(),
                    ),
                    BlocProvider(
                      create: (context) => DefinitionBloc(),
                    ),
                    BlocProvider(
                      create: (context) => ValidateCubit(),
                    ),
                  ],
                  child: AddScreen(),
                ));
      case Routes.wordDetailRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<TextToSpeechBloc>(
                  create: (context) => TextToSpeechBloc(instance()),
                  child: DetailScreen(),
                ),
            settings: RouteSettings(arguments: routeSettings.arguments));
      case Routes.editWordRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => RadioToggleBloc(),
              ),
              BlocProvider(
                create: (context) => DefinitionBloc(),
              ),
              BlocProvider(
                create: (context) => ValidateCubit(),
              ),
            ],
            child: EditWordScreen(),
          ),
          settings: RouteSettings(arguments: routeSettings.arguments),
        );
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
