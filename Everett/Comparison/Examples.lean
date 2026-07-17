module

import Everett.Comparison.Collapse

/-!
# Finite collapse-comparison diagnostics
-/

namespace Everett.Comparison.Examples

open Everett.Comparison Everett.Measurement
open scoped TensorProduct

abbrev Qubit := EuclideanSpace ℂ (Fin 2)

noncomputable def basis : OrthonormalBasis (Fin 2) ℂ Qubit :=
  EuclideanSpace.basisFun (Fin 2) ℂ

noncomputable def ket0 : Qubit := EuclideanSpace.single 0 1

noncomputable def ket1 : Qubit := EuclideanSpace.single 1 1

noncomputable def measurement : IdealData
    (ι := Fin 2) (S := Qubit) (R := Qubit) where
  systemBasis := basis
  ready := ket0
  record := basis
  ready_norm := by simp [ket0]
  record_orthonormal := basis.orthonormal

noncomputable def deterministicExperiment :
    FiniteProjectiveExperiment (ι := Fin 2) (S := Qubit) (R := Qubit) where
  measurement := measurement
  input := ket0
  input_norm := by simp [ket0]

/-- The supported outcome-distribution comparison compiles for a two-level
experiment. -/
example : deterministicExperiment.SameOutcomeMasses :=
  deterministicExperiment.sameOutcomeMasses

theorem amplitude_zero_ne : deterministicExperiment.amplitude 0 ≠ 0 := by
  simp [FiniteProjectiveExperiment.amplitude, deterministicExperiment,
    measurement, basis, ket0]

/-- The nonzero conditional vector agrees exactly under both constructions. -/
example : deterministicExperiment.unitaryConditional 0 amplitude_zero_ne =
    deterministicExperiment.collapseConditional 0 amplitude_zero_ne :=
  deterministicExperiment.unitaryConditional_eq_collapseConditional 0 amplitude_zero_ne

theorem amplitude_one_eq_zero : deterministicExperiment.amplitude 1 = 0 := by
  simp [FiniteProjectiveExperiment.amplitude, deterministicExperiment,
    measurement, basis, ket0]

/-- A zero-mass branch remains unnormalized. -/
example : deterministicExperiment.collapseMass 1 = 0 := by
  exact deterministicExperiment.collapseMass_eq_zero_iff 1 |>.2 amplitude_one_eq_zero

/-- The coherent prediction and the collapsed readout prediction deliberately
have different types: a tensor vector versus finite classical mass data. -/
noncomputable def coherentPrediction : Qubit ⊗[ℂ] Qubit :=
  deterministicExperiment.coherentOutput

noncomputable def collapsedReadoutPrediction : Everett.Weights.FiniteDistribution (Fin 2) :=
  deterministicExperiment.collapseDistribution

example : (∑ i, collapsedReadoutPrediction.mass i) = 1 :=
  collapsedReadoutPrediction.sum_mass

/-- Three independent repetitions agree on every complete readout history. -/
example : deterministicExperiment.SameSequenceMasses 3 :=
  deterministicExperiment.sameSequenceMasses 3

end Everett.Comparison.Examples
