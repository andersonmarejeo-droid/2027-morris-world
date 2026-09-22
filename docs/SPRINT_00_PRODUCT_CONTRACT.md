# Sprint 0 — Product Contract

Status: FROZEN FOR IMPLEMENTATION

## Product identity
Morris World is one application containing three related strategy games: 3 Taş, 9 Taş and 12 Taş. They share one navigation model, one social system, one audio/motion language and one account.

## Visual direction
- Calm, clear and premium rather than colorful or neon.
- Board and pieces are the main visual focus.
- Surfaces use soft teal/blue backgrounds, white cards, warm wood and charcoal text.
- No badge, coin or notification clutter on core play screens.
- All primary actions must be obvious without tutorial text.

## Interaction contract
- One back-navigation policy across all games.
- One save/resume behavior across all offline games.
- One move-feedback vocabulary: select, valid target, capture target, mill, settle.
- One audio/haptic event vocabulary across 3/9/12 Taş.
- No feature screen may implement its own Scaffold, direct Navigator push, direct haptic or direct audio player.

## Gameplay clarity contract
During a match the player must always be able to identify:
1. whose turn it is,
2. which piece is selected,
3. which points are valid destinations,
4. whether a capture is required,
5. which opponent pieces may be captured,
6. what the last confirmed move was.

## Social contract
- "Meydan Oku" is the product term. "Özel Oda" is not used.
- Free-text chat is not part of the initial product.
- Quick messages are localized message IDs, not raw user text.
- Friends, world ranking and friend ranking use the same player identity.

## Localization contract
Every visible feature string must be localized. The application starts localization-ready and includes RTL-safe layout behavior.

## Quality gate
A sprint is not complete until analyze, unit/widget tests, architecture scan and critical regression checks are green.
