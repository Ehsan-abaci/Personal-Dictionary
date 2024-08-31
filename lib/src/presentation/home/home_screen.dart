import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_dictionary/src/common/di.dart';
import 'package:your_dictionary/src/data/data_source/local_data_source.dart';
import 'package:your_dictionary/src/presentation/home/widget/custom_bottom_navigation_bar.dart';
import 'package:your_dictionary/src/presentation/home/widget/search_bar_widget.dart';
import 'package:your_dictionary/src/presentation/home/widget/word_filter.dart';
import 'package:your_dictionary/src/presentation/home/widget/word_list_widget.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';

import '../resources/routes_manager.dart';

Future<bool?> askForComment(BuildContext context) async {
  return await showDialog<bool?>(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorManager.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Didn't you comment?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.white,
                        foregroundColor: ColorManager.primary),
                    child: const Text("Close!"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      String url =
                          "myket://comment?id=ehsan.personal.dictionary";
                      launchUrl(Uri.parse(url)).then(
                        (_) => Navigator.pop(context, true),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        foregroundColor: ColorManager.white),
                    child: const Text("Yesss"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

final OverlayPortalController _overlayController = OverlayPortalController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? canPop;
  @override
  void initState() {
    canPop = instance<LocalDataSource>().isSubmitedComment();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print("deactive");
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _overlayController.hide();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop ?? false,
      onPopInvoked: (_) {
        askForComment(context).then((isSubmited) async {
          if (isSubmited == null) {
            return null;
          }
          if (!isSubmited) {
            SystemNavigator.pop(animated: true);
          } else {
            instance<LocalDataSource>().submiteComment();
            setState(() {
              canPop = true;
            });
          }
        });
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () => _overlayController.isShowing
                  ? _overlayController.hide()
                  : null,
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Stack(
                  children: [
                    SearchBarWidget(constraints: constraints),
                    WordFilterWidget(constraints: constraints),
                    WordListWidget(constraints: constraints),
                  ],
                ),
              ),
            );
          },
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addEditWordRoute);
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            shadowColor: ColorManager.primary.withOpacity(.5),
            backgroundColor: ColorManager.primary,
            foregroundColor: ColorManager.white,
            shape: const CircleBorder(),
            minimumSize: const Size(65, 65),
          ),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}

