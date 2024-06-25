// ignore_for_file:public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greggs/app/app.config.dart';
import 'package:greggs/app/routes.dart';
import 'package:greggs/features/basket/application/cubit/basket_cubit.dart';
import 'package:greggs/l10n/l10n.dart';
import 'package:injectable/injectable.dart';

part 'app_theme.dart';
part 'colors.dart';

class GreggsChallenge extends StatefulWidget {
  const GreggsChallenge({super.key});

  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializeDependencies();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const GreggsChallenge());
  }

  @override
  State<GreggsChallenge> createState() => _GreggsChallengeState();
}

class _GreggsChallengeState extends State<GreggsChallenge> {
  final router = GoRouter(routes: appRoutes);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      theme: buildTheme(ThemeData.light()),
      darkTheme: buildTheme(ThemeData.dark()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        return BlocProvider<BasketCubit>(
          create: (_) => GetIt.I(),
          child: child,
        );
      },
    );
  }
}

@injectableInit
Future<void> _initializeDependencies() => GetIt.I.init();
