# External dependencies and blockers

## Native Urdu review — P01 / LOC-01

- **Feature:** English and Urdu localization, RTL directionality, and Urdu typography.
- **Owner action:** Have a native Urdu reviewer review `apps/mobile/lib/l10n/app_ur.arb` and the final on-device strings at normal and 200% text size.
- **Reason:** The initial Urdu strings are a draft and are explicitly marked for review in the ARB metadata. Do not claim native-language approval until the review is completed.
- **Status:** OPEN — review has not been supplied.

## Cryptography and privacy release reviews

- Independent cryptographic protocol and implementation review is required before public release.
- Privacy policy, retention, app store disclosures, and Pakistan/global legal review require owner and qualified third-party input.
- No production cryptographic or account backend is implemented yet.

## Credential-dependent integrations

No credential-dependent third-party service integrations are implemented. Record external service, feature ID, reason, required owner action and status here as relevant.
