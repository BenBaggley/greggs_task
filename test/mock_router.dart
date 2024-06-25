import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockRouter extends Mock implements GoRouter {}

class MockRouterProvider extends StatelessWidget {
  const MockRouterProvider({
    required this.goRouter,
    required this.child,
    super.key,
  });

  /// The mock router used to mock navigation calls.
  final MockRouter goRouter;

  /// The child [Widget] to render.
  final Widget child;

  @override
  Widget build(BuildContext context) => InheritedGoRouter(
        goRouter: goRouter,
        child: child,
      );
}
