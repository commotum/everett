# Everett 1957 Source Map

## Evidence and status vocabulary

The primary local evidence is the PDF (SHA-256
`016afb29545d5e1475f660f694e5f7eea8f06f4682e7c0ed3430fe1adcf6b8f8`)
and page images. The OCR Markdown is a search aid, never equation evidence.
Images 3-9 were directly inspected on 2026-07-16. Every entry below has a final
status: formalized, corrected, split, assumption-qualified, analogue-only,
partial, excluded, or unresolved.

## Equations (1)-(9): relative states and continuous example

| Item | Location | Checked mathematical role | Final status |
|---|---|---|---|
| (1) | image 3, p. 456, left | Expansion of a bipartite state in product orthonormal bases with coefficients `a_ij`. | **Formalized:** `productBasis_reconstruction`; its coefficients are `(b.tensorProduct c).repr Ψ (i,j)`. |
| (2) | image 3, p. 456, left | Normalized second-subsystem relative state obtained from the `k`th coefficient row. | **Corrected and formalized:** Stage 2 supplies intrinsic `conditional`/`normalizedConditional`; `conditional_repr_apply` identifies every coefficient row, `coordinateConditional_eq_conditional` proves coordinate equality, and `coordinateConditional_basis_independent` proves complement-basis independence. Zero normalization remains explicitly unavailable. |
| (3) | image 3, p. 456, left | Reconstruction using a chosen first-system basis and normalized relative states. | **Corrected and formalized:** `reconstruction` gives the unnormalized sum; `normalized_reconstruction` and `normalizedReconstructionTerm` use the norm coefficient only for nonzero conditionals and contribute zero for zero rows. |
| (4) | image 3, p. 456, right | von Neumann interaction Hamiltonian `H_I=-iℏ q(∂/∂r)`. | **Unresolved continuous theorem / finite analogue only:** no domain or self-adjoint generator is supplied for the unbounded product of position and apparatus momentum. `Analytic.controlledShift` instead constructs a finite cyclic unitary permutation; it is not identified with this Hamiltonian. |
| (5) | image 3, p. 456, right | Evolved wavefunction `ψ_t^{S+A}(q,r)=φ(q)η(r-qt)`. | **Analogue-only:** `controlledShift_prepared` and `controlledShift_superposition` prove the exact finite basis shift/correlation. The continuous `L²(ℝ²)` shear/translation unitary and representative-level formula remain unresolved. |
| (6) | image 3, p. 456, right | `iℏ(∂ψ_t^{S+A}/∂t)=H_Iψ_t^{S+A}` for the stated initial conditions. | **Unresolved:** a strong Schrödinger equation needs a specified dense domain, generator/self-adjointness result, differentiability notion, and domain-preservation proof. The finite permutation has no claimed differential generator theorem. |
| (7) | image 3, p. 456, right | At `T`, `∫φ(q')δ(q-q')η(r-q'T)dq'`, decomposed by definite `q'`. | **Distributional/unresolved, with finite analogue:** Dirac delta is not encoded as an `L²` vector. `correlatedState` is an honest finite orthonormal-basis sum and `controlledShift_superposition` proves it, but this is not the displayed integral identity. |
| (8) | image 4, p. 457, left | `ξ^{r'}(q)=N_{r'}φ(q)η(r'-qT)`, plus the unnumbered reciprocal-square normalization integral. | **Analogue-only / continuous conditioning unresolved:** `conditional_correlatedState` selects an actual finite apparatus basis vector. Point evaluation at `r'` is not well-defined on an `L²` equivalence class; an honest result needs direct-integral/disintegration or representative/a.e. semantics and a nonzero normalization condition. The footnote's projection obstruction remains documented rather than contradicted. |
| (9) | image 4, p. 457, right | Memory configuration encoded as an ordered event list in the state label. | **Corrected and formalized:** `History Outcome n := Fin n → Outcome` gives a neutral, length-indexed ordered record with `empty`, `singleton`, `snoc`, lookup, and prefix-as-`take`; no mental-state terminology is encoded. |

## Equations (10)-(17) and Rules 1-2: ideal observation

