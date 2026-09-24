# Morris World — Visual Quality Sprint (50 steps)

## Goal and boundary

This sprint turns the visual audit into concrete product work. The target is a
calm, tactile, trustworthy board-game product rather than a generic,
AI-generated-looking mobile interface. Offline game play remains the product
baseline. Firebase, authentication, live matchmaking, and production ranking
data are deliberately not enabled here; those screens must state their status
plainly until the service is real.

Status key: **Done** is implemented and verified in the client; **In progress**
is being integrated in this sprint; **Product/console follow-up** needs a real
project, credentials, store assets, or a human product decision.

## 1–10 — release truth, language, and visual identity

1. **Done** — Preserve the offline-first release boundary; do not present local
   or placeholder data as live online service data.
2. **Done** — Repair garbled text in every supported language resource
   and regenerate the localization output.
3. **Done** — Add an automated regression check that rejects damaged
   UTF-8/mojibake text in source localization assets.
4. **Done** — Use one name, one tone, and one visual signature across
   the app shell, intro, and playable product surfaces.
5. **Done** — Replace generic “app template” colour relationships with
   a small board-game material palette and explicit semantic colours.
6. **Done** — Establish a readable typography hierarchy for product
   title, match information, labels, and supporting text.
7. **Done** — Refine icon weight, spacing, and state treatment so
   controls feel designed as a family rather than assembled from defaults.
8. **Product/console follow-up** — Create a single approved app icon, Android
   adaptive icon, store feature image, and social sharing image from a real
   vector source.
9. **Product/console follow-up** — Replace debug signing with a securely stored
   release keystore before public distribution.
10. **Product/console follow-up** — Configure a real Firebase project, Auth,
    App Check, and server deployment only when online play is ready.

## 11–20 — design system and access foundation

11. **Done** — Introduce reusable surface, elevation, line, spacing,
    radius, and responsive-width tokens.
12. **Done** — Improve the light theme’s contrast and tactile surfaces
    without overusing gradients or heavy shadows.
13. **Done** — Add a deliberate dark-theme foundation rather than a
    reversed light screen.
14. **Done** — Apply consistent Material component styling to cards,
    buttons, chips, inputs, switches, and bottom navigation.
15. **Done** — Give empty, loading, error, success, and notice states a
    recognizable in-product visual language.
16. **Done** — Keep touch targets at or above 48dp and ensure compact
    controls remain usable on small phones.
17. **Done** — Respect reduced-motion preferences in nonessential
    transitions and intro treatment.
18. **Done** — Preserve colour-assist cues so selected, legal,
    capturable, and winning states are not colour-only.
19. **Done** — Strengthen semantic labels and keyboard/screen-reader
    affordances around the board and primary actions.
20. **Done** — Add visual-quality regression coverage alongside the
    existing functional and architecture checks.

## 21–30 — app shell, navigation, and home

21. **Done** — Make the opening experience compact, branded, and free
    of arbitrary waiting time.
22. **Done** — Rebalance the app shell to remove unused visual space on
    wide phone/tablet and desktop-like emulator layouts.
23. **Done** — Make navigation responsive: compact on phones, clearer
    when horizontal space is available.
24. **Done** — Clarify navigation labels and active state with fewer,
    calmer competing accents.
25. **Done** — Turn the home screen into a clear “choose a board,
    resume, or learn” decision surface.
26. **Done** — Make each 3/9/12 Taş card distinguishable by board
    structure, purpose, pace, and visual rhythm.
27. **Done** — Promote Continue Match as a first-class, stateful action
    when a saved match exists.
28. **Done** — Use one prominent primary call to action per home state.
29. **Done** — Improve content grouping, section rhythm, and card
    density to avoid an endless stack of identical rounded rectangles.
30. **Product/content follow-up** — Add final approved Turkish product
    microcopy and a short privacy/support page before public launch.

## 31–40 — match, board, and game feedback

31. **Done** — Keep the play screen focused on the board rather than
    resembling a scrollable settings page.
32. **Done** — Refine player bars to make turn, reserve, and player
    identity readable at a glance.
33. **Done** — Give the turn instruction a clear priority and reduce
    competing decoration around it.
34. **Done** — Keep board materials restrained: wood, stone, marble,
    and minimal should look tactile, not noisy.
35. **Done** — Preserve depth, shadows, and piece highlights at a
    believable board-game scale.
36. **Done** — Make last move, legal destination, capture, and mill
    states instantly scannable with accessible redundant cues.
37. **Done** — Refine win/draw presentation into a share-worthy but
    restrained result moment.
38. **Done** — Keep haptic/audio feedback surface-aware and independently
    controllable from settings.
39. **Done** — Make restart, save-and-exit, and error feedback visually
    consistent with the product’s dialog language.
40. **Product/content follow-up** — Test board, HUD, and text density on small,
    normal, large, landscape, RTL, and accessibility-scale devices.

## 41–50 — settings, learning, social, and release verification

41. **Done** — Reorganize settings around immediate player-facing
    outcomes instead of a raw technical option list.
42. **Done** — Add a live board-style preview to settings so material,
    view, and piece choices are understood before a match.
43. **Done** — Make language selection clear, resilient, and verified
    across all translated surfaces.
44. **Done** — Make motion, hint, sound, haptic, and colour-assist
    choices understandable without jargon.
45. **Done** — Reframe the tutorial as a guided board experience rather
    than a text slideshow.
46. **Done** — Improve friends, profile, and rankings hierarchy while
    clearly labelling locally stored or unavailable data.
47. **Done** — Present online play as an attractive, explicit “coming
    soon / service required” state instead of a broken competitive feature.
48. **Done** — Build and inspect the release APK on the available
    BlueStacks device after visual changes are integrated.
49. **Done** — Run formatter, analyzer, localization generation, unit
    and widget tests as the acceptance gate.
50. **In progress** — Commit the verified sprint increment and push it to the
    existing GitHub repository with a concise implementation record.

## Acceptance criteria

- No corrupted strings are shown in supported app languages.
- Core offline flows look coherent on a 16:9 landscape emulator and phone-size
  portrait layout.
- All new visual work respects contrast, 48dp interactions, reduced motion,
  and colour-assist settings.
- No screen pretends Firebase-backed data exists before Firebase is configured.
- The Flutter analyzer and test suite pass before the increment is published.
