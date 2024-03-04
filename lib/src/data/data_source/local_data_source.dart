// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/domain/models/word.dart';

const String LANGUAGE_MODE_KEY = "LANGUAGE_MODE";

abstract class LocalDataSource {

  void addToWordBox(String box,Word word);
  List<Word> fetchWords(String box);
  Word fetchWordById(String box,String id);
  void removeWord(String box,int index);
  Future<void> updateWord(String box,int index,Word updatedWord);
  Future<void> saveLanguageMode(LanguageMode languageMode);
  Future<String?> getPrefLanguageMode();
}

class LocalDataSourceImpl implements LocalDataSource {
 final SharedPreferences _sharedPreferences;

  LocalDataSourceImpl(
    this._sharedPreferences,
  );

  @override
  Future<void> saveLanguageMode(LanguageMode languageMode) async {
    await _sharedPreferences.setString(LANGUAGE_MODE_KEY, languageMode.name);
  }
  @override
  Future<String?> getPrefLanguageMode() async {
  return _sharedPreferences.getString(LANGUAGE_MODE_KEY);
}

  @override
  void addToWordBox(String box,Word word) async{
     Box<Word>  wordBox = Hive.box(box);
    await wordBox.add(word);
  }

  @override
  List<Word> fetchWords(String box) {
    Box<Word>  wordBox = Hive.box(box);
    return wordBox.values.toList();
  }

  @override
  void removeWord(String box,int index) {
    Box<Word>  wordBox = Hive.box(box);
    wordBox.deleteAt(index);
  }

  @override
  Future<void> updateWord(String box, int index,Word updatedWord) async{
    Box<Word>  wordBox = Hive.box(box);
    await wordBox.putAt(index, updatedWord);
  }
  
  @override
  Word fetchWordById(String box,String id) {
    Box<Word>  wordBox = Hive.box(box);
    return wordBox.values.firstWhere((e) => e.id == id ,);
  }
}
