part of 'products_cubit.dart';

/// States for the products feature
@freezed
class ProductsState with _$ProductsState {
  /// Initial state
  const factory ProductsState.initial() = ProductsInitial;

  /// Loading state
  const factory ProductsState.loading() = ProductsLoading;

  /// Loaded state
  const factory ProductsState.data(List<Product> products) = ProductsData;

  /// Error state
  const factory ProductsState.failure(String message) = ProductsFailure;
}
