class ApiRequest {
  final bool error;
  final String data;

  ApiRequest({required this.error, required this.data});
}

class ApiMsg {
  static const String badRequest = 'Invalid request. Please check your input: ';
  static const String unAuthorized =
      'Authentication failed. Please check your credentials.';
  static const String forbidden =
      'Access forbidden. You do not have permission to perform this action.';
  static const String notFound =
      'Resource not found. Please check the requested endpoint.';
  static const String internalServerError =
      'Oops! Something went wrong on the server. Please try again later.';
  static const String externalServerError =
      'Failed to connect to the server. Please check your internet connection or try again later.';
  static const String defaultError = 'Request failed with status:';
}
