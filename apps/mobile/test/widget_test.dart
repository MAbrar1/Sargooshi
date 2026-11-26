import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sargoshi/app/sargoshi_app.dart';
void main() { testWidgets('welcome screen shows brand and tagline', (tester) async { await tester.pumpWidget(const ProviderScope(child:SargoshiApp())); expect(find.text('Sargoshi'),findsOneWidget); expect(find.text('Say it softly.'),findsOneWidget); expect(find.text('Private by design'),findsOneWidget); }); }
