class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException()
    : super('No internet connection. Please check your network.');
}

class TimeoutException extends ApiException {
  const TimeoutException()
    : super('The request took too long. Please try again.');
}

class ServerException extends ApiException {
  const ServerException({super.statusCode})
    : super('Something went wrong on the server. Please try again.');
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.statusCode});
}
