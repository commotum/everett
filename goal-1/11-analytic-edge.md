# 11-ANALYTIC-EDGE

## Current Facts

- Printed equations (4)-(8), images 3-4, use a translation interaction,
  continuous coordinates, Dirac deltas, and sharp apparatus-coordinate
  conditioning.
- Pinned mathlib lacks a general completed Hilbert tensor product. A Dirac delta
  is not an `L²` vector, and the paper does not state self-adjoint operator
  domains for its formal Hamiltonian.
- The finite core already has exact basis-controlled measurement and intrinsic
  conditioning, sufficient for an honest controlled-shift analogue.

## Updated Assumptions

- Recheck the signs, time/translation terms, variables, and normalization text
  directly against images 3-4 before final classification.
- Formalize a finite cyclic controlled shift as an analogue only. It must be a
  constructed linear isometry equivalence/unitary permutation, not a delta or
  differential-operator theorem.
- Keep the analytic leaf out of `Everett.lean` and the eventual core `API.lean`.
  Record the exact missing framework for any stronger continuous statement.

## Big Picture Objective

- Supply the smallest honest finite analogue of the translation measurement and
  delimit every continuous/distributional claim without abusing Hilbert-space
  notation.

## Detailed Implementation Plan

- Add `Everett/Analytic/ControlledShift.lean` on finite cyclic coordinate
  spaces, constructing the basis permutation and proving its basis action,
  unitarity, correlated-superposition formula, and relative conditional.
- Add finite examples including wraparound and a superposition.
- Reinspect page images 3-4 and update equation-by-equation source statuses.
- Document why equations (4)-(8) are not proved as continuous `L²` statements:
  missing operator domains, completed tensor infrastructure, generalized-state
  framework, and sharp-coordinate evaluation semantics.

## Build Structure

- The optional analytic analogue imports finite orthonormal-basis/tensor APIs
  and the intrinsic conditional leaf only.
- It is built directly in Stage 11 and audited in Stage 12, but is not imported
  by the core package root/API.

## No-Cheating Checks

- No `Dirac`, delta, point-evaluation, or generalized eigenstate is represented
  as an `L²`/Hilbert vector.
- “Analogue” appears in declarations/docs; no continuous theorem is inferred
  from the finite permutation.
- No hidden Hamiltonian or self-adjointness assumptions are introduced.
- Run proof-hole, axiom, shortcut, delta/vector, import-boundary, and whitespace
  scans.

## Completion Requirements

- Equations (4)-(9) have verified individual statuses.
- A finite controlled-shift unitary analogue and its conditional behavior
  compile with diagnostic examples.
- Stronger unresolved claims name exact spaces/domains/equality obligations.
- The core root remains independent; focused/full builds and scans pass.

## Stage Results

- Images 3-4 were reinspected directly. Equations (4)-(8), the following
  normalization integral, the sharp-apparatus approximation paragraph, and the
  projection-obstruction footnote are recorded equation-safely in
  `docs/analytic-edge.md` and classified individually in the source map.
- `controlledShift` is a constructed `LinearIsometryEquiv` over a finite
  additive coordinate group. It proves `(q,r) ↦ (q,r+q)`, the ready-origin
  correlation, arbitrary finite superpositions, and an intrinsic finite-basis
  conditional. A `ZMod 3` example checks cyclic wraparound.
- No continuous theorem is claimed. The unresolved obligations explicitly name
  the `L²(ℝ²)` shear, measurability/measure preservation, unbounded generator
  domain and self-adjointness, solution notion, distributional delta equality,
  a.e. fiber conditioning, nonzero normalization, and approximation topology.
- The focused analytic modules compile and the root contains no analytic import.
- The focused build passes with 2,357 jobs; the clean core full build remains
  2,973 jobs. Proof-hole/project-axiom, shortcut, delta-as-vector,
  import-boundary, broad-import, and whitespace scans pass.
