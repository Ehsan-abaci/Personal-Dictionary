// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'word.g.dart';

var uuid = const Uuid();

enum Filter {
  verb,
  noun,
  adjective,
  adverb,
  phrases,
}

enum Limit {
  all,
  marked,
}

@HiveType(typeId: 1)
class Word {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  List<String> secMeaning;
  @HiveField(3)
  List<String> mainMeaning;
  @HiveField(4)
  List<String> mainExample;
  @HiveField(5, defaultValue: false)
  bool noun;
  @HiveField(6, defaultValue: false)
  bool adj;
  @HiveField(7, defaultValue: false)
  bool verb;
  @HiveField(8, defaultValue: false)
  bool adverb;
  @HiveField(9, defaultValue: false)
  bool phrases;
  @HiveField(10, defaultValue: false)
  bool isMarked;
  Word({
    String? id,
    required this.title,
    this.secMeaning = const [],
    this.mainMeaning = const [],
    this.mainExample = const [],
    this.noun = false,
    this.adj = false,
    this.verb = false,
    this.adverb = false,
    this.phrases = false,
    this.isMarked = false,
  }) : id = id ?? uuid.v4();

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json["id"],
      title: json["title"],
      secMeaning: (json["secMeaning"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      mainMeaning: (json["mainMeaning"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      mainExample: (json["mainExample"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      noun: json["noun"],
      adj: json["adj"],
      adverb: json["adverb"],
      phrases: json["phrases"],
      verb: json["verb"],
      isMarked: json["isMarked"],
    );
  }
  Map<String, dynamic> toJson(Word instance) {
    return {
      "id": instance.id,
      "title": instance.title,
      "secMeaning": instance.secMeaning,
      "mainMeaning": instance.mainMeaning,
      "mainExample": instance.mainExample,
      "noun": instance.noun,
      "adj": instance.adj,
      "verb": instance.verb,
      "adverb": instance.adverb,
      "phrases": instance.phrases,
      "isMarked": instance.isMarked,
    };
  }

  Word copyWith({
    String? id,
    String? title,
    List<String>? secMeaning,
    List<String>? mainMeaning,
    List<String>? mainExample,
    bool? noun,
    bool? adj,
    bool? verb,
    bool? adverb,
    bool? phrases,
    bool? isMarked,
  }) {
    return Word(
      id: id ?? this.id,
      title: title ?? this.title,
      secMeaning: secMeaning ?? this.secMeaning,
      mainMeaning: mainMeaning ?? this.mainMeaning,
      mainExample: mainExample ?? this.mainExample,
      noun: noun ?? this.noun,
      adj: adj ?? this.adj,
      verb: verb ?? this.verb,
      adverb: adverb ?? this.adverb,
      phrases: phrases ?? this.phrases,
      isMarked: isMarked ?? this.isMarked,
    );
  }
}
