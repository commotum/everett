# 8-FREQUENCY

## Current Facts

- Stage 7 supplies finite product distributions whose history masses are the
  squared norms of Stage 6 product amplitudes.
- Image 8, printed p. 461, was checked directly. The paper moves from finite
  exceptional branch weight tending to zero to informal measure-zero language;
  those are different claims.
- Pinned mathlib contains general Chebyshev and strong-law infrastructure, but
  its binomial expectation and variance declarations are still `proof_wanted`.
  Stage 8 will therefore prove the required finite identities directly on the
  project's finite mass functions.

## Updated Assumptions

- Prove finite product moment identities by induction using the checked history
  `snocEquiv`, rather than relying on unfinished binomial theorems.
- Define frequency at `n = 0` explicitly as zero. Deviation bounds that divide
  by `n` require `0 < n` and `0 < ε` visibly.
- Convergence in probability is a theorem about finite exceptional masses.
  Almost-sure convergence requires a separately constructed infinite product
  probability space and will be included only with all hypotheses verified.

## Big Picture Objective

- Replace informal typicality language with exact finite moment identities, a
  Chebyshev exceptional-weight bound, and convergence in probability linked to
  the branch product distribution.

## Detailed Implementation Plan

- Add `Everett/Probability/Frequency.lean` with product mass, empirical count and
  frequency, recursive sum/moment identities, generic finite Chebyshev, and the
  product-frequency bound.
- Prove the product mass agrees with `sequenceDistribution` when instantiated by
  Stage 7 amplitudes.
- Add binary examples covering `p=0`, `p=1`, `n=0`, and positive tolerance.
- Check infinite-product/strong-law APIs; add an almost-sure theorem only if the
  probability space, coordinate measurability, and independence are explicit.
- Update every page-8 frequency phrase with its precise theorem status.

## Build Structure

- `Probability.Frequency` imports `Weights.Product` and finite order/sum tools.
- Diagnostic examples stay in `Probability.Examples`.
- Focused build: `lake build Everett.Probability.Frequency`.
- Adjacent build: `lake build Everett.Probability.Examples Everett`.

## No-Cheating Checks

- No use of mathlib `proof_wanted` binomial moments.
- Every division theorem exposes positivity/nonzero hypotheses.
- No finite convergence-in-probability result is described as almost sure.
- Run proof-hole, project-axiom, shortcut, import, interpretation, limit-word,
  and whitespace scans.

## Completion Requirements

- Count expectation and variance identities compile for the finite product
  distribution.
- An explicit exceptional-mass bound depends on `n`, `ε`, and target mass; a
  convergence-in-probability corollary compiles.
- Edge cases `p=0`, `p=1`, `n=0`, and positive tolerance are explicit.
- Almost-sure status is either proved with full infrastructure or recorded as
  unresolved/assumption-qualified.
- Focused, adjacent, full builds, examples, source updates, and scans pass.

## Stage Results

- `Everett.Probability.Frequency` defines product mass, empirical count and
  frequency, and finite expectation/second-moment/variance. The count identities
  are proved by induction using `History.snocEquiv` and explicit double-sum
  factorization, not mathlib's unfinished binomial `proof_wanted` declarations.
- `finite_chebyshev` proves a reusable weighted finite inequality.
  `exceptionalFrequencyMass_le` instantiates it to the explicit bound
  `p(1-p)/(n ε²)` with visible `0<n` and `0<ε` hypotheses.
- `exceptionalFrequencyMass_tendsto_zero` proves convergence in probability via
  a squeeze against the finite bound along lengths `n+1`.
  `productMass_outcomeDistribution_eq_sequenceMass` links the theorem directly
  to Stage 7 squared-amplitude sequence distributions.
- Edge cases compile: empty histories have frequency zero; a total-one finite
  distribution proves its outcome type nonempty; target mass zero or one gives
  exactly zero exceptional mass at every positive length/tolerance.
- Binary examples compile fair expectation/variance, a nontrivial finite bound,
  deterministic `p=0`/`p=1` cases, `n=0`, and the limit theorem.
- The infinite-sequence almost-sure/measure-zero claim remains explicitly
  unresolved: no infinite product probability space, measurable coordinate
  process, or independence theorem is constructed, and finite convergence is
  not promoted to almost sure.
- Focused and adjacent builds pass; a clean full build passes (2,968 jobs).
  Proof-hole/`proof_wanted`, project-axiom, shortcut, claim-level, signature,
  import, interpretation, and whitespace scans pass.
