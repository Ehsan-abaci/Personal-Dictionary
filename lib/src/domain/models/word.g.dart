// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 1;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      id: fields[0] as String?,
      title: fields[1] as String,
      secMeaning: (fields[2] as List).cast<String>(),
      mainMeaning: (fields[3] as List).cast<String>(),
      mainExample: (fields[4] as List).cast<String>(),
      noun: fields[5] == null ? false : fields[5] as bool,
      adj: fields[6] == null ? false : fields[6] as bool,
      verb: fields[7] == null ? false : fields[7] as bool,
      adverb: fields[8] == null ? false : fields[8] as bool,
      phrases: fields[9] == null ? false : fields[9] as bool,
      isMarked: fields[10] == null ? false : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.secMeaning)
      ..writeByte(3)
      ..write(obj.mainMeaning)
      ..writeByte(4)
      ..write(obj.mainExample)
      ..writeByte(5)
      ..write(obj.noun)
      ..writeByte(6)
      ..write(obj.adj)
      ..writeByte(7)
      ..write(obj.verb)
      ..writeByte(8)
      ..write(obj.adverb)
      ..writeByte(9)
      ..write(obj.phrases)
      ..writeByte(10)
      ..write(obj.isMarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
