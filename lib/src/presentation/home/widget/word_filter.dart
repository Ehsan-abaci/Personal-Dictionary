import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/bloc/change_filter_color/change_filter_color_cubit.dart';
import 'package:your_dictionary/src/bloc/word_filter/word_filter_bloc.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';

import '../../../domain/models/word.dart';

class WordFilterWidget extends StatefulWidget {
  final BoxConstraints constraints;

  const WordFilterWidget({Key? key, required this.constraints})
      : super(key: key);

  @override
  State<WordFilterWidget> createState() => _WordFilterWidgetState();
}

class _WordFilterWidgetState extends State<WordFilterWidget> {
  List<Filter> filterTypes = [];
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: widget.constraints.maxWidth >= 450
          ? widget.constraints.maxHeight * 0.1
          : widget.constraints.maxHeight * 0.05,
      top: widget.constraints.maxWidth >= 450
          ? widget.constraints.maxHeight * 0.24
          : widget.constraints.maxHeight * 0.096,
      width: widget.constraints.maxWidth,
      child: ListView(
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10),
          children: List.generate(
            _filters.length,
            (index) => Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 3,
              ),
              child: ElevatedButton(
                onPressed: () => setFilterType(index),
                style: ElevatedButton.styleFrom(
                    foregroundColor: ColorManager.primary,
                    backgroundColor: context
                        .watch<ChangeFilterColorCubit>()
                        .state
                        .colorMap[index],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.grey,
                        ))),
                child: Text(
                  _filters[index],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void setColorFilter(int index) {
    switch (index) {
      case 0:
        context
            .read<ChangeFilterColorCubit>()
            .setFilterColor(filterIndex: 0, color: ColorManager.filterColor);
        break;
      case 1:
        context
            .read<ChangeFilterColorCubit>()
            .setFilterColor(filterIndex: 1, color: ColorManager.filterColor);
        break;
      case 2:
        context
            .read<ChangeFilterColorCubit>()
            .setFilterColor(filterIndex: 2, color: ColorManager.filterColor);
        break;
      case 3:
        context
            .read<ChangeFilterColorCubit>()
            .setFilterColor(filterIndex: 3, color: ColorManager.filterColor);
        break;
      case 4:
        context
            .read<ChangeFilterColorCubit>()
            .setFilterColor(filterIndex: 4, color: ColorManager.filterColor);
        break;
    }
  }

  void setFilterType(int index) {
    switch (index) {
      case 0:
        setColorFilter(index);
        if (filterTypes.contains(Filter.noun)) {
          filterTypes.remove(Filter.noun);
        } else {
          filterTypes.add(Filter.noun);
        }
        break;
      case 1:
        setColorFilter(index);

        if (filterTypes.contains(Filter.verb)) {
          filterTypes.remove(Filter.verb);
        } else {
          filterTypes.add(Filter.verb);
        }
        break;
      case 2:
        setColorFilter(index);

        if (filterTypes.contains(Filter.adjective)) {
          filterTypes.remove(Filter.adjective);
        } else {
          filterTypes.add(Filter.adjective);
        }
        break;
      case 3:
        setColorFilter(index);

        if (filterTypes.contains(Filter.adverb)) {
          filterTypes.remove(Filter.adverb);
        } else {
          filterTypes.add(Filter.adverb);
        }
        break;
      case 4:
        setColorFilter(index);

        if (filterTypes.contains(Filter.phrases)) {
          filterTypes.remove(Filter.phrases);
        } else {
          filterTypes.add(Filter.phrases);
        }
        break;
    }

    context
        .read<WordFilterBloc>()
        .add(SetWordFilterEvent(filters: filterTypes));
  }
}

const _filters = [
  "noun",
  "verb",
  "adjective",
  "adverb",
  "phrases",
];
