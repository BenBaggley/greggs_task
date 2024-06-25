import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:greggs/core/data/basket_storage.dart';
import 'package:greggs/features/basket/application/cubit/basket_cubit.dart';
import 'package:greggs/features/products/application/cubit/cubit/products_cubit.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/presentation/widgets/product_item_widget.dart';
import 'package:greggs/l10n/l10n.dart';

/// {@template products_page}
/// Page that displays a list of products
/// {@endtemplate}
class ProductsPageWidget extends StatefulWidget {
  /// {@macro products_page}
  const ProductsPageWidget({super.key});

  @override
  State<ProductsPageWidget> createState() => _ProductsPageWidgetState();
}

class _ProductsPageWidgetState extends State<ProductsPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: GetIt.I<BasketStorage>().itemCount,
            builder: (context, value, _) {
              return Container(
                padding: const EdgeInsets.only(),
                width: MediaQuery.of(context).textScaler.scale(32),
                alignment: Alignment.centerRight,
                child: Text(
                  value > 99 ? '99+' : value.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => GoRouter.of(context).push('/basket'),
          ),
        ],
      ),
      body: BlocProvider<ProductsCubit>(
        create: (_) => GetIt.I()..loadProducts(),
        child: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            state.maybeWhen(
              failure: (message) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              ),
              orElse: () {},
            );
          },
          buildWhen: (_, state) => state is! ProductsFailure,
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const SizedBox(),
              loading: () => buildLoading(context),
              data: (products) => buildProducts(context, products),
              orElse: () => throw UnimplementedError(),
            );
          },
        ),
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget buildProducts(BuildContext context, List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductItemWidget(
          product: products[index],
          onAddToBasket: (product) =>
              context.read<BasketCubit>().addToBasket(product),
        );
      },
    );
  }
}