| Item | Location | Checked mathematical role | Final status |
|---|---|---|---|
| (10) | image 5, p. 458, left | System eigenstate tensored with ready record state. | **Formalized:** `MeasurementData.input` and `IdealData.preparedInput`; the latter belongs to the actual prepared subspace. |
| (11) | image 5, p. 458, left | Same eigenstate correlated with its outcome record. | **Split and formalized:** `MeasurementData.output` is the family prescription; `PreparedSpanMap.map_prepared`, `PreparedIsometry.map_prepared`, and `FullUnitary.map_prepared` keep the three operator levels distinct. |
| (12) | image 5, p. 458, right | Correlated superposition for arbitrary system coefficients. | **Formalized:** both prepared-subspace and full-space `map_superposition` theorems derive it from linearity. |
| (13) | image 5, p. 458, right | Initial product with spectator systems. | **Formalized:** the input of `FullUnitary.map_prepared_with_spectator`. |
| (14) | image 5, p. 458, right | Final spectator-preserving correlated state. | **Formalized:** `FullUnitary.map_prepared_with_spectator` applies `TensorProduct.map` and leaves the spectator factor unchanged. |
| Rule 1 / (15) | image 5, p. 458, right | General observation rule with coefficients given by basis inner products. | **Corrected and formalized:** `MeasurementData.correlateMap` uses `systemBasis.repr` coefficients, `correlateMap_basis` proves the family rule, and `map_superposition` supplies arbitrary coefficients; none is an axiom. |
| (16) | image 5, p. 458, right | Superposed total state before a second observation. | **Formalized at two levels:** `linearMap_superposition_comp` is generic; `Independent.expandedState` is the concrete history-indexed coherent record state before the next branching step. |
| Rule 2 / (17) | image 5, p. 458, right | Apply the observation map termwise and superpose. | **Formalized:** `linearMap_superposition_comp` proves the abstract rule and `branchingStep_expandedState` proves its independent-copy record instance. |

## Equations (18)-(24): repetition and independent records

| Item | Location | Checked mathematical role | Final status |
|---|---|---|---|
| (18) | image 6, p. 459, left | Final state after one observation. | **Split and formalized:** Stage 4 proves the system-record correlated sum; `iteratedState_eq_sum` at length one supplies its canonical history-record coefficient expansion. |
| (19) | image 6, p. 459, left | Repeated observation of the same nondemolished system gives duplicate matching records. | **Corrected and formalized:** `RepeatStepData.repeatIsometry_input` preserves the system eigenvector and appends the same outcome to any existing history. `RepetitionExamples` checks an existing matching singleton record. |
| (20) | image 6, p. 459, left | Initial state for `n` separately prepared identical systems and a ready record. | **Partial abstraction:** `a : Outcome → ℂ` represents the common one-copy preparation and `iteratedState` begins at the empty exact record. The dormant tensor of all unmeasured system copies is intentionally not encoded in this record-evolution leaf. |
| (21) | image 6, p. 459, left | State after measuring the first independent copy. | **Formalized record/coefficient core:** `iteratedState` at one step and `iteratedState_eq_sum` give the one-history expansion. |
| (22) | image 6, p. 459, left | State after measuring the second independent copy. | **Formalized record/coefficient core:** the two-step recursive example and product-amplitude sum compile. |
| (23) | image 6, p. 459, left/right | Coherent sum after `r ≤ n` independent-copy measurements with product amplitude. | **Corrected and formalized at the reusable coefficient/record level:** `iteratedState_eq_sum` is proved for every finite length by induction from `branchingStep`; the paper's unmeasured spectator-copy tensor factors are suppressed, not equated with this record space. |
| (24) | image 6, p. 459, right | One branch vector labeled by a definite outcome history. | **Formalized:** `sequenceAmplitude` is the product along a `History`; `iteratedState_eq_sum` pairs it with the exact history record vector; `sequenceWeight` and `sequenceWeight_eq_prod` give its square weight and product form. |

## Equations (25)-(34): additive weights and products

| Item | Location | Checked mathematical role | Final status |
|---|---|---|---|
| (25) | image 7, p. 460, left | Regroup a finite orthogonal subfamily as `α φ' = Σ a_i φ_i`. | **Formalized algebraically:** `Branches.coherentState` is the coherent sum and `squareWeight_add_of_inner_eq_zero` gives the binary orthogonal regrouping law; `norm_coherentState_sq` gives the finite orthonormal-family form. |
| (26) | image 7, p. 460, right | Weight of regrouped element equals sum of component weights. | **Formalized:** squared norm is additive for orthogonal vectors and for the finite branch family under explicit orthonormality. |
| (27) | image 7, p. 460, right | Radial/additive equation after replacing coefficients by magnitudes. | **Corrected:** `radialWeight g z := g (‖z‖²)` makes the nonnegative argument and complex norm explicit. |
| (28) | image 7, p. 460, right | Define `g(x)=m(√x)` on nonnegative reals. | **Assumption-qualified:** the formal classification takes an explicit additive extension `g : ℝ →+ ℝ` and `NonnegativeOnNonnegative g`; the printed half-line-to-extension step is not silently assumed. |
| (29) | image 7, p. 460, right | `g(Σu_i²)=Σg(u_i²)`. | **Formalized through bundled additivity:** `g : ℝ →+ ℝ`; nonnegativity is a separate visible predicate. |
| (30) | image 7, p. 460, right | Claimed linear form `g(x)=cx`. | **Corrected and proved under sufficient hypotheses:** `additive_eq_mul` derives monotonicity and continuity from `NonnegativeOnNonnegative`, then proves `g x = g 1 * x`. No regularity axiom is assumed, but the all-real additive extension is stronger than the printed domain. |
| (31) | image 7, p. 460, right | Square-amplitude form `m(a_i)=c a_i* a_i`. | **Formalized:** `radialWeight_eq` proves `g 1 * ‖z‖²`, with nonnegativity and unit-phase invariance separately proved. |
| (32) | image 8, p. 461, left | Independent-copy branch vector from (24). | **Formalized:** `iteratedState_eq_sum` supplies the product-amplitude history branch. |
| (33) | image 8, p. 461, left | Branch weight is squared modulus of product amplitude. | **Formalized:** `sequenceWeight` is the squared norm of `sequenceAmplitude`. |
| (34) | image 8, p. 461, left | Branch weight factors as product of single-outcome weights. | **Formalized:** `sequenceWeight_eq_prod` and `sequenceDistribution_mass_eq_prod`; `sum_sequenceWeight` proves total normalization from one-step normalization. |

