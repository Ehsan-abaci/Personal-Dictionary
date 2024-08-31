import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/domain/models/word.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/resources/routes_manager.dart';
import 'package:your_dictionary/src/presentation/resources/strings_manager.dart';

import '../../bloc/text_to_speech/text_to_speech_bloc.dart';
import '../../constant/functions.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<String> classes;
  late String id;
  late Word wordData;
  late LanguageMode mode;

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)?.settings.arguments as String;
    wordData = context.read<WordBloc>().fetchWordByIdEvent(id);
    classes = numberOfType(wordData);
    mode = context.read<WordBloc>().state.mode;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorManager.primary,
        body: SafeArea(
          child: AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocConsumer<WordBloc, WordState>(
                  listener: (context, state) {
                    var newWordData =
                        state.wordList.firstWhere((e) => e.id == id);
                    wordData = newWordData;
                    classes = numberOfType(newWordData);
                  },
                  builder: (context, state) => Stack(
                    children: [
                      getAppBar(constraints),
                      getTopDetails(wordData, classes, constraints),
                      getBottomDetails(wordData, constraints),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBar(BoxConstraints constraints) {
    return Positioned(
        right: 0,
        left: 0,
        top: 0,
        height: constraints.maxHeight * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorManager.white,
                ))
          ],
        ));
  }

  Widget getTopDetails(
      Word wordData, List<String> classes, BoxConstraints constraints) {
    return Positioned(
      top: constraints.maxHeight * 0.06,
      height: constraints.maxWidth >= 450
          ? constraints.maxHeight * 0.5
          : constraints.maxHeight * 0.34,
      width: constraints.maxWidth,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getTitleContent(wordData.title, constraints),
            SizedBox(height: constraints.maxHeight * 0.02),
            getClasses(classes.join(" | ")),
            SizedBox(height: constraints.maxHeight * 0.1),
            getButtons(wordData, constraints),
            SizedBox(height: constraints.maxHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget getTitleContent(String title, BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxWidth >= 450
          ? constraints.maxHeight * 0.35
          : constraints.maxHeight * 0.4,
      width: double.infinity,
      child: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: SelectionArea(
          child: Text(
            title, // Title of Screen
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: 35,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget getClasses(String classes) {
    return Text(
      classes,
      style: TextStyle(color: ColorManager.grey),
    );
  }

  Widget getBottomDetails(Word wordData, BoxConstraints constraints) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      height: constraints.maxWidth >= 450
          ? constraints.maxHeight * 0.44
          : constraints.maxHeight * 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  getSection(getDefText(mode)[1].toUpperCase()),
                  getDivider(),
                  getDefinition(
                      wordData.secMeaning, TextDirection.rtl, constraints),
                  getSection(getDefText(mode)[0].toUpperCase()),
                  getDivider(),
                  getDefinition(
                      wordData.mainMeaning, TextDirection.ltr, constraints),
                  getSection("EXAMPLES"),
                  getDivider(),
                  getExamples(wordData.mainExample, constraints),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getSection(String text) {
    return Text(
      text,
      style: TextStyle(
        color: ColorManager.primary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget getDivider() {
    return Divider(
      color: ColorManager.primary,
      thickness: 1.2,
    );
  }

  Widget getDefinition(List<String> definitions, TextDirection direction,
      BoxConstraints constraints) {
    return Directionality(
      textDirection: direction,
      child: definitions.isEmpty
          ? SizedBox(
              height: constraints.maxHeight * 0.1,
              child: Center(
                child: Text(
                  direction == TextDirection.rtl
                      ? getEmptyDefText(mode)[1]
                      : getEmptyDefText(mode)[0],
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            )
          : Container(
              constraints:
                  BoxConstraints(maxHeight: constraints.maxHeight * 0.2),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return SelectionArea(
                    selectionControls: MaterialTextSelectionControls(),
                    child: Text.rich(
                      strutStyle: const StrutStyle(
                        height: 1.5,
                      ),
                      TextSpan(
                        text: "${index + 1}. ",
                        children: [
                          TextSpan(
                            text: definitions[index],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          )
                        ],
                        style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  );
                },
                itemCount: definitions.length,
              ),
            ),
    );
  }

  Widget getExamples(List<String> examples, BoxConstraints constraints) {
    return examples.isEmpty
        ? SizedBox(
            height: constraints.maxHeight * 0.1,
            child: Center(
              child: Text(
                AppStrings.emptyMainEx,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          )
        : SizedBox(
            height: constraints.maxHeight * 0.3,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return SelectionArea(
                  child: Text.rich(
                    TextSpan(
                        text: "${index + 1}. ",
                        style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                        children: [
                          TextSpan(
                            text: examples[index],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          )
                        ]),
                  ),
                );
              },
              itemCount: examples.length,
            ),
          );
  }

  Widget getButtons(Word wordData, BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * .9,
      height: 55,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            customIconButton(
              () {
                context
                    .read<TextToSpeechBloc>()
                    .add(PlayAudioEvent(text: wordData.title, mode: mode));
              },
              Icons.volume_up,
            ),
            customIconButton(() {
              Navigator.pushNamed(context, Routes.addEditWordRoute,
                  arguments: id);
            }, Icons.mode_edit_rounded),
            customIconButton(() {
              context.read<WordBloc>().add(AddToMarkedWordsEvent(id: id));
            },
                wordData.isMarked
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.plus),
            customIconButton(
              () {
                deleteDialog().then((val) {
                  if (val == true) {
                    Navigator.pop(context);
                    Future.delayed(Duration.zero).then((value) {
                      context.read<WordBloc>().add(RemoveWordEvent(id: id));
                    });
                  }
                });
              },
              Icons.delete_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> deleteDialog() {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          content: FittedBox(
            child: Text(
              'Are you sure you want to delete this word?',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorManager.primary, fontSize: 20),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorManager.white,
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: ColorManager.primary,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const FittedBox(child: Text("Yes")),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorManager.primary,
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: ColorManager.white,
                        side: BorderSide(
                          color: ColorManager.primary,
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: FittedBox(
                        child: Text("No",
                            style: TextStyle(color: ColorManager.primary)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget customIconButton(Function function, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => function(),
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: ColorManager.grey.withOpacity(0.3)),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Icon(
              icon,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
  }
}
