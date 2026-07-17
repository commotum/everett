# Scope and Interpretation Boundary

## Included mathematical scope

The stable first target is finite-dimensional complex inner-product spaces and
finite outcome types. The planned library covers intrinsic conditional vectors,
normalization and phase behavior, coordinate reconstruction, ideal measurement
maps, neutral record histories, repeated and independent measurements, branch
weights, finite product distributions, rigorous frequency bounds, multiple
record correlations, and a defined finite comparison with collapse predictions.

Generality is theorem-specific. Algebraic identities may be stated without
finite-dimensional hypotheses when the relevant mathlib construction supports
them. Bases, completeness, distributions, and unitary extension carry their
actual finiteness or dimension assumptions.

## Explicitly distinct concepts

- vector, normalized vector, and phase-equivalence class;
- zero conditional, unnormalized conditional, and normalized relative state;
- coherent vector sum, family of branch weights, and classical mixture;
- prepared-family rule, span map, isometry, and full-space unitary operator;
- same-system repetition, independent prepared copies, sequential incompatible
  observables, and interactions with remote tensor factors;
- mathematical weight, normalized finite distribution, and probability measure.

An exact finite record encoding is currently an orthonormal basis indexed by all
histories of a fixed length. This explicit completeness assumption is what lets
`Encoding.appendIsometry` construct, rather than assume, an isometric extension
for appending a fixed outcome. Generic coherent branches need only an explicit
orthonormal vector family. Their `normSquareData` is real data and has no
probability structure until later normalization theorems justify one.

Exact communication uses the diagonal isometry on that distinguished record
basis. It does not clone an arbitrary unknown vector and is not silently
promoted to a unitary on a larger composite system. Sequential `A→B→A`
disagreement is stated only when the relevant change-of-basis amplitudes are
nonzero. Remote invariance means equality of tensor-map orderings for explicit
maps on distinct factors; it is not an unrestricted no-signalling claim.

## Analytic edge

Everett's equations (4)-(8) use continuous coordinates, delta functions, and
generalized position eigenstates. Dirac deltas are not Hilbert-space vectors.
The core API does not encode them as elements of `L²`.
`Everett.Analytic.ControlledShift` provides an explicitly labeled finite cyclic
controlled-shift unitary analogue, with basis, superposition, and conditional
theorems. It proves none of the continuous equations. The continuous result
would require an `L²(ℝ²)` shear unitary, unbounded Hamiltonian domain/generator
theory, distributional semantics for deltas, and a.e. fiber semantics for sharp
apparatus conditioning. These exact obligations are recorded in
`docs/analytic-edge.md`. The core package root does not import the analytic leaf.

## Interpretation exclusions

Theorems do not assert actuality, splitting worlds, consciousness, awareness,
experience, perception, or the truth of an interpretation. Paper language using
“observer” is represented by neutral system and record types. Philosophical
claims remain source-map exclusions unless reduced to explicit mathematical
objects and hypotheses.

The comparison theorem does not claim unrestricted empirical or interpretative
equivalence. `FiniteProjectiveExperiment` supports one normalized finite input,
one exact orthonormal projective measurement/readout, and finite histories of
independently prepared repetitions. It compares outcome masses, nonzero
normalized conditional vectors, and product-history masses as separate
criteria. Arbitrary POVMs, channels, approximate instruments, adaptive or
changing-basis sequences, continuous spectra, and unrestricted experiments are
excluded until separately implemented. The coherent global tensor vector and
the finite classical mass distribution remain distinct mathematical types.

## Proof integrity

Completed Lean modules may not contain `sorry`, `admit`, or project-specific
axioms. Classical choice or standard quotient axioms reported by Lean may occur
through mathlib and will be itemized in the release axiom audit; they do not
stand in for missing project mathematics.
