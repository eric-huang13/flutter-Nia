import 'package:flutter/foundation.dart';

class Result<T> {
  final T result;
  final String message;

  Result({
    @required this.result,
    @required this.message,
  });
}
