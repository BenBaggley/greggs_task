import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greggs/features/basket/application/cubit/basket_cubit.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/presentation/widgets/basket_item_widget.dart';
import 'package:greggs/l10n/l10n.dart';
import 'package:intl/intl.dart';

/// {@template basket_page}
/// Page that displays the current basket
/// {@endtemplate}
class BasketPageWidget extends StatefulWidget {
  /// {@macro basket_page}
  const BasketPageWidget({Key? key}) : super(key: key);

  @override
  State<BasketPageWidget> createState() => _BasketPageWidgetState();
}

class _BasketPageWidgetState extends State<BasketPageWidget> {
  final dialogKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BasketCubit>();
      if (cubit.state is! BasketData) {
        cubit.loadBasket();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        centerTitle: true,
      ),
      body: BlocConsumer<BasketCubit, BasketState>(
        listener: (context, state) {
          state.maybeWhen(
            failure: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            ),
            updating: () => showUpdating(context),
            data: (_, __) => dismissUpdating(),
            orElse: () {},
          );
        },
        buildWhen: (_, state) =>
            state is! BasketFailure && state is! BasketUpdating,
        builder: (context, state) {
          return state.maybeWhen(
            initial: () => const SizedBox(),
            loading: () => buildLoading(context),
            data: (items, total) => buildBasket(context, items, total),
            orElse: () => throw FallThroughError(),
          );
        },
      ),
    );
  }

  void showUpdating(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator.adaptive(
          key: dialogKey,
        ),
      ),
    );
  }

  void dismissUpdating() {
    if (dialogKey.currentState != null) {
      Navigator.of(context).pop();
    }
  }

  Widget buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget buildBasket(
    BuildContext context,
    List<BasketItem> items,
    num totalPrice,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return BasketItemWidget(
                item: items[index],
                onRemoveFromBasket: (item) =>
                    context.read<BasketCubit>().removeFromBasket(item),
              );
            },
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.onSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.basketTotal,
                  style: GoogleFonts.barlow(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberFormat.currency(symbol: '£').format(totalPrice),
                  style: GoogleFonts.barlow(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
