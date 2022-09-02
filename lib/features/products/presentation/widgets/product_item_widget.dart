import 'package:flutter/material.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/l10n/l10n.dart';
import 'package:intl/intl.dart';

/// {@template product_item}
/// List item for a product
/// {@endtemplate}
class ProductItemWidget extends StatefulWidget {
  /// {@macro product_item}
  const ProductItemWidget({
    Key? key,
    required this.product,
    required this.onAddToBasket,
  }) : super(key: key);

  /// The product to display
  final Product product;

  /// The callback to add the product to the basket
  final Function(Product product) onAddToBasket;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  Product get product => widget.product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.network(
                  product.thumbnailUri,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    product.articleName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Text(
                  NumberFormat.currency(symbol: '£')
                      .format(product.eatOutPrice),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.customerDescription,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.onAddToBasket(product),
                    child: Text(context.l10n.addToBasketButton),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
