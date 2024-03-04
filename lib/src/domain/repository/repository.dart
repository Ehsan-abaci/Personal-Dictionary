

import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:your_dictionary/src/data/network/failure.dart';
import 'package:your_dictionary/src/data/request/request.dart';

abstract class Repository{
  Future<Either<Failure,Uint8List>> textToSpeech(TextToSpeechRequest textToSpeechRequest);
}