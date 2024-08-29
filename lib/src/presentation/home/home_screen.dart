import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:your_dictionary/src/presentation/home/widget/custom_bottom_navigation_bar.dart';
import 'package:your_dictionary/src/presentation/home/widget/search_bar_widget.dart';
import 'package:your_dictionary/src/presentation/home/widget/word_filter.dart';
import 'package:your_dictionary/src/presentation/home/widget/word_list_widget.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/resources/routes_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  SearchBarWidget(
                    constraints: constraints,
                  ),
                  WordFilterWidget(constraints: constraints),
                  WordListWidget(
                    constraints: constraints,
                  ),
                ],
              ),
            );
          },
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: 
       ElevatedButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routes.addEditWordRoute);
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: ColorManager.primary.withOpacity(.5),
          backgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          shape:  CircleBorder(),
          minimumSize: Size(65, 65),
      
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
