

import 'package:your_dictionary/src/data/network/failure.dart';

enum DataSource {
  SUCCESS,
  NO_INTERNET_CONNECTION,
  DEEFAULT,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEEFAULT:
        return Failure(ResponseCode.UNKNOWN, ResponseMessage.UNKNOWN);
      default:
        return Failure(ResponseCode.UNKNOWN, ResponseMessage.UNKNOWN);
    }
  }
}

class ResponseCode {
  // Api status code
  static const int SUCCESS = 200;
  // local status code
  static const int UNKNOWN = -1;
  static const int NO_INTERNET_CONNECTION = -7;
}

class ResponseMessage {
  // Api status code
  static const String SUCCESS = "success";
  // local status code
  static const String UNKNOWN = "Some thing went wrong, try again";
  static const String NO_INTERNET_CONNECTION = "Please check your connection";
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
