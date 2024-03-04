// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:http/http.dart';
import 'package:your_dictionary/src/data/network/app_api.dart';

import '../request/request.dart';

abstract class RemoteDataSource{
  Future<Response> textToSpeech(TextToSpeechRequest textToSpeechRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource {
 final AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(
     this._appServiceClient,
  );
  @override
  Future<Response> textToSpeech(TextToSpeechRequest textToSpeechRequest) {
   return _appServiceClient.textToSpeech(textToSpeechRequest);
  }
  
}