## Frequency claims

| Claim | Location | Checked wording/role | Final status |
|---|---|---|---|
| Product probability correspondence | image 8, p. 461, left | Treats `M_ij...k` as independent sequence probabilities. | **Formalized:** `sequenceDistribution` is total one, `sequenceDistribution_mass_eq_prod` factors its masses, and `productMass_outcomeDistribution_eq_sequenceMass` identifies the finite product masses used by the frequency theorems with squared-amplitude branch masses. |
| Long-sequence exceptional weight | image 8, p. 461, left | Says the exceptional total measure tends to zero and then speaks of measure-zero sequences. | **Corrected and split:** `exceptionalFrequencyMass_le` proves the finite bound `p(1-p)/(n ε²)` for `n>0`, `ε>0`; `exceptionalFrequencyMass_tendsto_zero` proves convergence in probability along lengths `n+1`. The infinite-sequence measure-zero/almost-sure claim is **unresolved** because no infinite product process was constructed. |
| “Nearly zero,” “almost all,” “in the limit” | image 8, p. 461, right | Summary for arbitrary sequences and transition probabilities. | **Corrected:** “nearly zero” is the explicit Chebyshev upper bound and “in the limit” is a `Filter.Tendsto` statement for exceptional finite-history mass. “Almost all” is not used as a substitute for an almost-sure theorem. The result is for a fixed target outcome and positive tolerance, not the printed unrestricted “any functions” wording. |

## Multiple-record cases

| Case | Location | Checked claim | Final status |
|---|---|---|---|
| 1. Same quantity and communication | images 8-9, pp. 461-462 | Multiple records agree; ordering includes communication before a later observation. | **Split and formalized:** `RepeatStepData.repeatIsometry_input` proves same-basis nondemolition agreement; `Encoding.copyIsometry_basis` copies a distinguished exact record state into two agreeing records. `local_maps_commute`, instantiated by `MultipleExamples`, proves that this copy map commutes with a linear operation on a distinct tensor factor. This is basis-state communication, not arbitrary-state cloning or a claimed full-space unitary. |
| 2. `A`, then incompatible `B`, then `A` | image 9, p. 462 | First record will **not in general** repeat; intervening noncommuting observation prevents a general one-to-one correlation. | **Corrected and formalized:** `abaAmplitude` is the product of the two change-of-basis amplitudes; `disagreement_possible` requires an unequal pair of `A` labels and explicit nonzero transitions. The normalized two-level `unitPlus` diagnostic proves a concrete nonzero `0 → unitPlus → 1` branch. No theorem says every noncommuting pair or every input disagrees. |
| 3. Correlated noninteracting systems | image 9, p. 462 | Remote observation does not disturb the first local system's repeat observation under the stated noninteraction setup. | **Assumption-qualified and formalized:** `local_maps_commute` proves equality of the two orderings for arbitrary linear maps acting on distinct tensor factors, including different codomains. A Bell-vector diagnostic checks the theorem on an entangled input. The result is tensor-factor locality, not an unrestricted no-signalling theorem. |

## Comparison and interpretative prose

| Item | Location | Final status |
|---|---|---|
| Agreement with conventional external-observation formalism where applicable | image 9, p. 462 | **Assumption-qualified and formalized:** `FiniteProjectiveExperiment` covers one normalized finite-dimensional input, an orthonormal projective system basis, and exact orthonormal records. `SameOutcomeMasses`/`sameOutcomeMasses` compare all one-step readout masses; `SameNonzeroConditionals`/`sameNonzeroConditionals` compare normalized conditional vectors only on nonzero branches; `SameSequenceMasses`/`sameSequenceMasses` cover arbitrary finite histories of independently prepared repetitions. This does not claim equality of the coherent vector with a mixture or cover arbitrary experiments. |
| Awareness, experience, actuality, world splitting, and metaphysical conclusions | pp. 456-462, especially image 6 footnote and discussion | Excluded from theorem statements; documentation context only. |
| Continuous generalized-eigenstate interpretation | images 3-4, pp. 456-457 | **Analogue-only/unresolved:** the finite controlled-shift analogue compiles; the continuous distributional and sharp-conditioning obligations are stated in `docs/analytic-edge.md`. |
