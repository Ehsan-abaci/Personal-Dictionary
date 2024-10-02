import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:your_dictionary/src/common/di.dart';
import 'package:your_dictionary/src/config/rate_in_app_view.dart';
import 'package:your_dictionary/src/data/data_source/local_data_source.dart';
import 'package:your_dictionary/src/presentation/home/widget/custom_bottom_navigation_bar.dart';
import 'package:your_dictionary/src/presentation/home/widget/search_bar_widget.dart';
import 'package:your_dictionary/src/presentation/home/widget/word_filter.dart';
import 'package:your_dictionary/src/presentation/home/widget/word_list_widget.dart';
import 'widget/floating_action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    BackButtonInterceptor.add(rateInAppInterceptor, context: context);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(rateInAppInterceptor);
    super.dispose();
  }

  FutureOr<bool> rateInAppInterceptor(bool stopDefaultButtonEvent, RouteInfo info) async {
    if (info.ifRouteChanged(context) || instance<LocalDataSource>().isSubmitedComment()) return false;
    return await RateInAppView.rateInAppRequest(context) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  SearchBarWidget(constraints: constraints),
                  WordFilterWidget(constraints: constraints),
                  WordListWidget(constraints: constraints),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingActionAddButton(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
