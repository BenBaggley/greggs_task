// coverage:ignore-file

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/products/domain/entities/product.dart';

/// {@template basket_storage}
/// Storage for the basket
/// {@endtemplate}
class BasketStorage {
  /// {@macro basket_storage}
  BasketStorage(this._storage) {
    _updateItemCount();
    _storage.listen(() {
      _updateItemCount();
    });
  }

  final GetStorage _storage;

  /// The count of items in the basket
  final itemCount = ValueNotifier(0);

  void _updateItemCount() {
    itemCount.value = getBasket()
        .map(
          (i) => i.quantity,
        )
        .fold(0, (a, b) => a + b);
  }

  /// Gets the basket from storage
  List<BasketItem> getBasket() {
    final values = _storage.getValues<Iterable>();
    return values.map((v) => BasketItem.fromJson(v)).toList();
  }

  /// Adds a product to the basket
  void addProduct(Product product) {
    final json = _storage.read<Map<String, dynamic>>(product.articleCode);
    var item = json == null ? null : BasketItem.fromJson(json);

    if (item != null) {
      item = item.copyWith(
        quantity: item.quantity + 1,
      );
    } else {
      item = BasketItem(
        articleCode: product.articleCode,
        quantity: 1,
        product: product,
      );
    }
    _storage.write(product.articleCode, item.toJson());
  }

  /// Removes a product from the basket
  void removeProduct(Product product) {
    _storage.remove(product.articleCode);
  }
}
