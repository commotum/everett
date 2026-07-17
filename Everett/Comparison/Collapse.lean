module

public import Everett.Measurement.Linearity
public import Everett.RelativeState.Normalization
public import Everett.Weights.Product

/-!
# Scoped comparison with finite ideal collapse predictions

This module compares outcome masses and nonzero conditional vectors for one
finite ideal projective measurement. It does not equate a coherent global
vector with a classical mixture.
-/

@[expose] public section

namespace Everett.Comparison

open Everett.Measurement Everett.RelativeState Everett.Weights
open scoped TensorProduct

variable {ι S R : Type*} [Fintype ι]
  [NormedAddCommGroup S] [InnerProductSpace ℂ S] [FiniteDimensional ℂ S]
  [NormedAddCommGroup R] [InnerProductSpace ℂ R] [FiniteDimensional ℂ R]

/-- The supported experiment class: one normalized input and one exact finite
ideal projective measurement with orthonormal outcome records. -/
structure FiniteProjectiveExperiment where
  measurement : IdealData (ι := ι) (S := S) (R := R)
  input : S
  input_norm : ‖input‖ = 1

namespace FiniteProjectiveExperiment

/-- Coefficient of the input in the measured eigenbasis. -/
noncomputable def amplitude (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R))
    (i : ι) : ℂ :=
  e.measurement.systemBasis.repr e.input i

/-- Conventional projective-collapse outcome mass. -/
noncomputable def collapseMass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) : ℝ :=
  ‖e.amplitude i‖ ^ 2

/-- The `i`th coherent system-record branch in the unitary record model. -/
noncomputable def coherentBranch
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) :
    S ⊗[ℂ] R :=
  e.amplitude i • e.measurement.toMeasurementData.output i

/-- The complete coherent correlated output, still a vector rather than a
classical mixture. -/
noncomputable def coherentOutput
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) : S ⊗[ℂ] R :=
  ∑ i, e.coherentBranch i

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem coherentOutput_eq_correlateIsometry
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) :
    e.coherentOutput = e.measurement.correlateIsometry e.input :=
  rfl

/-- Readout mass obtained as the squared norm of a coherent branch. -/
noncomputable def unitaryReadoutMass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) : ℝ :=
  ‖e.coherentBranch i‖ ^ 2

/-- First comparison criterion: pointwise equality of all finite outcome masses. -/
def SameOutcomeMasses
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) : Prop :=
  ∀ i, e.unitaryReadoutMass i = e.collapseMass i

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem unitaryReadoutMass_eq_collapseMass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) :
    e.unitaryReadoutMass i = e.collapseMass i := by
  change ‖e.amplitude i • e.measurement.toMeasurementData.output i‖ ^ 2 =
    ‖e.amplitude i‖ ^ 2
  rw [norm_smul, e.measurement.output_orthonormal.norm_eq_one, mul_one]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem sameOutcomeMasses
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) :
    e.SameOutcomeMasses :=
  e.unitaryReadoutMass_eq_collapseMass

/-- The conventional masses form a finite probability distribution. -/
noncomputable def collapseDistribution
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) :
    FiniteDistribution ι where
  mass := e.collapseMass
  nonnegative i := sq_nonneg ‖e.amplitude i‖
  sum_mass := by
    change ∑ i, ‖e.measurement.systemBasis.repr e.input i‖ ^ 2 = 1
    rw [← EuclideanSpace.norm_sq_eq,
      e.measurement.systemBasis.repr.norm_map, e.input_norm, one_pow]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem collapseDistribution_mass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) :
    e.collapseDistribution.mass i = e.collapseMass i :=
  rfl

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem amplitude_outcomeWeight_normalized
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) :
    ∑ i, outcomeWeight e.amplitude i = 1 := by
  simpa [outcomeWeight, collapseMass] using e.collapseDistribution.sum_mass

/-- Collapse prediction for an arbitrary finite history of independently
prepared repetitions of the supported one-step experiment. -/
noncomputable def collapseSequenceMass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) {n : ℕ}
    (h : Everett.Records.History ι n) : ℝ :=
  ∏ k, e.collapseMass (h k)

/-- Coherent-record mass supplied by the Stage 6 product-amplitude branch. -/
noncomputable def unitarySequenceMass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) {n : ℕ}
    (h : Everett.Records.History ι n) : ℝ :=
  sequenceWeight e.amplitude h

