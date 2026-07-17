# 2-CONDITIONAL

## Current Facts

- Stage 1 pins Lean/mathlib `v4.31.0`; focused and full builds pass.
- Mathlib has no general completed Hilbert tensor product. The stable target is
  therefore the algebraic tensor product of finite-dimensional complex
  inner-product spaces, made complete via `FiniteDimensional.complete` where an
  adjoint is used.
- Mathlib's inner product is conjugate-linear in the first argument and linear
  in the second. Thus contraction relative to `x` must be conjugate-linear in
  `x` and linear in the bipartite state.
- Equation (2) was checked against local image 3 (printed p. 456). It presents a
  normalized coordinate row but suppresses the possibility that the selected
  row is zero.
- The adjoint API and pure-tensor norm theorem are available from the narrow
  tensor import. For fixed `x`, the bounded map `y ↦ x ⊗ₜ y` has an adjoint
  satisfying exactly the intrinsic partial-inner-product characterization.

## Updated Assumptions

- Defining contraction as the adjoint of `y ↦ x ⊗ₜ y` gives a smaller and more
  useful public surface than defining it by coordinates or by a raw
  `TensorProduct.lift` and later proving continuity.
- `NormedSpace.normalize` is usable behind an explicit nonzero proof, but its
  total zero behavior will not be exposed as a normalized physical branch.
- A lightweight phase-equivalence predicate is sufficient for Stage 2; a ray
  quotient remains unnecessary.
- The sharp basis-coordinate zero characterization belongs in Stage 3. Stage 2
  will provide the exact intrinsic criterion quantified over test vectors.

## Big Picture Objective

- Define the intrinsic unnormalized conditional vector for every selected
  vector and bipartite vector, prove its pure-tensor, linearity, conjugate-phase,
  norm, and zero behavior, and expose normalization only under an explicit
  nonzero hypothesis.

## Detailed Implementation Plan

- Add `Everett/RelativeState/Core.lean` with a continuous `tensorLeft` map and
  its adjoint `conditionalMap`; define `conditional` by application.
- Prove the adjoint characterization, pure-tensor formula, linearity in the
  bipartite state, additivity/conjugate scaling in the selected vector, norm
  bound, and intrinsic zero criterion.
- Add `Everett/RelativeState/Normalization.lean` with
  `normalizedConditional`, unit norm/nonzero/formula theorems, selected-vector
  unit-phase covariance, and explicit `PhaseEquivalent` statements.
- Add `Everett/RelativeState/Examples.lean` covering a pure tensor, zero state,
  an orthogonal selected vector, and an entangled two-level state.
- Update equation (2)'s source-map and correction entries with exact declaration
  names and the zero-branch repair.

## Build Structure

- `RelativeState.Core` owns runtime definitions and cheap algebraic/norm facts.
- `RelativeState.Normalization` depends only on the core plus vector
  normalization and owns the nonzero API.
- `RelativeState.Examples` is a consumer leaf and is not imported by runtime
  modules.
- `Foundations.Smoke` is intentionally not imported.
- Focused builds: `lake build Everett.RelativeState.Core
  Everett.RelativeState.Normalization`.
- Adjacent consumer build: `lake build Everett.RelativeState.Examples`.
- The package root changes to import the normalization surface and examples, so
  `lake build` is required.

## No-Cheating Checks

- Scan `RelativeState` Lean sources to confirm `conditionalMap` has no basis or
  coordinate parameter.
- Check theorem signatures distinguish total unnormalized output from
  `normalizedConditional` with its explicit proof argument.
- No default normalized vector is defined for a zero conditional.
- Scan for `sorry`, `admit`, project `axiom`, `FORBIDDEN_STAGE_SHORTCUT`, broad
  `Mathlib` imports, and forbidden interpretation vocabulary.
- Re-run `git diff --check` and the Stage 1 smoke consumer after import changes.

## Completion Requirements

- Core, normalization, examples, smoke-adjacent, and full builds pass.
- Public theorems cover pure tensors, state linearity, selected-vector conjugate
  scaling, the norm bound, exact intrinsic zero criterion, unit norm, and phase
  covariance.
- Pure tensor, zero vector, orthogonal selection, and two-level entangled
  examples compile.
