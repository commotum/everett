# 5-RECORDS

## Current Facts

- Stages 1-4 provide finite complex Hilbert spaces and ideal measurement maps,
  but no reusable length-indexed history or coherent-branch API.
- Equation (9) was checked on local image 4, printed p. 457: its memory label is
  an ordered event list. Equation (18) and the branch label in (24) were checked
  on local image 6, printed p. 459. The OCR loses or garbles these indices.
- Equations (19)-(23) mix same-system repetition and independent copies. Those
  dynamics remain Stage 6; Stage 5 owns only neutral history and branch data.

## Updated Assumptions

- Use `History Outcome n := Fin n → Outcome`. This gives length in the type and
  makes lookup total; empty, singleton, append, and prefix operations remain
  explicit.
- An exact record encoding is an `OrthonormalBasis` indexed by histories. This
  is stronger than an orthonormal family but supplies the spanning hypothesis
  needed to construct a reusable append isometry without assuming an extension.
- A coherent sum is a vector. Its label/amplitude/norm-square summary is
  classical data but is not yet normalized and is not a probability measure.

## Big Picture Objective

- Build neutral finite-history infrastructure, exact orthonormal record
  encodings with isometric one-outcome extension, and coherent branch families
  with explicit orthogonality and norm-square identities.

## Detailed Implementation Plan

- Add `Everett/Records/History.lean` with `History`, `empty`, `singleton`,
  `snoc`, lookup, prefix-as-`take`, injectivity, and basic simp/extensionality
  theorems (`prefix` itself is reserved Lean syntax).
- Add `Everett/Records/Encoding.lean` with exact history-indexed record bases,
  canonical Euclidean encodings, orthonormal fixed-outcome append families,
  their induced linear isometry, and its basis action.
- Add `Everett/Records/Branches.lean` with history-indexed branch vectors and
  amplitudes, branch terms, coherent sums, real norm-square data, distinct-term
  orthogonality, and Pythagorean sum identities under explicit orthonormality.
- Add `Everett/Records/Examples.lean` covering empty, singleton, append, prefix,
  two distinct histories, an append isometry, and a small coherent sum.
- Update equations (9), (18), and (24) in source/correction documentation;
  retain (19)-(23) as Stage 6 obligations.

## Build Structure

- `Records.History` is pure finite data and imports the smallest Fin/Vector API.
- `Records.Encoding` owns Hilbert record encodings and imports `PiL2`.
- `Records.Branches` owns coherent algebra and imports `Encoding` plus only the
  finite orthogonal-sum lemmas it needs.
- `Records.Examples` is diagnostic and not a runtime dependency.
- Focused build: `lake build Everett.Records.History Everett.Records.Encoding
  Everett.Records.Branches`.
- Adjacent build: `lake build Everett.Records.Examples
  Everett.Measurement.Examples Everett`.

## No-Cheating Checks

- Scan record runtime leaves for probability-measure or density-operator types
  and for interpretative vocabulary.
- Confirm orthogonality theorems require an explicit `Orthonormal` hypothesis or
  arise from an `Encoding`; do not infer it from the word “record.”
- Confirm the append map is constructed with `isometryOfOrthonormal`, not stored
  as unexplained evidence in a record.
- Run proof-hole, project-axiom, shortcut, broad-import, import, and whitespace
  scans.

## Completion Requirements

- Empty/singleton/snoc/lookup/prefix operations and examples compile.
- Exact encodings construct a fixed-outcome append isometry and prove its action
  on every encoded history.
- Coherent state, branch term, amplitude data, and norm-square summary remain
  different definitions; no probability instance is introduced.
- Distinct branch orthogonality and coherent norm-square additivity compile only
  with visible orthonormality assumptions.
- Focused, adjacent, and full builds plus all scans pass; equations (9), (18),
  and (24) receive honest preliminary/final statuses.

## Stage Results

- `Everett.Records.History` defines `History Outcome n := Fin n → Outcome`,
  `empty`, `singleton`, `snoc`, `lookup`, and prefix-as-`take`, with append
  lookup, take-after-append, and append injectivity theorems. `prefix` was found
  to be reserved Lean syntax, so the API records the checked name change.
- `Everett.Records.Encoding` defines exact history-indexed orthonormal bases,
  canonical Euclidean encodings, `appendFamily_orthonormal`, `appendMap`, and
  `appendIsometry`. The isometry is constructed with
  `LinearMap.isometryOfOrthonormal`; `appendIsometry_basis` proves its action.
- `Everett.Records.Branches` separates `term`, coherent vector
  `coherentState`, coefficient `normSquareData`, and `totalNormSquareData`. It
  proves distinct-term orthogonality, individual term norm-square, and the
  coherent Pythagorean identity under an explicit `Orthonormal` hypothesis.
- Diagnostic examples compile the empty/singleton/append/take cases, distinct
  Boolean histories, exact record orthogonality, the append isometry, a
  `Complex.I` amplitude, and the coherent norm-square theorem.
- Failed proof attempts exposed only API/elaboration issues: reserved `prefix`,
  opaque noncomputable wrappers requiring `change`, and the need to rewrite
  complex conjugate products through `Complex.normSq`. No mathematical
  obligation was weakened.
- Focused runtime builds pass (2,340 jobs), adjacent/root examples pass, and a
  warning-free full build passes (2,959 jobs). Proof-hole, project-axiom,
  shortcut, import, interpretation, probability/density, explicit-evidence,
  and whitespace scans pass. The only probability/mixture text hits are module
  comments explicitly denying those structures.
- Equation (9) is corrected/formalized. Equation (18) is partial across the
  Stage 4 correlated sum and Stage 5 branch packaging. Equation (24) has a
  generic history-labeled branch, with its independent product instance owned
  by Stage 6 and weights by Stage 7.
