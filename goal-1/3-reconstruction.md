# 3-RECONSTRUCTION

## Current Facts

- `conditional` is a basis-free adjoint contraction and satisfies
  `conditional_tmul`, state linearity, selected conjugate scaling, a norm bound,
  and an intrinsic zero criterion.
- `normalizedConditional` requires an explicit nonzero conditional and has unit
  norm, a reconstruction-by-norm identity, uniqueness, and phase covariance.
- Mathlib supplies finite `OrthonormalBasis.sum_repr'`, tensor-product
  orthonormal bases, and the tensor sum/scalar identities needed for a direct
  tensor-induction proof.
- Printed equations (1)-(3) were checked against local image 3, p. 456. Their
  coordinate indices are OCR-unsafe. Equation (3)'s factor `1/N_i` corresponds
  to the norm of a nonzero unnormalized conditional; zero rows require separate
  terms rather than division.

## Updated Assumptions

- Reconstruction can be proved using only a first-factor orthonormal basis and
  tensor induction, avoiding an unnecessary chosen basis on the second factor.
- A second-factor basis is useful only for a coordinate-evaluation theorem and
  an explicit coordinate-derived construction; proving this equals
  `conditional` gives a strong basis-independence result.
- A zero-safe normalized reconstruction is clearest as a finite sum of
  conditional terms that branch explicitly on nonzeroness.

## Big Picture Objective

- Prove coordinate evaluation and reconstruction for the intrinsic conditional,
  show every coordinate construction is independent of the chosen complement
  basis, and give a normalized expansion that never divides by a zero branch.

## Detailed Implementation Plan

- Add `Everett/RelativeState/Reconstruction.lean`.
- Prove the coefficient formula relative to tensor-product orthonormal bases.
- Define `coordinateConditional` from a chosen second-factor basis and prove it
  equals the intrinsic `conditional`; derive equality for any two such bases.
- Prove `reconstruction` by tensor induction:
  `Ψ = ∑ i, b i ⊗ₜ conditional (b i) Ψ`.
- Define an explicit zero-safe `normalizedReconstructionTerm` and prove its sum
  reconstructs `Ψ`, using `‖conditional‖ • normalizedConditional` only in the
  nonzero branch.
- Extend the two-level examples with a genuinely non-real coefficient and
  coordinate/basis reconstruction checks.
- Update equations (1)-(3) in traceability and corrections with declaration
  names and exact zero/normalization consequences.

## Build Structure

- `RelativeState.Reconstruction` is a proof/API leaf above `Normalization`; it
  owns coordinate and finite-basis results, not the intrinsic runtime core.
- `RelativeState.Examples` remains the adjacent consumer.
- `Core` and `Normalization` are not changed unless the proof finds a genuine
  missing low-level contract.
- Focused build: `lake build Everett.RelativeState.Reconstruction`.
- Adjacent builds: `lake build Everett.RelativeState.Examples Everett`.
- Full build is required because the package root will publicly import the
  reconstruction surface.

## No-Cheating Checks

- `conditional` and `conditionalMap` must remain unchanged and basis-free;
  coordinate definitions live only in the reconstruction leaf.
- The normalized expansion must branch on `conditional = 0` and contain no
  division by an unchecked norm.
- The non-real example must evaluate a concrete `Complex.I` coefficient, not
  merely restate a general theorem.
- Scan for broad imports, proof holes, project axioms, shortcuts, forbidden
  interpretation language, and whitespace errors.

## Completion Requirements

- Coordinate formula, coordinate/intrinsic equality, basis independence,
  unnormalized reconstruction, and zero-safe normalized reconstruction compile.
- Reconstruction works with zero conditional components.
- A non-real complex coefficient example and selected-vector phase example both
  compile with the verified conjugation orientation.
- Equations (1)-(3) have exact corrected/formalized source-map statuses.
- Focused, adjacent, smoke, and full builds pass; all scans pass.

## Stage Results

- Added the public proof/API leaf `Everett.RelativeState.Reconstruction`, above
  `Normalization` and the narrow `PiL2` basis API. The intrinsic `Core` and
  `Normalization` leaves did not need changes.
- Proved `productBasis_reconstruction`, an equation-(1)-style expansion in the
  tensor product of arbitrary finite orthonormal bases with coefficients from
  `(b.tensorProduct c).repr Ψ`.
- Proved `conditional_repr_apply`: the `j`th coordinate of the intrinsic
  conditional relative to `b i` is exactly the `(i,j)` product-basis
  coefficient. This fixes coefficient orientation using mathlib's verified
  conjugate-first inner-product convention.
- Defined `coordinateConditional` by rebuilding the coefficient row in any
  chosen second-factor orthonormal basis. Proved
  `coordinateConditional_eq_conditional` and then
  `coordinateConditional_basis_independent` for any two complement bases,
  making the printed independence statement stronger and explicit.
- Proved `reconstruction` by `TensorProduct.induction_on`:
  `Ψ = ∑ i, b i ⊗ₜ conditional (b i) Ψ`. The pure-tensor step uses
  `OrthonormalBasis.sum_repr'`; the additive step uses conditional linearity.
- Defined `normalizedReconstructionTerm` with an explicit dependent conditional:
  if the conditional is nonzero, its term is
  `b i ⊗ₜ (‖conditional‖ • normalizedConditional)`; if it is zero, the term is
  zero. Proved `normalized_reconstruction`. There is no unchecked reciprocal or
  fabricated normalized zero vector.
- Extended `Everett.RelativeState.Examples` with:
  - reconstruction of the Bell-type sum in `qubitBasis`;
  - `complexEntangled`, with a genuinely non-real `Complex.I` coefficient;
  - `conditional_complexEntangled_ket0`, proving that coefficient is returned
    without conjugation in the global-state argument;
  - a compiling `coordinateConditional` calculation;
  - zero-safe normalized reconstruction of a product state whose other basis
    branch has zero conditional.
- The initial reconstruction proof exposed two important rewriting hazards:
  unrestricted `rw` rewrote the state inside every conditional as well as the
  target occurrence, and dependent zero branching needed an explicit classical
  decision. Both were repaired with `calc` chains that preserve the original
  state and an explicit `if h : conditional ... ≠ 0`. The coordinate proof was
  also corrected to use `OrthonormalBasis.repr_apply_apply` in its actual
  orientation.
- Updated `docs/source-map.md`: (1) is formalized, while (2)-(3) are corrected
  and formalized with exact declaration names. Updated `docs/corrections.md`
  with the completed complement-basis proof and the `1/N_i = ‖conditional‖`
  interpretation restricted to nonzero rows.
- Verification evidence:
  - `lake build Everett.RelativeState.Reconstruction
    Everett.RelativeState.Examples Everett` — success, 2,952 jobs and no
    warnings;
  - `lake build` — success, 2,952 jobs and no warnings;
  - proof-hole/project-axiom, shortcut, forbidden-interpretation, broad-import,
    and basis-in-core scans — exit 1, no matches;
  - inspection of `normalizedReconstructionTerm` confirms the explicit
    nonzero/zero branches and no reciprocal;
  - source-map inspection confirms individual corrected/formalized rows for
    equations (1), (2), and (3);
  - `git diff --check` — exit 0.
- No Stage 3 obligation remains. Stage 4 should define prepared-family rules,
  linear maps, isometries, and full-space unitary extensions as different types;
  it must not promote a basis prescription by coercion.
