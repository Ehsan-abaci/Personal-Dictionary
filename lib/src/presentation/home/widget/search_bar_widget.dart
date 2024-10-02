import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_dictionary/src/bloc/search_word/search_word_cubit.dart';
import 'package:your_dictionary/src/presentation/resources/assets_manager.dart';
import 'package:your_dictionary/src/presentation/resources/routes_manager.dart';
import 'package:your_dictionary/src/presentation/resources/strings_manager.dart';
import '../../resources/color_manager.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key, required this.constraints}) : super(key: key);
  final BoxConstraints constraints;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        height: widget.constraints.maxWidth >= 450
            ? widget.constraints.maxHeight * 0.22
            : widget.constraints.maxHeight * 0.08,
        top: widget.constraints.maxHeight * 0.01,
        right: widget.constraints.maxWidth * 0.01,
        left: widget.constraints.maxWidth * 0.01,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: widget.constraints.maxWidth >= 450
                    ? widget.constraints.maxWidth * .1
                    : widget.constraints.maxWidth * 0.13,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.settingsRoute);
                    },
                    icon: SvgPicture.asset(
                      IconAssets.settings,
                      height: 25,
                    ),
                  ),
                )),
            SizedBox(
              width: widget.constraints.maxWidth >= 450
                  ? widget.constraints.maxWidth * .88
                  : widget.constraints.maxWidth * 0.85,
              child: TextField(
                controller: _searchController,
                onChanged: (_) {
                  context
                      .read<SearchWordCubit>()
                      .setSearchTerm(searchTerm: _searchController.text);
                },
                decoration: InputDecoration(
                  hintText: AppStrings.searchWord,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  prefixIcon: BlocBuilder<SearchWordCubit, SearchWordState>(
                    builder: (context, state) {
                      return IconButton(disabledColor: ColorManager.primary,
                        splashRadius: 1,
                        color: ColorManager.primary,
                        onPressed: (state.searchTerm.isNotEmpty)
                            ? () {
                                {
                                  _searchController.clear();
                                  context.read<SearchWordCubit>().setSearchTerm(
                                      searchTerm: _searchController.text);
                                }
                              }
                            : null,
                        icon: Icon(
                          state.searchTerm.isNotEmpty
                              ? Icons.close
                              : Icons.search,
                        ),
                      );
                    },
                  ),
                  fillColor: ColorManager.grey,
                ),
              ),
            ),
          ],
        ));
  }
}
