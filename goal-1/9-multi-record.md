# 9-MULTI-RECORD

## Current Facts

- Stages 4-6 provide exact measurements, repeat isometries, and history record
  encodings. No communication/copy map or sequential change-of-basis API exists.
- Images 8-9, printed pp. 461-462, were checked directly. Case 2 says the first
  record will **not in general** repeat; it does not assert universal
  disagreement for every input or every pair called noncommuting.
- Tensor-product `rTensor_comp_lTensor` and `lTensor_comp_rTensor` prove that
  maps on distinct factors compose to the same tensor map.

## Updated Assumptions

- Communication is an exact diagonal copy isometry on an orthonormal record
  basis. It is not cloning an arbitrary unknown vector; its domain theorem is
  stated on the distinguished record basis and extended linearly/isometrically.
- Sequential `A→B→A` branches are characterized by products of change-of-basis
  inner products. Possible disagreement requires explicit nonzero transitions.
- Remote invariance is a tensor-factor commutation theorem under explicit local
  maps, not a general slogan about “no effect whatsoever.”

## Big Picture Objective

- Formalize exact record communication/agreement, possible disagreement after
  an intervening basis, and locality for noninteracting tensor factors.

## Detailed Implementation Plan

- Add `Everett/Records/Multiple.lean` with diagonal copy map/isometry and exact
  basis agreement.
- Add `Everett/Measurement/Sequential.lean` with transition and `A→B→A`
  amplitudes, nonzero-disagreement criteria, and local-map commutation.
- Add a two-level diagnostic using a normalized superposition intermediate
  vector to exhibit a nonzero branch from one `A` label to the other.
- Update all three page-9 cases with exact theorem scope.

## Build Structure

- `Records.Multiple` imports only exact encoding/tensor basis APIs.
- `Measurement.Sequential` imports measurement linearity plus tensor maps.
- `Records.MultipleExamples` is diagnostic and consumes both.
- Focused and adjacent builds precede a full root build.

## No-Cheating Checks

- Copying must be restricted to an orthonormal distinguished family; no
  arbitrary-vector cloning theorem.
- Intervening-basis disagreement is existential/conditional, not universal.
- Locality theorem signatures expose both tensor factors and local maps.
- Run proof-hole, axiom, shortcut, broad-import, interpretation, cloning,
  universality, and whitespace scans.

## Completion Requirements

- Exact basis copy/agreement and same-basis repeat agreement compile.
- Change-of-basis product amplitudes and a concrete nonzero disagreement branch
  compile.
- Remote local interactions commute under explicit tensor-factor hypotheses.
- Page-9 cases and corrections are traceable; builds and scans pass.

## Stage Results

- `Everett.Records.Multiple` defines `diagonalFamily`, `copyMap`, and
  `copyIsometry`; `copyIsometry_basis` gives exact agreement on distinguished
  record basis states. The linear extension is not described as cloning an
  arbitrary superposition and no full unitary is claimed.
- `Everett.Measurement.Sequential` defines transition, `A→B→A`, and direct
  intermediate-vector amplitudes. `disagreement_possible` requires unequal
  endpoint labels and two explicit nonzero transitions.
- `local_maps_commute` supports arbitrary linear maps with changed codomains on
  distinct tensor factors. Diagnostics instantiate it both for record copying
  versus a remote interaction and for arbitrary local maps on a Bell vector.
- A normalized two-level superposition has unit norm and a proved nonzero
  `0 → unitPlus → 1` amplitude. This witnesses “not in general,” not universal
  disagreement.
- Focused builds pass. The source map, correction log, scope boundary, and root
  imports record the exact case-by-case status. Proof-hole/project-axiom,
  shortcut, broad-import, interpretation, cloning/universality, and whitespace
  scans pass. The clean full build passes with 2,971 jobs.
