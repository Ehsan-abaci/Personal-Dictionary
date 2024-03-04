import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:your_dictionary/src/constant/constant_key.dart';
import 'package:your_dictionary/src/domain/models/word.dart';
import 'package:your_dictionary/src/presentation/resources/strings_manager.dart';
import '../bloc/word/word_bloc.dart';

List<String> numberOfType(Word val) {
  List<String> list = [];
  if (val.noun == true) list.add("noun");
  if (val.adj == true) list.add("adjective");
  if (val.adverb == true) list.add("adverb");
  if (val.verb == true) list.add("verb");
  if (val.phrases == true) list.add("phrases");
  return list;
}

String getStringLanguageMode(LanguageMode mode) {
  switch (mode) {
    case LanguageMode.En_Fa:
      return EN_FA_BOX;
    case LanguageMode.De_En:
      return DE_EN_BOX;
    case LanguageMode.De_Fa:
      return DE_FA_BOX;
  }
}

LanguageMode getLanguageMode(String mode) {
  switch (mode) {
    case "En_Fa":
      return LanguageMode.En_Fa;
    case "De_En":
      return LanguageMode.De_En;
    case "De_Fa":
      return LanguageMode.De_Fa;
    default:
      return LanguageMode.En_Fa;
  }
}

enum Order {
  main,
  second,
}

extension getMode on List<String> {
  String set(Order order) {
    switch (order) {
      case Order.main:
        return this[0];
      case Order.second:
        return this[1];
    }
  }
}

List<String> getDefText(LanguageMode mode) {
  switch (mode) {
    case LanguageMode.En_Fa:
      return [AppStrings.englishDef, AppStrings.persianDef];
    case LanguageMode.De_En:
      return [AppStrings.deutschDef, AppStrings.englishDef];
    case LanguageMode.De_Fa:
      return [AppStrings.deutschDef, AppStrings.persianDef];
  }
}

List<String> getAddDefText(LanguageMode mode) {
  switch (mode) {
    case LanguageMode.En_Fa:
      return [AppStrings.addEnDef, AppStrings.addFaDef];
    case LanguageMode.De_En:
      return [AppStrings.addDeDef, AppStrings.addEnDef];
    case LanguageMode.De_Fa:
      return [AppStrings.addDeDef, AppStrings.addFaDef];
  }
}

List<String> getEmptyDefText(LanguageMode mode) {
  switch (mode) {
    case LanguageMode.En_Fa:
      return [AppStrings.emptyEnDef, AppStrings.emptyFaDef];
    case LanguageMode.De_En:
      return [AppStrings.emptyDeDef, AppStrings.emptyEnDef];
    case LanguageMode.De_Fa:
      return [AppStrings.emptyDeDef, AppStrings.emptyFaDef];
  }
}

String lanSpeech(LanguageMode mode) {
  switch (mode) {
    case LanguageMode.En_Fa:
      return "en-us";
    case LanguageMode.De_En:
      return "de-de";
    case LanguageMode.De_Fa:
      return "de-de";
  }
}

void showNotification(String? message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message ?? "",
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.grey.shade700,
    fontSize: 14,
  );
}
