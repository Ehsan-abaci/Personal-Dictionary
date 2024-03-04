import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:your_dictionary/src/data/data_source/local_data_source.dart';
import 'package:your_dictionary/src/data/data_source/remote_data_source.dart';
import 'package:your_dictionary/src/data/network/network_info.dart';
import 'package:your_dictionary/src/data/request/request.dart';
import 'package:your_dictionary/src/domain/repository/repository.dart';

import '../network/error_handler.dart';
import '../network/failure.dart';

class RepositoryImpl implements Repository {
  final NetworkInfo _networkInfo;
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  RepositoryImpl(
      this._networkInfo, this._remoteDataSource, this._localDataSource);
  @override
  Future<Either<Failure, Uint8List>> textToSpeech(
      TextToSpeechRequest textToSpeechRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.textToSpeech(textToSpeechRequest);
        if (response.statusCode == 200) {
          return Right(response.bodyBytes);
        } else {
          return Left(DataSource.DEEFAULT.getFailure());
        }
      } catch (e) {
         return Left(DataSource.DEEFAULT.getFailure());
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