- Equation (2) is marked corrected/partial-formalized with downstream effects in
  both traceability files.
- Intrinsic-definition, proof-hole, project-axiom, shortcut, import,
  interpretation, and whitespace scans pass.

## Stage Results

- Added `Everett.RelativeState.Core`, publicly importing only
  `Mathlib.Analysis.InnerProductSpace.TensorProduct`.
- Implemented `tensorLeft x` as the bounded continuous map `y ↦ x ⊗ₜ y` and
  proved `tensorLeft_apply` and `tensorLeft_norm_le`.
- Implemented `conditionalMap x` as the adjoint of `tensorLeft x`, using
  `FiniteDimensional.complete` locally for the two spaces. `conditional x Ψ` is
  the total unnormalized output; neither definition contains a basis parameter.
- Core theorem surface:
  - `inner_conditional` — intrinsic partial-inner-product characterization;
  - `conditional_tmul` — `conditional x (u ⊗ₜ v) = ⟪x,u⟫ • v`;
  - `conditional_zero_state`, `conditional_add_state`, and
    `conditional_smul_state` — linearity in the bipartite state;
  - `conditional_zero_selected`, `conditional_add_selected`, and
    `conditional_smul_selected` — additivity and conjugate scaling in `x`;
  - `conditional_norm_le` — `‖conditional x Ψ‖ ≤ ‖x‖ * ‖Ψ‖`;
  - `conditional_eq_zero_iff` — exact basis-free zero criterion quantified over
    all second-factor test vectors;
  - `conditional_tmul_eq_zero_iff` — pure-tensor zero specialization.
- Added `Everett.RelativeState.Normalization`. `normalizedConditional x Ψ h`
  has an explicit `h : conditional x Ψ ≠ 0`; no zero default exists. Proved
  `normalizedConditional_formula`, `norm_normalizedConditional`,
  `normalizedConditional_ne_zero`, `norm_smul_normalizedConditional`, and
  `normalizedConditional_unique`.
- Proved precise unit-phase behavior. A phase on selected `x` appears conjugated
  (`normalizedConditional_smul_selected`); a phase on `Ψ` appears unchanged
  (`normalizedConditional_smul_state`). Both derive their new nonzero proofs
  from the original. `PhaseEquivalent` and two phase-equivalence corollaries
  keep ray language explicit without quotienting vectors.
- Added `Everett.RelativeState.Examples` with a concrete `EuclideanSpace ℂ
  (Fin 2)` model. Compiling examples cover a pure tensor, zero bipartite state,
  orthogonal selected state, Bell-type entangled sum, normalization, and the
  conjugated `Complex.I` selected-vector phase.
- Early core probes exposed three API details and were repaired without axioms:
  the second factor had to be explicit in `tensorLeft_norm_le`; tensor scalar
  movement required `TensorProduct.smul_tmul'`; and downstream declarations
  required `public import` plus an exposed public section under Lean 4.31's
  module system. An initial example simplification also exposed the need to use
  explicit orthogonality lemmas rather than broad simplification.
- Updated equation (2) in `docs/source-map.md` to corrected/partially formalized
  and recorded the exact zero, intrinsic-basis, and phase repairs with
  declaration names in `docs/corrections.md`.
- Verification evidence:
  - `lake build Everett.RelativeState.Core Everett.RelativeState.Normalization
    Everett.RelativeState.Examples` — success, 2,358 jobs and no warnings;
  - `lake build Everett.Foundations.Smoke` — success, 2,946 jobs;
  - `lake build` — success, 2,951 jobs and no warnings;
  - proof-hole/project-axiom scan over all project Lean files — exit 1, no
    matches;
  - forbidden-shortcut and forbidden-interpretation scans — exit 1, no matches;
  - basis/coordinate scan of core and normalization — only the two documentation
    statements saying the definition/criterion is basis-free; no parameter or
    implementation hit;
  - broad `import Mathlib` scan — exit 1, no matches; import listing confirms
    narrow leaves and no runtime import of `Foundations.Smoke`;
  - `git diff --check` — exit 0.
- No Stage 2 obligation remains. Stage 3 should use a finite orthonormal basis to
  prove coordinate evaluation and reconstruction equal the intrinsic
  `conditional`; it must include a genuinely non-real coefficient test.
