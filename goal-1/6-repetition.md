# 6-REPETITION

## Current Facts

- Stage 4 proves one ideal nondemolition measurement and generic linear
  composition. Stage 5 supplies length-indexed histories, exact record bases,
  append isometries, and generic coherent branches.
- Local image 6, printed p. 459, was checked directly: (18)-(19) repeat one
  nondemolished system; (20)-(24) instead measure separately prepared copies.
  The condition below (22) is `r ≤ n`, contrary to the OCR's `r < n`.

## Updated Assumptions

- Same-system repetition will be a controlled isometry from a system plus a
  length-`n` exact record space to the same system plus length-`n+1` record
  space. Its basis theorem explicitly preserves the system eigenstate and
  appends that same outcome.
- Independent-copy branching is a different API. A one-step coefficient family
  acts on every existing history, and the canonical iterated record state is
  proved equal to a coherent sum whose amplitude is a finite product.
- The finite truncated record spaces change dimension, so the repeat and
  independent steps are isometries/linear maps between spaces, not silently
  promoted full-space unitaries.

## Big Picture Objective

- Prove same-system nondemolition record agreement and, separately, the
  arbitrary-length product-amplitude expansion for independent preparations.

## Detailed Implementation Plan

- Add `Everett/Measurement/Repeatability.lean` with controlled repeat input and
  output families, output orthonormality, the induced repeat isometry, and the
  basis/matching-record repeatability theorem.
- Add `Everett/Records/Independent.lean` with one-step amplitudes, product
  sequence amplitudes, a canonical linear branching step, recursive iterated
  state, and an induction proof of the history expansion.
- Prove explicit `n = 0`, `1`, and `2` forms and add a diagnostic basis-change
  example showing that a different second basis need not append the old label.
- Update equations (16)-(24) from the checked image and retain distinct theorem
  ownership for same-system versus independent-copy claims.

## Build Structure

- `Measurement.Repeatability` imports only measurement core and record encoding.
- `Records.Independent` imports branch/encoding infrastructure and finite big
  operators; it does not import the same-system repeat leaf.
- `Measurement.RepetitionExamples` is diagnostic and imports both leaves.
- Focused: `lake build Everett.Measurement.Repeatability
  Everett.Records.Independent`.
- Adjacent: `lake build Everett.Measurement.RepetitionExamples Everett`.

## No-Cheating Checks

- Confirm the two exported theorem families have different data and domains.
- Confirm the independent arbitrary-`n` result follows from recursive state
  evolution and induction, not by defining the final state as the target sum.
- Confirm no claim promotes changing-dimension steps to full unitaries.
- Run proof-hole, project-axiom, shortcut, broad-import, interpretation,
  same/independent conflation, and whitespace scans.

## Completion Requirements

- The repeat isometry maps every system eigenstate/history input to the same
  eigenstate with that outcome appended; matching existing records remain in
  agreement.
- Independent one-step branching and the arbitrary finite product-amplitude
  expansion compile, with explicit zero-, one-, and two-step checks.
- A diagnostic changed-basis example demonstrates why repeatability requires the
  same nondemolition eigenbasis.
- Equations (16)-(24) receive final or precisely partial statuses; focused,
  adjacent, and full builds and all scans pass.

## Stage Results

- `Everett.Measurement.Repeatability` defines complete controlled input/output
  families from a system basis and consecutive exact history encodings. It
  proves output orthonormality, constructs `repeatIsometry`, and proves
  `repeatIsometry_input`: the eigenstate is preserved and its own label is
  appended to the existing history.
- `Everett.Records.Independent` defines `sequenceAmplitude` as a finite product,
  a genuine linear `branchingStep`, recursive `iteratedState`, and explicit
  `expandedState`. `branchingStep_expandedState` uses the history `snocEquiv` to
  reindex the double sum; `iteratedState_eq_expandedState` is an induction, and
  `iteratedState_eq_sum` exposes the arbitrary-length product formula.
- Examples compile a matching repeat record, zero/one/two recursive independent
  states, and the two-step product expansion. A Boolean-reindexed system basis
  maps the original `false` eigenvector to label `true`; the example appends
  `true`, while a separate theorem proves `false,true ≠ false,false`.
- The changing-dimensional steps are never promoted to full unitaries. Same-
  system and independent declarations live in different modules and have
  visibly different domains.
- Failed attempts were elaboration-level: opaque basis/state wrappers required
  explicit changes, the orthonormal-basis coordinate proof used `repr_self`,
  and the successor sum required the checked `Fin.snocEquiv` reindexing. No
  theorem assumption was weakened.
- Focused builds pass (2,360 jobs), diagnostic/root consumers pass, and a clean
  full build passes (2,962 jobs). Proof-hole, project-axiom, shortcut, import,
  interpretation, unitary-promotion, API-separation, and whitespace scans pass.
- Equations (16)-(19) are formalized. Equations (20)-(23) receive a precise
  coefficient/record formalization: common preparation amplitudes and product
  history branches are proved, while dormant unmeasured-system tensor factors
  are explicitly outside this leaf rather than silently identified with it.
  Equation (24)'s product-amplitude branch is formalized; its weight is Stage 7.
