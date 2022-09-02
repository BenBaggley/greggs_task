import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greggs/features/products/domain/entities/product.dart';

part 'basket_item.freezed.dart';
part 'basket_item.g.dart';

/// {@template basket_item}
/// Represents an item in a basket
/// {@endtemplate}
@freezed
class BasketItem with _$BasketItem {
  /// {@macro basket_item}
  const factory BasketItem({
    required String articleCode,
    required int quantity,
    required Product product,
  }) = _BasketItem;

  /// Creates a [BasketItem] from a JSON object
  factory BasketItem.fromJson(Map<String, dynamic> json) =>
      _$BasketItemFromJson(json);
}
