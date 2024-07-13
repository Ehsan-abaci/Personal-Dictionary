// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:your_dictionary/src/bloc/filtered_words/filtered_words_bloc.dart';
import 'package:your_dictionary/src/bloc/mark_word/mark_word_cubit.dart';
import 'package:your_dictionary/src/bloc/search_word/search_word_cubit.dart';

import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/bloc/word_filter/word_filter_bloc.dart';
import 'package:your_dictionary/src/constant/functions.dart';
import 'package:your_dictionary/src/presentation/resources/assets_manager.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/resources/routes_manager.dart';
import '../../../bloc/manage_extending/manage_extending_cubit.dart';
import '../../../domain/models/word.dart';

class WordListWidget extends StatefulWidget {
  WordListWidget({Key? key, required this.constraints}) : super(key: key);
  final BoxConstraints constraints;
  @override
  State<WordListWidget> createState() => _WordListWidgetState();
}

class _WordListWidgetState extends State<WordListWidget> {
  @override
  void initState() {
    context.read<WordBloc>().add(FetchWordsEvent());
    super.initState();
  }

  late Limit limit;
  late List<Word> words;
  @override
  void didChangeDependencies() {
    limit = context.watch<MarkWordCubit>().state.typeOfLimit;
    words = context.watch<FilteredWordsBloc>().state.wordList;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MarkWordCubit, MarkWordState>(
          listener: (context, state) {
            context.read<FilteredWordsBloc>().add(
                  SetFilteredWords(
                      filter: context.read<WordFilterBloc>().state.filters,
                      searchTerm:
                          context.read<SearchWordCubit>().state.searchTerm,
                      words: context.read<WordBloc>().state.wordList,
                      limit: state.typeOfLimit),
                );
          },
        ),
        BlocListener<WordBloc, WordState>(
          listener: (context, state) {
            context.read<FilteredWordsBloc>().add(
                  SetFilteredWords(
                      filter: context.read<WordFilterBloc>().state.filters,
                      searchTerm:
                          context.read<SearchWordCubit>().state.searchTerm,
                      words: state.wordList,
                      limit: limit),
                );
          },
        ),
        BlocListener<SearchWordCubit, SearchWordState>(
          listener: (context, state) {
            context.read<FilteredWordsBloc>().add(
                  SetFilteredWords(
                      filter: context.read<WordFilterBloc>().state.filters,
                      searchTerm: state.searchTerm,
                      words: context.read<WordBloc>().state.wordList,
                      limit: limit),
                );
          },
        ),
        BlocListener<WordFilterBloc, WordFilterState>(
            listener: (context, state) {
          context.read<FilteredWordsBloc>().add(
                SetFilteredWords(
                    filter: state.filters,
                    searchTerm:
                        context.read<SearchWordCubit>().state.searchTerm,
                    words: context.read<WordBloc>().state.wordList,
                    limit: limit),
              );
        }),
      ],
      child: Positioned(
        height: widget.constraints.maxWidth >= 450
            ? widget.constraints.maxHeight * 0.65
            : widget.constraints.maxHeight * 0.85,
        top: widget.constraints.maxWidth >= 450
            ? widget.constraints.maxHeight * 0.35
            : widget.constraints.maxHeight * 0.15,
        right: 0,
        left: 0,
        child: words.isEmpty
            ? Center(
                child: Lottie.asset(JsonAssets.empty),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: words.length,
                itemBuilder: (context, index) => ItemWidget(
                  key: UniqueKey(),
                  index: index,
                ),
              ),
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    required this.key,
    required this.index,
  }) : super(key: key);
  final int index;
  final Key key;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late LanguageMode mode;

  @override
  Widget build(BuildContext context) {
    final words =
        context.watch<FilteredWordsBloc>().state.wordList.reversed.toList();
    mode = context.read<WordBloc>().state.mode;
    List<String> list = numberOfType(words[widget.index]);
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pushNamed(context, Routes.wordDetailRoute,
            arguments: words[widget.index].id);
      },
      borderRadius: BorderRadius.circular(25),
      radius: 25,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        key: widget.key,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        height: context
                    .watch<ManageExtendingCubit>()
                    .state
                    .isExtendedMap[widget.key] ??
                false
            ? 150
            : 70,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: ColorManager.white, width: 1),
            borderRadius: BorderRadius.circular(15),
            color: ColorManager.white),
        child: context
                    .watch<ManageExtendingCubit>()
                    .state
                    .isExtendedMap[widget.key] ??
                false
            ? Column(
                children: [
                  Flexible(
                      flex: 4,
                      child: listTileWidget(
                          list, words[widget.index], Icons.arrow_drop_up)),
                  Flexible(
                    flex: 1,
                    child: Divider(
                      endIndent: 50,
                      indent: 50,
                      color: ColorManager.grey,
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 6,
                            child: words[widget.index].mainMeaning.isEmpty
                                ? emptyContent(getEmptyDefText(mode)[0])
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) => defItem(
                                        words[widget.index].mainMeaning[index],
                                        TextDirection.ltr),
                                    itemCount:
                                        words[widget.index].mainMeaning.length,
                                  ),
                          ),
                          Expanded(
                              child: VerticalDivider(
                            endIndent: 5,
                            indent: 0,
                            color: ColorManager.grey,
                            width: 10,
                          )),
                          Flexible(
                              flex: 6,
                              child: words[widget.index].secMeaning.isEmpty
                                  ? emptyContent(getEmptyDefText(mode)[1])
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) => defItem(
                                          words[widget.index].secMeaning[index],
                                          TextDirection.rtl),
                                      itemCount:
                                          words[widget.index].secMeaning.length,
                                    )),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : listTileWidget(list, words[widget.index], Icons.arrow_drop_down),
      ),
    );
  }

  Widget emptyContent(String text) {
    return Center(
      child: FittedBox(
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget listTileWidget(List<String> type, Word word, IconData icon) {
    String fullText = type.join(" | ");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              word.title,
              style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  fullText,
                  style: TextStyle(
                    color: Colors.red[900],
                  ),
                ),
                IconButton(
                  icon: Icon(icon),
                  onPressed: () {
                    context.read<ManageExtendingCubit>().switching(widget.key);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget defItem(String text, TextDirection direction) {
    return Text(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16),
      "● $text",
      textDirection: direction,
    );
  }
}
