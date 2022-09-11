// ignore_for_file: file_names

class GetRequestException implements Exception {
  final String _message;

  GetRequestException(this._message);

  String toStringMessage() {
    return _message;
  }
}
