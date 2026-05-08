abstract class BaseRepository {
  Future<ApiResponse<T>> guard<T>(Future<T> Function() action) async {
    try {
      return ApiResponse.success(data: await action());
    } catch (error) {
      return ApiResponse.error(message: error.toString());
    }
  }
}

class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;

  ApiResponse._({this.data, this.message, required this.success});

  factory ApiResponse.success({T? data}) =>
      ApiResponse._(data: data, success: true);

  factory ApiResponse.error({required String message}) =>
      ApiResponse._(message: message, success: false);
}
