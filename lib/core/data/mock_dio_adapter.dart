// coverage:ignore-file

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:greggs/core/data/basket_storage.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// {@template mock_dio_adapter}
/// [DioAdapter] that mocks API responses
/// {@endtemplate}
class MockDioAdapter extends DioAdapter {
  /// {@macro mock_dio_adapter}
  MockDioAdapter(this._storage, {required super.dio});

  final BasketStorage _storage;
  late final Product _product;

  /// Initializes the adapter
  Future<void> init() async {
    final json = await rootBundle.loadString('assets/products.json');
    _product = Product.fromJson((jsonDecode(json) as List).first);

    onGet(
      '/products',
      (server) => server.reply(
        200,
        jsonDecode(json),
        delay: const Duration(seconds: 1),
      ),
    );
  }

  /// Mock the response for getting the basket
  void mockGet() {
    onGet(
      '/basket',
      (server) => server.reply(
        200,
        _storage.getBasket().map((i) => i.toJson()).toList(),
        delay: const Duration(seconds: 1),
      ),
    );
  }

  /// Mock the response for adding an item to the basket
  void mockPut() {
    onPut('/basket', (server) {
      _storage.addProduct(_product);
      return server.reply(
        200,
        _storage.getBasket().map((i) => i.toJson()).toList(),
        delay: const Duration(seconds: 1),
      );
    });
  }

  /// Mock the response for removing an item from the basket
  void mockDelete() {
    onDelete('/basket', (server) {
      _storage.removeProduct(_product);
      return server.reply(
        200,
        _storage.getBasket().map((i) => i.toJson()).toList(),
        delay: const Duration(seconds: 1),
      );
    });
  }
}
