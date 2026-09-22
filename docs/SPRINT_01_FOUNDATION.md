# Sprint 1 — Foundation Shell

## Goal
Create the single visual/navigation shell that every later feature must use.

## Implemented
- Calm light design system with desaturated teal/blue brand gradient.
- White high-clarity surfaces and warm wood game previews.
- Shared spacing, radius and color tokens.
- Shared `AppScreenShell` with brand/surface tones.
- Shared five-destination bottom navigation.
- Top-level routes for Home, Friends, Rankings, Profile and Settings.
- Rankings/Profile use safe placeholder pages rather than dead taps.
- Home screen rebuilt as a clear 3/9/12 game selector.
- Game mode screen rebuilt as Online / Meydan Oku / Offline.
- Existing offline AI and same-device match entry points preserved.
- Continue-match card preserved.
- Existing localization architecture extended without hard-coded visible feature text.

## Acceptance criteria
- Home immediately communicates the three games.
- 9 Taş remains visually prominent without hiding 3 or 12 Taş.
- Top-level navigation is identical on Home/Friends/Rankings/Profile/Settings.
- Back navigation from game/mode screens uses the existing router contract.
- No nested vertical scrolling is introduced.
- No neon palette or reward/badge clutter is introduced.
- Offline AI remains reachable for all three games.
- Existing v0.4 AI and game engine files are not modified by this sprint.

## Next sprint
Sprint 2 verifies and freezes all 3/9/12 rule invariants, then Sprint 3 adds gameplay visual states: selected-piece glow, legal-target glow, capture-target glow and last-move indication.
