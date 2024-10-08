
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:your_dictionary/src/bloc/change_filter_color/change_filter_color_cubit.dart';
import 'package:your_dictionary/src/bloc/mark_word/mark_word_cubit.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/bloc/word_filter/word_filter_bloc.dart';
import 'package:your_dictionary/src/common/di.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/text_recognition/cubit/text_edit_mode/text_edit_mode_cubit.dart';
import 'src/bloc/filtered_words/filtered_words_bloc.dart';
import 'src/bloc/manage_extending/manage_extending_cubit.dart';
import 'src/bloc/search_word/search_word_cubit.dart';
import 'src/presentation/resources/routes_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  await Hive.initFlutter();
  await initAppModule();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorManager.primary,
    systemStatusBarContrastEnforced: true,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() async {
    await Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MarkWordCubit>(
          create: (context) => MarkWordCubit(),
        ),
        BlocProvider<ChangeFilterColorCubit>(
          create: (context) => ChangeFilterColorCubit(),
        ),
        BlocProvider<SearchWordCubit>(
          create: (context) => SearchWordCubit(),
        ),
        BlocProvider<WordFilterBloc>(
          create: (context) => WordFilterBloc(),
        ),
        BlocProvider<FilteredWordsBloc>(
          create: (context) => FilteredWordsBloc(),
        ),
        BlocProvider<ManageExtendingCubit>(
          create: (context) => ManageExtendingCubit(),
        ),
        BlocProvider<TextEditModeCubit>(
          create: (context) => TextEditModeCubit(),
        ),
        BlocProvider<WordBloc>(
          create: (context) => instance<WordBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true, fontFamily: "OpenSans"),
        themeMode: ThemeMode.light,
        title: 'Your Dictionary',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashRoute,
      ),
    );
  }
}
