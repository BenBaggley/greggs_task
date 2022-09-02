// ignore_for_file: public_member_api_docs
// coverage:ignore-file
import 'package:get_storage/get_storage.dart';
import 'package:greggs/core/data/basket_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class StorageModule {
  Future<GetStorage> _getStorage() async {
    await GetStorage.init('basket_storage');
    return GetStorage('basket_storage');
  }

  @preResolve
  @singleton
  Future<BasketStorage> getBasketStorage() async {
    final storage = await _getStorage();
    return BasketStorage(storage);
  }
}
