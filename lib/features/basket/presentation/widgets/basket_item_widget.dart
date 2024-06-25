import 'package:flutter/material.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/l10n/l10n.dart';
import 'package:intl/intl.dart';

/// {@template product_item}
/// List item for a product
/// {@endtemplate}
class BasketItemWidget extends StatefulWidget {
  /// {@macro product_item}
  const BasketItemWidget({
    super.key,
    required this.item,
    required this.onRemoveFromBasket,
  });

  /// The item to display
  final BasketItem item;

  /// The callback to remove the item to the basket
  final Function(BasketItem item) onRemoveFromBasket;

  @override
  State<BasketItemWidget> createState() => _BasketItemWidgetState();
}

class _BasketItemWidgetState extends State<BasketItemWidget> {
  BasketItem get item => widget.item;

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
                  item.product.thumbnailUri,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.product.articleName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  '${item.quantity} x ${NumberFormat.currency(symbol: '£').format(item.product.eatOutPrice)}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ElevatedButton(
                onPressed: () => widget.onRemoveFromBasket(item),
                child: Text(context.l10n.removeFromBasket),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
