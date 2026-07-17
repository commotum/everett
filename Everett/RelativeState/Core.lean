module

public import Mathlib.Analysis.InnerProductSpace.TensorProduct

/-!
# Intrinsic conditional vectors

The unnormalized conditional vector is the adjoint contraction of a bipartite
vector against a selected vector in the first tensor factor.
-/

@[expose] public section

namespace Everett.RelativeState

open scoped ComplexConjugate InnerProduct TensorProduct

variable {H₁ H₂ : Type*}
  [NormedAddCommGroup H₁] [InnerProductSpace ℂ H₁] [FiniteDimensional ℂ H₁]
  [NormedAddCommGroup H₂] [InnerProductSpace ℂ H₂] [FiniteDimensional ℂ H₂]

/-- Tensor a varying second-factor vector on the left by the fixed vector `x`. -/
noncomputable def tensorLeft (x : H₁) : H₂ →L[ℂ] H₁ ⊗[ℂ] H₂ :=
  ((TensorProduct.mk ℂ H₁ H₂) x).mkContinuous ‖x‖ fun y => by simp

omit [FiniteDimensional ℂ H₁] [FiniteDimensional ℂ H₂] in
@[simp]
theorem tensorLeft_apply (x : H₁) (y : H₂) : tensorLeft x y = x ⊗ₜ[ℂ] y := rfl

omit [FiniteDimensional ℂ H₁] [FiniteDimensional ℂ H₂] in
theorem tensorLeft_norm_le (x : H₁) : ‖tensorLeft (H₂ := H₂) x‖ ≤ ‖x‖ := by
  exact LinearMap.mkContinuous_norm_le ((TensorProduct.mk ℂ H₁ H₂) x)
    (norm_nonneg x) fun y => by simp

/--
The intrinsic unnormalized conditional-vector map relative to `x`.

It is the adjoint of `y ↦ x ⊗ₜ y`, so it is defined without choosing a basis.
-/
noncomputable def conditionalMap (x : H₁) : H₁ ⊗[ℂ] H₂ →L[ℂ] H₂ := by
  letI : CompleteSpace H₂ := FiniteDimensional.complete ℂ H₂
  letI : CompleteSpace (H₁ ⊗[ℂ] H₂) := FiniteDimensional.complete ℂ _
  exact (tensorLeft x)†

/-- The total, unnormalized conditional vector. It may be zero. -/
noncomputable def conditional (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) : H₂ :=
  conditionalMap x Ψ

/-- Intrinsic characterization of the conditional vector by partial inner product. -/
theorem inner_conditional (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) (y : H₂) :
    inner ℂ y (conditional x Ψ) = inner ℂ (x ⊗ₜ[ℂ] y) Ψ := by
  letI : CompleteSpace H₂ := FiniteDimensional.complete ℂ H₂
  letI : CompleteSpace (H₁ ⊗[ℂ] H₂) := FiniteDimensional.complete ℂ _
  exact ContinuousLinearMap.adjoint_inner_right (tensorLeft x) y Ψ

@[simp]
theorem conditional_tmul (x u : H₁) (v : H₂) :
    conditional x (u ⊗ₜ[ℂ] v) = inner ℂ x u • v := by
  apply ext_inner_left ℂ
  intro y
  rw [inner_conditional, TensorProduct.inner_tmul, inner_smul_right]

@[simp]
theorem conditional_zero_state (x : H₁) :
    conditional x (0 : H₁ ⊗[ℂ] H₂) = 0 := by
  exact (conditionalMap x).map_zero

@[simp]
theorem conditional_add_state (x : H₁) (Ψ Φ : H₁ ⊗[ℂ] H₂) :
    conditional x (Ψ + Φ) = conditional x Ψ + conditional x Φ := by
  exact (conditionalMap x).map_add Ψ Φ

@[simp]
theorem conditional_smul_state (x : H₁) (c : ℂ) (Ψ : H₁ ⊗[ℂ] H₂) :
    conditional x (c • Ψ) = c • conditional x Ψ := by
  exact (conditionalMap x).map_smul c Ψ

@[simp]
theorem conditional_zero_selected (Ψ : H₁ ⊗[ℂ] H₂) :
    conditional (0 : H₁) Ψ = 0 := by
  apply ext_inner_left ℂ
  intro y
  simp [inner_conditional]

theorem conditional_add_selected (x z : H₁) (Ψ : H₁ ⊗[ℂ] H₂) :
    conditional (x + z) Ψ = conditional x Ψ + conditional z Ψ := by
  apply ext_inner_left ℂ
  intro y
  simp only [inner_conditional, TensorProduct.add_tmul, inner_add_left, inner_add_right]

theorem conditional_smul_selected (c : ℂ) (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) :
    conditional (c • x) Ψ = conj c • conditional x Ψ := by
  apply ext_inner_left ℂ
  intro y
  rw [inner_conditional, inner_smul_right, inner_conditional]
  rw [← TensorProduct.smul_tmul' (R := ℂ) c x y]
  exact inner_smul_left (x ⊗ₜ[ℂ] y) Ψ c

theorem conditional_norm_le (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) :
    ‖conditional x Ψ‖ ≤ ‖x‖ * ‖Ψ‖ := by
  letI : CompleteSpace H₂ := FiniteDimensional.complete ℂ H₂
  letI : CompleteSpace (H₁ ⊗[ℂ] H₂) := FiniteDimensional.complete ℂ _
  calc
    ‖conditional x Ψ‖ ≤ ‖conditionalMap x‖ * ‖Ψ‖ :=
      (conditionalMap x).le_opNorm Ψ
    _ = ‖tensorLeft x‖ * ‖Ψ‖ := by
      rw [conditionalMap, LinearIsometryEquiv.norm_map]
    _ ≤ ‖x‖ * ‖Ψ‖ := by
      gcongr
      exact tensorLeft_norm_le (H₂ := H₂) x

/-- A basis-free exact criterion for a zero conditional vector. -/
theorem conditional_eq_zero_iff (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) :
    conditional x Ψ = 0 ↔ ∀ y : H₂, inner ℂ (x ⊗ₜ[ℂ] y) Ψ = 0 := by
  constructor
  · intro h y
    rw [← inner_conditional, h, inner_zero_right]
  · intro h
    apply ext_inner_left ℂ
    intro y
    rw [inner_conditional, h, inner_zero_right]

@[simp]
theorem conditional_tmul_eq_zero_iff (x u : H₁) (v : H₂) :
    conditional x (u ⊗ₜ[ℂ] v) = 0 ↔ inner ℂ x u = 0 ∨ v = 0 := by
  simp

end Everett.RelativeState
