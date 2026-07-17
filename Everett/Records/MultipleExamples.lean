module

import Everett.Records.Multiple
import Everett.Measurement.Sequential
import Mathlib.Analysis.Normed.Module.Normalize

/-!
# Multiple-record and sequential-measurement diagnostics
-/

namespace Everett.Records.MultipleExamples

open Everett.Measurement Everett.Records
open scoped TensorProduct

abbrev Qubit := EuclideanSpace ℂ (Fin 2)

noncomputable def ket0 : Qubit := EuclideanSpace.single 0 1

noncomputable def ket1 : Qubit := EuclideanSpace.single 1 1

noncomputable def qubitBasis : OrthonormalBasis (Fin 2) ℂ Qubit :=
  EuclideanSpace.basisFun (Fin 2) ℂ

/-- A canonical exact record basis is copied only on its distinguished states. -/
example (h : History Bool 2) :
    (Encoding.canonical Bool 2).copyIsometry
        ((Encoding.canonical Bool 2).state h) =
      (Encoding.canonical Bool 2).state h ⊗ₜ[ℂ]
        (Encoding.canonical Bool 2).state h :=
  Encoding.copyIsometry_basis _ h

/-- Copying an exact record commutes with an arbitrary linear interaction on a
distinct system factor, so their ordering does not change the tensor map. -/
example (g : Qubit →ₗ[ℂ] Qubit) (h : History Bool 2) :
    g.lTensor (EuclideanSpace ℂ (History Bool 2) ⊗[ℂ]
        EuclideanSpace ℂ (History Bool 2))
        ((Encoding.canonical Bool 2).copyMap.rTensor Qubit
          ((Encoding.canonical Bool 2).state h ⊗ₜ[ℂ] ket0)) =
      (Encoding.canonical Bool 2).copyMap.rTensor Qubit
        (g.lTensor (EuclideanSpace ℂ (History Bool 2))
          ((Encoding.canonical Bool 2).state h ⊗ₜ[ℂ] ket0)) :=
  local_maps_commute (Encoding.canonical Bool 2).copyMap g _

/-- A normalized superposition used as one vector of an intervening basis. -/
noncomputable def unitPlus : Qubit := NormedSpace.normalize (ket0 + ket1)

theorem ket0_add_ket1_ne_zero : ket0 + ket1 ≠ 0 := by
  intro h
  have := congrArg (fun x : Qubit => x 0) h
  simp [ket0, ket1] at this

@[simp]
theorem norm_unitPlus : ‖unitPlus‖ = 1 := by
  exact NormedSpace.norm_normalize ket0_add_ket1_ne_zero

noncomputable def bell : Qubit ⊗[ℂ] Qubit :=
  ket0 ⊗ₜ[ℂ] ket0 + ket1 ⊗ₜ[ℂ] ket1

/-- Local linear interactions commute even on an entangled two-qubit input. -/
example (f g : Qubit →ₗ[ℂ] Qubit) :
    g.lTensor Qubit (f.rTensor Qubit bell) =
      f.rTensor Qubit (g.lTensor Qubit bell) :=
  local_maps_commute f g bell

/-- The branch `0 → unitPlus → 1` has nonzero amplitude. This witnesses the
paper's “not in general” repeatability claim once `unitPlus` is a member of the
intervening measurement basis. -/
example : viaVectorAmplitude qubitBasis unitPlus 0 1 ≠ 0 := by
  change inner ℂ (‖ket0 + ket1‖⁻¹ • (ket0 + ket1)) (qubitBasis 0) *
    inner ℂ (qubitBasis 1) (‖ket0 + ket1‖⁻¹ • (ket0 + ket1)) ≠ 0
  rw [inner_smul_left_eq_smul, inner_smul_right_eq_smul]
  have hr : ‖ket0 + ket1‖⁻¹ ≠ 0 :=
    inv_ne_zero (norm_ne_zero_iff.mpr ket0_add_ket1_ne_zero)
  have h0 : inner ℂ (ket0 + ket1) (qubitBasis 0) = 1 := by
    rw [inner_add_left]
    simp [ket0, ket1, qubitBasis, EuclideanSpace.basisFun_apply,
      EuclideanSpace.inner_single_left]
  have h1 : inner ℂ (qubitBasis 1) (ket0 + ket1) = 1 := by
    simp [ket0, ket1, qubitBasis, EuclideanSpace.basisFun_apply,
      EuclideanSpace.inner_single_left]
  rw [h0, h1]
  exact mul_ne_zero (smul_ne_zero hr one_ne_zero) (smul_ne_zero hr one_ne_zero)

end Everett.Records.MultipleExamples
