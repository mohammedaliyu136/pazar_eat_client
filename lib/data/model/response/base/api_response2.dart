import 'package:dio/dio.dart';

class FireBaseResponse {
  final response;
  final dynamic error;
  final int responseCode;

  FireBaseResponse(this.response, this.error, this.responseCode);

  FireBaseResponse.withError(dynamic errorValue)
      : response = null,
        responseCode = 404,
        error = errorValue;

  FireBaseResponse.withSuccess(responseValue)
      : response = responseValue,
        responseCode = 200,
        error = null;
}