/-- Third comparison criterion: equality for every readout history of a fixed
finite independent repetition length. -/
def SameSequenceMasses
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (n : ℕ) : Prop :=
  ∀ h : Everett.Records.History ι n,
    e.unitarySequenceMass h = e.collapseSequenceMass h

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem unitarySequenceMass_eq_collapseSequenceMass
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) {n : ℕ}
    (h : Everett.Records.History ι n) :
    e.unitarySequenceMass h = e.collapseSequenceMass h := by
  simpa [unitarySequenceMass, collapseSequenceMass, collapseMass, outcomeWeight]
    using sequenceWeight_eq_prod e.amplitude h

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem sameSequenceMasses
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (n : ℕ) :
    e.SameSequenceMasses n :=
  fun h => e.unitarySequenceMass_eq_collapseSequenceMass h

/-- The common finite history distribution for the supported independent
repetition experiment. -/
noncomputable def sequenceReadoutDistribution
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (n : ℕ) :
    FiniteDistribution (Everett.Records.History ι n) :=
  sequenceDistribution e.amplitude e.amplitude_outcomeWeight_normalized n

/-- The system conditional selected by an exact record, expressed by swapping
the record factor to the selected side of the intrinsic conditional API. -/
noncomputable def recordConditioned
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) : S :=
  conditional (e.measurement.record i)
    (TensorProduct.comm ℂ S R e.coherentOutput)

theorem recordConditioned_eq
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) :
    e.recordConditioned i = e.amplitude i • e.measurement.systemBasis i := by
  classical
  unfold recordConditioned coherentOutput coherentBranch
  simp only [map_sum, map_smul, MeasurementData.output,
    TensorProduct.comm_tmul]
  change (conditionalMap (e.measurement.record i))
      (∑ x, e.amplitude x •
        (e.measurement.record x ⊗ₜ[ℂ] e.measurement.systemBasis x)) = _
  rw [map_sum]
  simp only [map_smul]
  change (∑ x, e.amplitude x • conditional (e.measurement.record i)
      (e.measurement.record x ⊗ₜ[ℂ] e.measurement.systemBasis x)) = _
  simp_rw [conditional_tmul]
  have hinner := orthonormal_iff_ite.mp e.measurement.record_orthonormal
  simp_rw [hinner]
  simp

theorem recordConditioned_ne_zero
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) {i : ι}
    (hi : e.amplitude i ≠ 0) : e.recordConditioned i ≠ 0 := by
  rw [e.recordConditioned_eq]
  exact smul_ne_zero hi (e.measurement.systemBasis.orthonormal.ne_zero i)

/-- Conventional normalized projection update on a nonzero outcome branch. -/
noncomputable def collapseConditional
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι)
    (_hi : e.amplitude i ≠ 0) : S :=
  NormedSpace.normalize (e.amplitude i • e.measurement.systemBasis i)

/-- Normalized unitary-record conditional on the same nonzero record branch. -/
noncomputable def unitaryConditional
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι)
    (hi : e.amplitude i ≠ 0) : S :=
  normalizedConditional (e.measurement.record i)
    (TensorProduct.comm ℂ S R e.coherentOutput) (e.recordConditioned_ne_zero hi)

/-- Second comparison criterion: exact equality of the normalized vector
representatives obtained by the same positive-real normalization convention. -/
def SameNonzeroConditionals
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) : Prop :=
  ∀ i (hi : e.amplitude i ≠ 0),
    e.unitaryConditional i hi = e.collapseConditional i hi

theorem unitaryConditional_eq_collapseConditional
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι)
    (hi : e.amplitude i ≠ 0) :
    e.unitaryConditional i hi = e.collapseConditional i hi := by
  rw [unitaryConditional, normalizedConditional, collapseConditional]
  change NormedSpace.normalize (e.recordConditioned i) = _
  rw [e.recordConditioned_eq]

theorem sameNonzeroConditionals
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) :
    e.SameNonzeroConditionals :=
  e.unitaryConditional_eq_collapseConditional

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem collapseMass_eq_zero_iff
    (e : FiniteProjectiveExperiment (ι := ι) (S := S) (R := R)) (i : ι) :
    e.collapseMass i = 0 ↔ e.amplitude i = 0 := by
  simp [collapseMass]

end FiniteProjectiveExperiment

end Everett.Comparison
