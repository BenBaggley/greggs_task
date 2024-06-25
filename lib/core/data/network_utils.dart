import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/core/extensions/dio_error_failure.dart';

/// Wrapper for [Dio] calls, catching [DioException] and converting them to [Failure]
Future<Either<Failure, T>> catchFailure<T>(Future<T> Function() call) async {
  try {
    return right(await call());
  } on DioException catch (e) {
    return left(e.asFailure);
  }
}
