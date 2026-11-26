import 'package:go_router/go_router.dart';
import '../features/onboarding/welcome_screen.dart';
final appRouterProvider = _router;
final GoRouter _router = GoRouter(initialLocation: '/', routes: [GoRoute(path: '/', builder: (context, state) => const WelcomeScreen())]);
