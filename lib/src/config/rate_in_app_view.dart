import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_dictionary/src/common/di.dart';
import 'package:your_dictionary/src/constant/constant_key.dart';
import 'package:your_dictionary/src/data/data_source/local_data_source.dart';

import '../presentation/resources/color_manager.dart';

class RateInAppView {
  static Future<bool?> rateInAppRequest(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 170,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Rate Our App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "If you love our app, please take a moment to rate it.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(height: 25),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Later"),
                  ),
                  const SizedBox(width: 30),
                  TextButton(
                    onPressed: () async {
                      await instance<LocalDataSource>().submiteComment();
                      Navigator.pop(context, false);
                    },
                    child: const Text("NO, THANKS"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await instance<LocalDataSource>().submiteComment();
                      launchUrl(Uri.parse(rateInAppMyketUrl)).then(
                        (_) => Navigator.pop(context, true),
                      );
                    },
                    child: const Text("RATE NOW"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
