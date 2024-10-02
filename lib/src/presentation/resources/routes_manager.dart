import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/common/di.dart';
import 'package:your_dictionary/src/presentation/add_edit_page/add_edit_screen.dart';
import 'package:your_dictionary/src/presentation/detail_page/detail_screen.dart';
import 'package:your_dictionary/src/presentation/settings_page/settings_screen.dart';
import 'package:your_dictionary/src/presentation/text_recognition/cubit/recognitioned_texts/recognitioned_texts_cubit.dart';
import 'package:your_dictionary/src/presentation/text_recognition/scan_camera_page.dart';

import '../../bloc/definition/definition_bloc.dart';
import '../../bloc/radio_toggle/radio_toggle_bloc.dart';
import '../../bloc/text_to_speech/text_to_speech_bloc.dart';
import '../../bloc/validate/validate_cubit.dart';
import '../home/home_screen.dart';
import '../splash/splash_screen.dart';
import '../text_recognition/text_recognition_page.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String addEditWordRoute = '/add-edit-word';
  static const String wordDetailRoute = '/word-detail';
  static const String settingsRoute = '/settings';
  static const String textRecognitionRoute = '/text-recognition';
  static const String scanCameraRoute = '/scan-camera';
}

class RouteGenerator {
  static Route getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.addEditWordRoute:
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
            child: const AddAndEditScreen(),
          ),
          settings: RouteSettings(arguments: routeSettings.arguments),
        );
      case Routes.wordDetailRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<TextToSpeechBloc>(
                  create: (context) => TextToSpeechBloc(instance()),
                  child: const DetailScreen(),
                ),
            settings: RouteSettings(arguments: routeSettings.arguments));
      case Routes.textRecognitionRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<RecognitionedTextsCubit>(
            create: (context) => RecognitionedTextsCubit(instance()),
            child: TextRecognitionPage(
              picturedImage: routeSettings.arguments as File,
            ),
          ),
        );
      case Routes.scanCameraRoute:
        return MaterialPageRoute(
          builder: (_) => const ScanCameraPage(),
        );
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
