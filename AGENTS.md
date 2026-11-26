# Sargoshi Engineering Constitution

Sargoshi is a private Android messaging product. The supplied v5 blueprint, machine-readable spec and phase prompts are authoritative and must be imported into this repository before claiming specification fidelity.

## Honesty and quality
- Build real functionality; no production mocks, stubs, placeholder controls or fabricated data.
- Never claim tests/builds/gates ran unless they were actually executed.
- Do not implement cryptographic primitives yourself; use maintained, vetted dependencies. Require independent cryptographic review before public release.
- Keep secrets, plaintext messages and cryptographic material out of logs and commits.
- Keep English and Urdu localization, accessibility, RTL, responsive layouts and privacy central.
- Follow phase order, record progress and decisions, and run gates before phase transitions.
- Verify every dependency's current APIs, maintenance, age, license and security status before pinning.

## Session ritual
1. Read this file, progress ledger and active phase prompt.
2. Check open ledger rows and determine next slice.
3. Implement a vertical slice, tests and documentation; avoid broad unverified changes.
4. Run available checks and report exact results, failures and environment limitations.
5. Update progress before stopping.

## Initial phase
P00 repository bootstrap and environment validation; P01 Flutter design system and app shell; P02 crypto core; then gateway, data, messaging and remaining roadmap phases. Consult the blueprint and prompts when they are present.
