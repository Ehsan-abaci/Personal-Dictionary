import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/data/request/request.dart';

import '../../constant/functions.dart';
import '../../domain/repository/repository.dart';
part 'text_to_speech_event.dart';
part 'text_to_speech_state.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  final Repository _repository;
  TextToSpeechBloc(this._repository) : super(TextToSpeechState.initial()) {
    on<PlayAudioEvent>((event, emit) async {
      var appDirectory = await getApplicationDocumentsDirectory();
      final String text = event.text;
      final LanguageMode mode = event.mode;
      String lanSpeechMode = lanSpeech(mode);

      (await _repository.textToSpeech(TextToSpeechRequest(
        text: text,
        lanSpeech: lanSpeechMode,
      )))
          .fold(
        (failure){
            emit(state.copyWith(
            errorMessage: failure.message,
            status: ErrorStatus.error));
            showNotification(state.errorMessage);
            emit(state.copyWith(status: ErrorStatus.initial));
        },
        (data) async{
                 File audioFile = File("${appDirectory.path}/audio.mp3");
            await audioFile.writeAsBytes(data, flush: true);
            // Play the audio file using audioplayers
            final audioPlayer = AudioPlayer();
            await audioPlayer.setFilePath(audioFile.path);
            await audioPlayer.play();
        },
      );
    });
  }
}
