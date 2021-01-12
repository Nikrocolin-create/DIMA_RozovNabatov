class ServiceUnavailableException implements Exception {
  
  final _message;
  
  ServiceUnavailableException([this._message]);

  String _toString() {
    if (_message != null) 
      return "Exception $_message"; 
  }
}