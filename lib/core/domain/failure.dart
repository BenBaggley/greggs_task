// coverage:ignore-file

import 'package:flutter/foundation.dart';

/// Represents an error which should be handled
@immutable
class Failure {
  /// Creates a [Failure]
  const Failure({required this.message, this.code});

  /// A human-readable error message
  final String message;

  /// A code used to uniquely identify this error
  final int? code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}
