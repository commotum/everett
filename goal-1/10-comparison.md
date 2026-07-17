# 10-COMPARISON

## Current Facts

- The library already supplies ideal finite measurements, coherent correlated
  outputs, normalized square-amplitude distributions, intrinsic conditional
  vectors, repetition, and sequential/local tensor-map theorems.
- Image 9 claims agreement with the conventional external-observation formalism
  only “where applicable”; it does not define a mathematical comparison class.
- A coherent global pure vector is not equal to a classical collapsed mixture.

## Updated Assumptions

- The supported comparison class is one finite ideal projective measurement in
  an orthonormal basis with exact orthonormal records and normalized input.
- Comparison means equality of outcome/readout masses and equality of the
  normalized conditional system vector on each nonzero branch. These are
  separate criteria.
- Later exact same-basis readout comparison may reuse repeatability, but no claim
  covers arbitrary POVMs, channels, approximate instruments, or continuous
  spectra.

## Big Picture Objective

- State and prove the precise finite prediction comparison supported by the
  existing unitary-record model and record every exclusion.

## Detailed Implementation Plan

- Add `Everett/Comparison/Collapse.lean` with a finite projective experiment,
  collapse masses, coherent branch vectors, and normalized branch conditionals.
- Prove branch norm-square/readout mass equality and total normalization.
- Prove that conditioning the correlated coherent output on a nonzero exact
  record gives the same eigenvector as the corresponding collapse update.
- Add two-level examples and a coherent-versus-mixture boundary diagnostic.
- Update comparison traceability and scope documentation.

## Build Structure

- The comparison leaf imports only measurement linearity, relative-state
  normalization, and branch-distribution infrastructure.
- Diagnostic examples remain in `Everett/Comparison/Examples.lean`.
- Focused/adjacent builds precede root and full builds.

## No-Cheating Checks

- Criteria remain distinct; no equality between a vector and density/mixture
  data is declared.
- Normalized branch conditionals require explicit nonzero branch hypotheses.
- All finiteness, normalization, orthonormality, and ideality hypotheses remain
  visible.
- Run proof-hole, axiom, shortcut, broad-import, interpretation, overclaim, and
  whitespace scans.

## Completion Requirements

- A named finite experiment class and named comparison criteria compile.
- Outcome/readout distributions and nonzero conditional states agree.
- Examples cover nonzero and zero branches and retain the coherent/mixture
  distinction.
- Source map and scope state exact coverage/exclusions; builds and scans pass.

## Stage Results

- `FiniteProjectiveExperiment` names the supported one-step ideal projective
  class and carries normalized input plus exact ideal measurement data.
- `unitaryReadoutMass_eq_collapseMass` proves pointwise branch/readout mass
  equality; `collapseDistribution` proves total normalization.
- `recordConditioned_eq` computes the intrinsic record-selected system vector.
  `unitaryConditional_eq_collapseConditional` proves exact normalized-vector
  equality only behind an explicit nonzero-amplitude hypothesis.
- `unitarySequenceMass_eq_collapseSequenceMass` and `sameSequenceMasses` extend
  the comparison to every history of any finite number of independently
  prepared repetitions, directly using the Stage 6/7 product amplitude.
- Two-level diagnostics compile one/zero branches, a nonzero conditional, and a
  three-step history comparison. `coherentPrediction` and
  `collapsedReadoutPrediction` deliberately have tensor-vector and finite-mass
  types respectively.
- Source and scope documentation now exclude arbitrary POVMs/channels,
  approximate instruments, adaptive/changing-basis sequences, continuous
  spectra, coherent-vector/mixture equality, and unrestricted equivalence.
- Focused, adjacent, root, and clean full builds pass with 2,973 jobs.
  Proof-hole/project-axiom, shortcut, broad-import, interpretation, overclaim,
  and whitespace scans pass.
