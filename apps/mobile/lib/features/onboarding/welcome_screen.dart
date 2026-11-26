import 'package:flutter/material.dart';

import '../../core/theme/generated/sargoshi_tokens.g.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/sg_icon.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<SargoshiColors>()!;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SargoshiSpace.s24,
                      vertical: SargoshiSpace.s40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: colors.dusk,
                            borderRadius: BorderRadius.circular(
                              SargoshiShape.card,
                            ),
                            border: Border.all(color: colors.line),
                          ),
                          alignment: Alignment.center,
                          child: SgIcon(
                            SgIconName.chats,
                            size: 38,
                            color: colors.glow,
                          ),
                        ),
                        const SizedBox(height: SargoshiSpace.s32),
                        Text(
                          localizations.appTitle,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: SargoshiSpace.s8),
                        Text(
                          localizations.brandTagline,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: colors.glow,
                              ),
                        ),
                        const SizedBox(height: SargoshiSpace.s32),
                        _WelcomePrinciple(
                          icon: SgIconName.privateLock,
                          message: localizations.copyWelcome1,
                        ),
                        const SizedBox(height: SargoshiSpace.s16),
                        _WelcomePrinciple(
                          icon: SgIconName.translate,
                          message: localizations.copyWelcome2,
                        ),
                        const SizedBox(height: SargoshiSpace.s16),
                        _WelcomePrinciple(
                          icon: SgIconName.contacts,
                          message: localizations.copyWelcome3,
                        ),
                        const SizedBox(height: SargoshiSpace.s24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomePrinciple extends StatelessWidget {
  const _WelcomePrinciple({
    required this.icon,
    required this.message,
  });

  final SgIconName icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SargoshiColors>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SargoshiSpace.s16),
      decoration: BoxDecoration(
        color: colors.dusk,
        borderRadius: BorderRadius.circular(SargoshiShape.card),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: SargoshiSpace.s4),
            child: SgIcon(
              icon,
              size: 22,
              color: colors.mint,
            ),
          ),
          const SizedBox(width: SargoshiSpace.s12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
