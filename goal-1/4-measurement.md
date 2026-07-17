# 4-MEASUREMENT

## Current Facts

- Stages 1-3 provide a finite-dimensional complex tensor API, but no measurement
  declarations exist yet.
- Equations (10)-(17) and Rules 1-2 were checked directly against local image 5,
  printed p. 458. They prescribe eigenstate/ready-record behavior and obtain
  correlated superpositions by superposition; they do not distinguish a family
  rule, span map, isometry, and global unitary.
- Mathlib supplies `LinearIsometry.extend` for an isometry from a subspace into a
  finite-dimensional inner-product space. The extension is an endomorphism
  isometry; finite-dimensional injective-implies-surjective converts it to a
  `LinearIsometryEquiv`. Thus the planned full unitary extension can be proved,
  not merely postulated.
- Because the system basis is orthonormal and is preserved in each output,
  orthogonality of different composite output branches follows from the system
  factor. Equal record norms are enough for the prepared prescription to be
  isometric; orthogonality of record states is a separate exact-outcome
  distinguishability hypothesis.

## Updated Assumptions

- Model raw measurement data separately from ideal data. The raw layer allows a
  theorem exposing the exact norm condition; the ideal layer requires a unit
  ready state and an orthonormal outcome-record family.
- Define the prepared subspace as the range of the isometric embedding
  `ψ ↦ ψ ⊗ ready`. This is the actual prepared-input subspace and avoids treating
  the whole composite as prepared.
- Use four distinct bundled types: prepared data/rule, a map on the prepared
  subspace, a prepared-subspace isometry, and a full-space unitary operator.
- Nondemolition means the system eigenvector is preserved in the output formula;
  repeatability across a later interaction remains Stage 6.

## Big Picture Objective

- Give exact ideal measurement declarations at each map level, construct the
  canonical prepared isometry and a finite-dimensional full unitary extension,
  and prove Everett's correlated-superposition and spectator rules from
  linearity rather than new axioms.

## Detailed Implementation Plan

- Add `Everett/Measurement/Core.lean` for raw/ideal data, prepared inputs and
  outputs, orthogonality/norm facts, preparation and correlation maps, and the
  actual prepared subspace.
- Add `Everett/Measurement/Linearity.lean` for `PreparedSpanMap`,
  `PreparedIsometry`, `FullUnitary`, downward conversions, canonical isometry,
  unitary extension, correlated-superposition, composition, and spectator
  theorems.
- State record orthogonality independently from the weaker composite-isometry
  condition and expose both theorem signatures.
- Add `Everett/Measurement/Examples.lean` with exact two-level and finite
  multi-outcome data, canonical isometry, full unitary extension, and a
  correlated complex superposition.
- Update equations (10)-(17) and Rules 1-2 in source/correction docs.

## Build Structure

- `Measurement.Core` is the low-level runtime/data leaf and imports only the
  tensor/basis APIs it needs.
- `Measurement.Linearity` is the proof/API leaf; it imports `PiL2` for the
  finite-dimensional extension theorem.
- `Measurement.Examples` is a diagnostic consumer and is not a runtime import.
- Relative-state leaves remain independent of measurement leaves.
- Focused build: `lake build Everett.Measurement.Core
  Everett.Measurement.Linearity`.
- Adjacent build: `lake build Everett.Measurement.Examples Everett`.
- Full build is required after changing the package root.

## No-Cheating Checks

- Scan declarations to confirm the four levels have different types and that no
  coercion is used as evidence of promotion.
- The unitary extension must call the proved finite-dimensional extension API
  and prove surjectivity; it may not be a field assumed in ideal data.
- Correlated-superposition, composition, and spectator theorems must use map
  linearity/application rules, not new axioms.
- Record orthogonality and record norm hypotheses must remain visible and must
  not be inferred from interpretative terminology.
- Run proof-hole, axiom, shortcut, broad-import, interpretation, import, and
  whitespace scans.

## Completion Requirements

- Prepared-family, prepared-span-map, prepared-isometry, and full-unitary levels
  compile with named downward conversions.
- The exact sufficient norm condition and the stronger orthonormal record
  condition are separate theorems.
- Canonical prepared isometry and finite-dimensional full unitary extension
  compile under visible hypotheses.
- Correlated-superposition and spectator-system theorems compile from linearity.
- Two-level and multi-outcome examples compile.
- Equations (10)-(17) and Rules 1-2 are traceable with corrected statuses; all
  focused, adjacent, full builds and scans pass.

## Stage Results

- `Everett.Measurement.Core` defines raw `MeasurementData`, the prepared and
  correlated families, the exact criterion
  `PrescriptionInnerPreserving ↔ ∀ i, ‖record i‖ = ‖ready‖`, and stronger
  `IdealData` with a unit ready state and orthonormal record family.
- The actual prepared-input subspace is the range of the ready-state
  preparation isometry. Composite output orthonormality is proved separately
  from the weaker norm criterion.
- `Everett.Measurement.Linearity` gives distinct `PreparedSpanMap`,
  `PreparedIsometry`, and `FullUnitary` structures with named strong-to-weak
  conversions. `canonicalPreparedIsometry` is constructed from the ideal data.
- `unitaryExtension` uses `LinearIsometry.extend`, proves surjectivity from
  finite-dimensional injectivity, and packages the result as a
  `LinearIsometryEquiv`; no unitary is assumed in the input data.
- Correlated-superposition, generic composition, spectator, and nondemolition
  theorems are consequences of bundled linear maps. `Examples` compiles exact
  two- and three-outcome data, both extension levels, a non-real coefficient,
  and a spectator factor.
- Equations (10)-(15) and Rules 1-2 now have corrected traceability entries.
  Equations (16)-(17) have the abstract linearity result, with the concrete
  repeat-record instance explicitly owned by Stage 6.
- Focused, adjacent, and warning-free full builds pass (2,955 jobs). Proof-hole,
  project-axiom, shortcut, broad-import, interpretation, map-level, import, and
  whitespace scans pass.
