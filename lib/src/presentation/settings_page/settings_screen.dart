
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_dictionary/src/domain/models/file_manager.dart';
import 'package:your_dictionary/src/presentation/resources/assets_manager.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/settings_page/widgets/language_mode_widget.dart';

import '../../bloc/word/word_bloc.dart';
import '../resources/strings_manager.dart';
import 'widgets/list_tile_item.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FileManager fileManager = FileManager();
  FileStorageManager fileStorageManager = FileStorageManager();


    String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
    void contactUs() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'phoenixSoftwareGroup@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Personal Dictionary',
        'body':'Hi...'
      }),
    );
     launchUrl(emailLaunchUri);
  }
  
  void exportFile() {
    fileManager.exportFile(fileStorageManager).then((_) {
      if (fileManager.fileInDirectoryToSave != null) {
        context.read<WordBloc>().add(
            ExportDataEvent(exportFile: fileManager.fileInDirectoryToSave!));
      }
    });
  }

  void importFile() {
    fileManager.importFile().then((_) {
      if (fileManager.fileInDirectoryToSelect != null) {
        context
            .read<WordBloc>()
            .add(ImportDataEvent(importFile: fileManager.fileInDirectoryToSelect!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.15,
                    child: AppBar(
                      backgroundColor: ColorManager.white,
                      elevation: 0,
                      leading: IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 25,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          color: ColorManager.primary,
                          Icons.arrow_back_ios_new_rounded,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * .15,
                    width: constraints.maxWidth,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        AppStrings.settings,
                        style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.7,
                    width: constraints.maxWidth,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        languageModeItem(
                          constraints,
                          AppStrings.languageMode,
                          () {},
                          const LanguageModeWidget(),
                        ),
                        // customDivider(),
                        listTileItem(
                            constraints,
                            // Item title
                            AppStrings.exportWords,
                            // export file function
                            exportFile,
                             SvgPicture.asset(IconAssets.export),
                        ),
                        listTileItem(
                            constraints,
                            AppStrings.importWords,
                           importFile,
                            SvgPicture.asset(IconAssets.import),
                        ),
                        customDivider(),
                          listTileItem(
                            constraints,
                            AppStrings.contactUs,
                           contactUs,
                            SvgPicture.asset(IconAssets.contactUs),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }

  Widget customDivider() {
    return Divider(height: 3,
      color: ColorManager.grey,
      indent: 10,
      endIndent: 10,
      thickness: 1,
    );
  }
}
