# 7-WEIGHTS

## Current Facts

- Stage 5 separates coherent vectors from unnormalized real coefficient
  norm-square data. Stage 6 proves that independent sequence amplitudes are
  finite products.
- Equations (25)-(34) were checked directly on local images 7-8, printed
  pp. 460-461. OCR repairs for radicals, conjugates, and displaced (30)-(31)
  are already recorded.
- A pinned-mathlib search found no turnkey theorem classifying additive maps on
  `NNReal`. It does provide continuous-additive-to-real-linear machinery
  (`map_real_smul`) and bounded-neighborhood continuity criteria.

## Updated Assumptions

- Formalize the radial equation on an explicit nonnegative domain. Do not simply
  assume continuity if codomain nonnegativity plus additivity can prove
  monotonicity, local boundedness, and hence continuity.
- If the cleanest reusable proof first extends the nonnegative-domain map to an
  additive map on `ℝ`, make that extension theorem explicit; do not silently
  strengthen Everett's domain.
- Square weights remain nonnegative real numbers. A finite distribution is
  constructed only after a positive-total normalization theorem, and a
  probability distribution only after total mass one is proved.

## Big Picture Objective

- Prove the corrected square-amplitude uniqueness theorem under inspectable
  assumptions, finite orthogonal weight additivity, normalized branch data, and
  the independent product-weight formula.

## Detailed Implementation Plan

- Add `Everett/Weights/Additive.lean` for nonnegative-domain additive/radial
  maps, monotonicity, continuity or the exact checked substitute, and the
  classification `g x = g 1 * x`; derive the complex radial formula.
- Add `Everett/Weights/Branch.lean` for squared norms, finite orthogonal
  additivity, positive-total normalization, and total-one proofs.
- Add `Everett/Weights/Product.lean` linking `sequenceAmplitude` to products of
  one-step squared norms and packaging the normalized finite product
  distribution.
- Add finite examples including a zero branch and a non-real amplitude.
- Update equations (25)-(34), distinguishing the printed uniqueness claim from
  the exact hypotheses proved.

## Build Structure

- `Weights.Additive` is independent of quantum/record modules.
- `Weights.Branch` imports coherent branches and finite sum identities.
- `Weights.Product` imports only `Weights.Branch` and `Records.Independent`.
- Examples remain diagnostic. Focused builds target each leaf, then the record
  consumer and root.

## No-Cheating Checks

- Scan theorem signatures for every domain, nonnegativity, additivity,
  phase/radiality, and regularity hypothesis actually used.
- Confirm normalization requires positive total mass and product probability
  requires a one-step total-one theorem.
- Confirm no coherent vector is identified with a classical distribution.
- Run proof-hole, project-axiom, shortcut, broad-import, interpretation, and
  whitespace scans.

## Completion Requirements

- A compiling uniqueness theorem gives the square-amplitude form with its exact
  assumptions; any assumption not justified from the paper is documented.
- Orthogonal additivity, normalization, and product form are separate theorem
  groups.
- Finite branch distributions total one and match squared norms under normalized
  data; sequence weights factor into one-step weights.
- Equations (25)-(34), focused/adjacent/full builds, examples, and scans pass.

## Stage Results

- `Everett.Weights.Additive` defines `NonnegativeOnNonnegative` for
  `g : ℝ →+ ℝ`. It proves monotonicity, bounded-neighborhood continuity, and
  `additive_eq_mul : g x = g 1 * x`. Thus no continuity assumption is inserted.
  `radialWeight_eq`, phase invariance, and nonnegativity give the corrected
  complex square-amplitude result.
- The source-domain qualification remains visible: Everett introduces `g` on
  nonnegative reals, while the compiling theorem assumes an additive extension
  to all reals. This is a sufficient corrected theorem, not a claim that the
  extension step was printed or already formalized.
- `Everett.Weights.Branch` defines `FiniteDistribution` separately from
  coherent vectors. Arbitrary nonnegative weights require positive total mass
  for `normalize`; orthonormal unit coherent branches give
  `unitBranchDistribution` directly. Binary and finite orthogonal square-weight
  additivity compile.
- `Everett.Weights.Product` proves `sequenceWeight_eq_prod`,
  `sum_sequenceWeight`, and bundled one-step/sequence distributions.
  `sequenceDistribution_mass_eq_prod` proves the finite product law without an
  independence axiom; `Fintype.sum_pow` derives total one.
- Examples compile the identity additive map, `Complex.I`, a normalized Boolean
  family with a zero branch, two-step zero/nonzero histories, and a three-step
  distribution factorization.
- Focused builds pass (2,344 jobs), adjacent/root examples pass, and a clean full
  build passes (2,966 jobs). Proof-hole, project-axiom, shortcut, signature,
  coherent/distribution-level, import, interpretation, and whitespace scans
  pass.
- Equations (25)-(34) now have formalized or explicitly assumption-qualified
  statuses. The half-line additive-extension bridge is carried forward as an
  honest source qualification, not needed for the proved sufficient theorem.
