import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greggs/features/products/domain/enums/day_part.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// {@template product}
/// Represents a Greggs product
/// {@endtemplate}
@freezed
class Product with _$Product {
  /// {@macro product}
  const factory Product({
    required String articleCode,
    required String shopCode,
    required String articleName,
    required DateTime availableFrom,
    required DateTime availableUntil,
    required num eatInPrice,
    required num eatOutPrice,
    required String internalDescription,
    required String customerDescription,
    required String imageUri,
    required String thumbnailUri,
    required List<DayPart> dayParts,
  }) = _Product;

  /// Creates a [Product] from a JSON object
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
