import 'package:go_router/go_router.dart';
import 'package:greggs/features/basket/presentation/pages/basket_page_widget.dart';
import 'package:greggs/features/products/presentation/pages/products_page_widget.dart';

/// Routes for the app
List<GoRoute> get appRoutes => [
      GoRoute(
        path: '/',
        builder: ((_, __) => const ProductsPageWidget()),
      ),
      GoRoute(
        path: '/basket',
        builder: ((_, __) => const BasketPageWidget()),
      ),
    ];
