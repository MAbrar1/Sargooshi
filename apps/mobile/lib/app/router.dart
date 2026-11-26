import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/welcome_screen.dart';
import '../debug/component_gallery_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final routes = <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    if (kDebugMode)
      GoRoute(
        path: '/debug/gallery',
        builder: (context, state) => const DebugComponentGalleryScreen(),
      ),
  ];

  final router = GoRouter(
    initialLocation: '/',
    routes: routes,
  );

  ref.onDispose(router.dispose);
  return router;
});
