module

public import Everett.Records.Encoding

/-!
# Coherent history-indexed branches

The coherent vector sum and the associated real norm-square data are distinct
objects. No probability normalization or mixture is introduced here.
-/

@[expose] public section

namespace Everett.Records

open scoped ComplexConjugate

variable {Outcome H : Type*} {n : ℕ} [Fintype Outcome]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- History-indexed branch vectors together with their complex amplitudes. -/
structure Branches (Outcome : Type*) (n : ℕ) (H : Type*) [Fintype Outcome]
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] where
  amplitude : History Outcome n → ℂ
  vector : History Outcome n → H

namespace Branches

/-- One amplitude-weighted branch vector. -/
noncomputable def term (b : Branches Outcome n H) (h : History Outcome n) : H :=
  b.amplitude h • b.vector h

/-- The coherent global vector, retaining all phase information. -/
noncomputable def coherentState (b : Branches Outcome n H) : H :=
  ∑ h, b.term h

/-- Classical real data attached to a branch coefficient; not yet a probability. -/
noncomputable def normSquareData (b : Branches Outcome n H) (h : History Outcome n) : ℝ :=
  ‖b.amplitude h‖ ^ 2

/-- Total unnormalized norm-square data; this is not the coherent vector. -/
noncomputable def totalNormSquareData (b : Branches Outcome n H) : ℝ :=
  ∑ h, b.normSquareData h

/-- Distinct weighted branches are orthogonal when the underlying branch vectors are orthonormal. -/
theorem inner_term_eq_zero (b : Branches Outcome n H) (hv : Orthonormal ℂ b.vector)
    {h k : History Outcome n} (hne : h ≠ k) : inner ℂ (b.term h) (b.term k) = 0 := by
  simp [term, inner_smul_left, inner_smul_right, hv.inner_eq_zero hne]

/-- Under orthonormal branch vectors, each term has its coefficient norm square. -/
theorem norm_term_sq (b : Branches Outcome n H) (hv : Orthonormal ℂ b.vector)
    (h : History Outcome n) : ‖b.term h‖ ^ 2 = b.normSquareData h := by
  rw [show ‖b.term h‖ = ‖b.amplitude h‖ by
    rw [term, norm_smul, hv.norm_eq_one h, mul_one]]
  rfl

/-- Pythagoras for the coherent finite branch sum. -/
theorem norm_coherentState_sq (b : Branches Outcome n H)
    (hv : Orthonormal ℂ b.vector) :
    ‖b.coherentState‖ ^ 2 = b.totalNormSquareData := by
  classical
  rw [@norm_sq_eq_re_inner ℂ H]
  have hinner := hv.inner_sum b.amplitude b.amplitude Finset.univ
  rw [show inner ℂ b.coherentState b.coherentState =
      ∑ h, conj (b.amplitude h) * b.amplitude h by
    simpa [coherentState, term] using hinner]
  simp only [map_sum, totalNormSquareData, normSquareData]
  apply Finset.sum_congr rfl
  intro h _
  rw [← Complex.normSq_eq_conj_mul_self]
  rw [Complex.normSq_eq_norm_sq]
  norm_cast

end Branches

end Everett.Records
