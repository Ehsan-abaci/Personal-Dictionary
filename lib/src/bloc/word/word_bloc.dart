// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:your_dictionary/src/constant/functions.dart';
import 'package:your_dictionary/src/data/data_source/local_data_source.dart';
import '../../domain/models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  LanguageMode mode;
  final LocalDataSource _localDataSource;

    Word fetchWordByIdEvent(String id) {
      var box = getStringLanguageMode(state.mode);
      return _localDataSource.fetchWordById(box, id);
    }
  WordBloc(this._localDataSource, {required this.mode})
      : super(WordState.initial(mode)) {
    on<ChangeLanguageModeEvent>((event, emit) async {
      await _localDataSource.saveLanguageMode(event.mode);
      emit(state.copyWith(mode: event.mode));
      add(FetchWordsEvent());
    });
    on<AddWordEvent>((event, emit) async {
      var box = getStringLanguageMode(state.mode);
      Word wordData = Word(
        title: event.wordData.title,
        secMeaning: event.wordData.secMeaning,
        mainMeaning: event.wordData.mainMeaning,
        mainExample: event.wordData.mainExample,
        noun: event.wordData.noun,
        verb: event.wordData.verb,
        adj: event.wordData.adj,
        adverb: event.wordData.adverb,
        phrases: event.wordData.phrases,
        isMarked: event.wordData.isMarked,
      );
      _localDataSource.addToWordBox(box, wordData);
      emit(state.copyWith(wordList: state.wordList..add(wordData)));
    });
    on<FetchWordsEvent>((event, emit) {
      var box = getStringLanguageMode(state.mode);
      List<Word> fetchData = _localDataSource.fetchWords(box);
      emit(state.copyWith(wordList: fetchData));
    });

  

    on<RemoveWordEvent>((event, emit) {
      var box = getStringLanguageMode(state.mode);
      int index = state.wordList.indexWhere((word) => word.id == event.id);
      _localDataSource.removeWord(box, index);
      List<Word> word = state.wordList
        ..removeWhere((element) => element.id == event.id);
      emit(state.copyWith(wordList: word));
    });

    on<UpdateWordEvent>((event, emit) async {
      var box = getStringLanguageMode(state.mode);
      int index = state.wordList.indexWhere((word) => word.id == event.id);
      state.wordList.removeAt(index);
      state.wordList.insert(index, event.updatedWord);
      emit(state.copyWith(wordList: state.wordList));
      await _localDataSource.updateWord(box, index, event.updatedWord);
    });
    on<AddToMarkedWordsEvent>((event, emit) async {
      var box = getStringLanguageMode(state.mode);
      int index = state.wordList.indexWhere((word) => word.id == event.id);
      Word updatedWord = state.wordList.firstWhere((e) => e.id == event.id);
      updatedWord.isMarked = !updatedWord.isMarked;
      state.wordList.removeAt(index);
      state.wordList.insert(index, updatedWord);
    await _localDataSource.updateWord(box, index, updatedWord);
      emit(state.copyWith(wordList: state.wordList));
    });
    on<ExportDataEvent>((event, emit) {
      try {
        List<Map<String, dynamic>> data = [];
        for (var word in state.wordList) {
          data.add(word.toJson(word));
        }
        event.exportFile.writeAsStringSync(jsonEncode(data),
            mode: FileMode.writeOnly, flush: true);
        String? message = "Saved at: ${event.exportFile.path}";
        showNotification(message);
      } catch (e) {
        print(e);
      }
    });
    on<ImportDataEvent>((event, emit) {
      String? message;
      try {
        String fileContents = event.importFile.readAsStringSync();
        List<dynamic> readData = jsonDecode(fileContents);
        for (var word in readData) {
          add(AddWordEvent(wordData: Word.fromJson(word)));
        }
        message = "Importing was successful";
        showNotification(message);
      } catch (e) {
        message = "Importing was not successful";
        showNotification(message);
      }
    });
  }
}
