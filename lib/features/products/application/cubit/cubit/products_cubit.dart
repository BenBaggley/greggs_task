import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/domain/use_cases/get_products.dart';
import 'package:injectable/injectable.dart';

part 'products_state.dart';
part 'products_cubit.freezed.dart';

/// {@template products_cubit}
/// Cubit for the products feature, handling state management
/// {@endtemplate}
@injectable
class ProductsCubit extends Cubit<ProductsState> {
  /// {@macro products_cubit}
  ProductsCubit(
    this._getProducts,
  ) : super(const ProductsState.initial());

  final GetProducts _getProducts;

  /// Loads the products
  Future<void> loadProducts() async {
    emit(const ProductsState.loading());

    final result = await _getProducts();

    result.fold(
      (failure) => emit(ProductsState.failure(failure.message)),
      (products) => emit(ProductsState.data(products)),
    );
  }
}
