module

public import Everett.RelativeState.Core
public import Mathlib.Analysis.Normed.Module.Normalize

/-!
# Normalized conditional vectors and phase behavior

Normalization is exposed only with evidence that the intrinsic unnormalized
conditional vector is nonzero.
-/

@[expose] public section

namespace Everett.RelativeState

open scoped ComplexConjugate TensorProduct

variable {H₁ H₂ : Type*}
  [NormedAddCommGroup H₁] [InnerProductSpace ℂ H₁] [FiniteDimensional ℂ H₁]
  [NormedAddCommGroup H₂] [InnerProductSpace ℂ H₂] [FiniteDimensional ℂ H₂]

/-- Normalize a conditional vector, requiring explicit evidence that it is nonzero. -/
noncomputable def normalizedConditional (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (_h : conditional x Ψ ≠ 0) : H₂ :=
  NormedSpace.normalize (conditional x Ψ)

theorem normalizedConditional_formula (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) :
    normalizedConditional x Ψ h = ‖conditional x Ψ‖⁻¹ • conditional x Ψ := rfl

@[simp]
theorem norm_normalizedConditional (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) : ‖normalizedConditional x Ψ h‖ = 1 := by
  exact NormedSpace.norm_normalize h

theorem normalizedConditional_ne_zero (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) : normalizedConditional x Ψ h ≠ 0 := by
  exact (NormedSpace.normalize_eq_zero_iff (conditional x Ψ)).not.mpr h

theorem norm_smul_normalizedConditional (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) :
    ‖conditional x Ψ‖ • normalizedConditional x Ψ h = conditional x Ψ := by
  exact NormedSpace.norm_smul_normalize (conditional x Ψ)

/-- A unit vector on the same positive real ray as the conditional is unique. -/
theorem normalizedConditional_unique (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) (z : H₂) (hz : ‖z‖ = 1)
    (hfactor : conditional x Ψ = ‖conditional x Ψ‖ • z) :
    normalizedConditional x Ψ h = z := by
  rw [normalizedConditional, hfactor,
    NormedSpace.normalize_smul_of_pos (norm_pos_iff.mpr h),
    NormedSpace.normalize_eq_self_of_norm_eq_one hz]

omit [FiniteDimensional ℂ H₂] in
/-- Normalization commutes with multiplication by a complex scalar of norm one. -/
theorem normalize_smul_of_norm_one (c : ℂ) (hc : ‖c‖ = 1) (z : H₂) :
    NormedSpace.normalize (c • z) = c • NormedSpace.normalize z := by
  simpa [NormedSpace.normalize, norm_smul, hc] using
    (smul_comm (‖z‖⁻¹ : ℝ) c z)

/-- A unit selected-vector phase preserves nonzeroness of the conditional. -/
theorem conditional_smul_selected_ne_zero (c : ℂ) (hc : ‖c‖ = 1)
    (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) (h : conditional x Ψ ≠ 0) :
    conditional (c • x) Ψ ≠ 0 := by
  rw [conditional_smul_selected]
  apply smul_ne_zero
  · intro hconj
    have hc0 : c = 0 := by simpa using congrArg conj hconj
    simp [hc0] at hc
  · exact h

/-- Selected-vector unit-phase covariance with nonzeroness propagated. -/
theorem normalizedConditional_smul_selected (c : ℂ) (hc : ‖c‖ = 1)
    (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) :
    normalizedConditional (c • x) Ψ
        (conditional_smul_selected_ne_zero c hc x Ψ h) =
      conj c • normalizedConditional x Ψ h := by
  rw [normalizedConditional, normalizedConditional, conditional_smul_selected]
  exact normalize_smul_of_norm_one (conj c) (by simpa using hc) (conditional x Ψ)

/-- A unit phase on the bipartite state preserves conditional nonzeroness. -/
theorem conditional_smul_state_ne_zero (c : ℂ) (hc : ‖c‖ = 1)
    (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) (h : conditional x Ψ ≠ 0) :
    conditional x (c • Ψ) ≠ 0 := by
  rw [conditional_smul_state]
  apply smul_ne_zero
  · intro hc0
    simp [hc0] at hc
  · exact h

/-- Bipartite-state unit-phase covariance with nonzeroness propagated. -/
theorem normalizedConditional_smul_state (c : ℂ) (hc : ‖c‖ = 1)
    (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) (h : conditional x Ψ ≠ 0) :
    normalizedConditional x (c • Ψ)
        (conditional_smul_state_ne_zero c hc x Ψ h) =
      c • normalizedConditional x Ψ h := by
  rw [normalizedConditional, normalizedConditional, conditional_smul_state]
  exact normalize_smul_of_norm_one c hc (conditional x Ψ)

/-- Explicit phase equivalence, used instead of silently identifying vectors with rays. -/
def PhaseEquivalent (v w : H₂) : Prop :=
  ∃ c : ℂ, ‖c‖ = 1 ∧ w = c • v

omit [FiniteDimensional ℂ H₂] in
@[refl]
theorem phaseEquivalent_refl (v : H₂) : PhaseEquivalent v v :=
  ⟨1, by simp, by simp⟩

theorem normalizedConditional_phaseEquivalent_selected (c : ℂ) (hc : ‖c‖ = 1)
    (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂)
    (h : conditional x Ψ ≠ 0) :
    PhaseEquivalent (normalizedConditional x Ψ h)
      (normalizedConditional (c • x) Ψ
        (conditional_smul_selected_ne_zero c hc x Ψ h)) := by
  exact ⟨conj c, by simpa using hc,
    normalizedConditional_smul_selected c hc x Ψ h⟩

theorem normalizedConditional_phaseEquivalent_state (c : ℂ) (hc : ‖c‖ = 1)
    (x : H₁) (Ψ : H₁ ⊗[ℂ] H₂) (h : conditional x Ψ ≠ 0) :
    PhaseEquivalent (normalizedConditional x Ψ h)
      (normalizedConditional x (c • Ψ)
        (conditional_smul_state_ne_zero c hc x Ψ h)) := by
  exact ⟨c, hc, normalizedConditional_smul_state c hc x Ψ h⟩

end Everett.RelativeState
