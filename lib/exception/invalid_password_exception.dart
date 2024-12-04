class InvalidPasswordException implements Exception {
  String cause;
  InvalidPasswordException(this.cause);

    @override
  String toString() {
    return "CustomException: $cause";
  }
}