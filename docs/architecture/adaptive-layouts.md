# Adaptive and foldable layout contract

## Width classes

Use `WindowSizeClasses` with compact below 600 dp, medium 600–839 dp, and expanded at 840 dp and above. Compact uses bottom navigation; wider windows use a navigation rail. Expanded navigation may show labels.

## Messaging panes

`SgAdaptivePaneLayout` provides a list pane, chat pane and optional information pane. The information pane appears only when the configured minimum list, chat and information widths fit. Compact windows render the selected compact pane rather than keeping hidden columns in the tree.

## Physical fold posture

`SgFoldablePostureInfo.detect` reads Flutter's `MediaQuery.displayFeatures`:
- A vertical `fold` or `hinge` is book posture. The list and chat occupy separate pages; the logical order mirrors in RTL.
- A horizontal fold/hinge reported as `postureHalfOpened` is tabletop posture. Video occupies the upper display region and call controls occupy the lower region.
- Camera cutouts and unknown display features do not select a fold posture.
- Hinge spacing comes from Flutter's logical-pixel display-feature bounds; do not place controls inside that region.

`SgFoldableLayout` is a reusable composition primitive. Feature detection is based on the Android-provided display-feature list and updates with MediaQuery. The current tests use synthetic display-feature geometry; a real book/tabletop device run remains required before release.

## Evidence boundary

The Pixel 8/API 37 emulator smoke test does not verify foldable hardware behavior. Record a separate device run on a supported foldable, including book and tabletop postures, rotation, keyboard visibility, RTL and a call-control reachability check.
