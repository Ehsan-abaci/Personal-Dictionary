// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_bloc.dart';

class WordEvent {}

class AddWordEvent extends WordEvent {
  Word wordData;
  AddWordEvent({
    required this.wordData,
  });
}

class AddMultiWordsEvent extends WordEvent {
  List<Word> wordsData;
  AddMultiWordsEvent({
    required this.wordsData,
  });
}

class FetchWordsEvent extends WordEvent {}

class ResetDataEvent extends WordEvent {}

class RemoveWordEvent extends WordEvent {
  String id;
  RemoveWordEvent({
    required this.id,
  });
}

class UpdateWordEvent extends WordEvent {
  String id;
  Word updatedWord;
  UpdateWordEvent({
    required this.id,
    required this.updatedWord,
  });
}

class AddToMarkedWordsEvent extends WordEvent {
  String id;
  AddToMarkedWordsEvent({
    required this.id,
  });
}

class ChangeLanguageModeEvent extends WordEvent {
  LanguageMode mode;
  ChangeLanguageModeEvent({
    required this.mode,
  });
}

class ExportDataEvent extends WordEvent {
  File exportFile;

  ExportDataEvent({required this.exportFile});
}

class ImportDataEvent extends WordEvent {
  File importFile;

  ImportDataEvent({required this.importFile});
}
