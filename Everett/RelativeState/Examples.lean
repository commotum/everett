module

import Everett.RelativeState.Reconstruction
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Finite-dimensional conditional-vector examples

Two-level examples exercising pure tensors, zero and orthogonal branches,
entanglement, normalization, and a non-real phase.
-/

namespace Everett.RelativeState.Examples

open Everett.RelativeState
open scoped ComplexConjugate TensorProduct

abbrev Qubit := EuclideanSpace ℂ (Fin 2)

noncomputable def ket0 : Qubit := EuclideanSpace.single 0 1

noncomputable def ket1 : Qubit := EuclideanSpace.single 1 1

noncomputable def qubitBasis : OrthonormalBasis (Fin 2) ℂ Qubit :=
  EuclideanSpace.basisFun (Fin 2) ℂ

@[simp]
theorem norm_ket0 : ‖ket0‖ = 1 := by simp [ket0]

@[simp]
theorem norm_ket1 : ‖ket1‖ = 1 := by simp [ket1]

theorem ket0_ne_zero : ket0 ≠ 0 := by
  simp [ket0]

theorem ket1_ne_zero : ket1 ≠ 0 := by
  simp [ket1]

@[simp]
theorem inner_ket0_ket1 : inner ℂ ket0 ket1 = 0 := by
  simp [ket0, ket1, EuclideanSpace.inner_single_left]

@[simp]
theorem inner_ket0_ket0 : inner ℂ ket0 ket0 = 1 := by
  rw [inner_self_eq_norm_sq_to_K]
  simp

example : conditional ket0 (ket0 ⊗ₜ[ℂ] ket1) = ket1 := by
  simp [ket0]

example : conditional ket0 (0 : Qubit ⊗[ℂ] Qubit) = 0 := by simp

example : conditional ket0 (ket1 ⊗ₜ[ℂ] ket0) = 0 := by simp

noncomputable def bell : Qubit ⊗[ℂ] Qubit :=
  ket0 ⊗ₜ[ℂ] ket0 + ket1 ⊗ₜ[ℂ] ket1

@[simp]
theorem conditional_bell_ket0 : conditional ket0 bell = ket0 := by
  simp only [bell, conditional_add_state, conditional_tmul, inner_ket0_ket0,
    inner_ket0_ket1, one_smul, zero_smul, add_zero]

example : bell = ∑ i, qubitBasis i ⊗ₜ[ℂ] conditional (qubitBasis i) bell :=
  reconstruction qubitBasis bell

example : normalizedConditional ket0 bell (by simp [ket0_ne_zero]) = ket0 := by
  apply normalizedConditional_unique
  · exact norm_ket0
  · simp

/-- A non-real phase catches conjugation orientation in the selected vector. -/
example : conditional (Complex.I • ket0) bell = conj Complex.I • ket0 := by
  rw [conditional_smul_selected, conditional_bell_ket0]

noncomputable def complexEntangled : Qubit ⊗[ℂ] Qubit :=
  (Complex.I • ket0) ⊗ₜ[ℂ] ket1 + ket1 ⊗ₜ[ℂ] ket0

@[simp]
theorem conditional_complexEntangled_ket0 :
    conditional ket0 complexEntangled = Complex.I • ket1 := by
  simp [complexEntangled, inner_smul_right]

example :
    coordinateConditional qubitBasis qubitBasis 0 complexEntangled =
      Complex.I • ket1 := by
  rw [coordinateConditional_eq_conditional]
  simpa [qubitBasis, ket0, EuclideanSpace.basisFun_apply] using
    conditional_complexEntangled_ket0

/-- The normalized reconstruction also compiles when one basis branch is zero. -/
example :
    ket0 ⊗ₜ[ℂ] ket0 =
      ∑ i, normalizedReconstructionTerm qubitBasis (ket0 ⊗ₜ[ℂ] ket0) i :=
  normalized_reconstruction qubitBasis (ket0 ⊗ₜ[ℂ] ket0)

end Everett.RelativeState.Examples
