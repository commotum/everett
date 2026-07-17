module

public import Everett.Measurement.Core
public import Everett.Records.Encoding

/-!
# Same-system nondemolition repetition

This leaf is deliberately separate from independent-copy sequence branching.
-/

@[expose] public section

namespace Everett.Measurement

open scoped TensorProduct
open Everett.Records

variable {ι S R R' : Type*} {n : ℕ} [Fintype ι]
  [NormedAddCommGroup S] [InnerProductSpace ℂ S] [FiniteDimensional ℂ S]
  [NormedAddCommGroup R] [InnerProductSpace ℂ R] [FiniteDimensional ℂ R]
  [NormedAddCommGroup R'] [InnerProductSpace ℂ R'] [FiniteDimensional ℂ R']

/-- Data for appending a repeat record while preserving a system eigenstate. -/
structure RepeatStepData where
  systemBasis : OrthonormalBasis ι ℂ S
  records : Encoding ι n R
  nextRecords : Encoding ι (n + 1) R'

namespace RepeatStepData

/-- System eigenstate with an existing history record. -/
noncomputable def input (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n))
    (p : ι × History ι n) : S ⊗[ℂ] R :=
  m.systemBasis p.1 ⊗ₜ[ℂ] m.records.state p.2

/-- The same eigenstate with its own outcome appended to the history. -/
noncomputable def output (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n))
    (p : ι × History ι n) : S ⊗[ℂ] R' :=
  m.systemBasis p.1 ⊗ₜ[ℂ] m.nextRecords.state (History.snoc p.2 p.1)

/-- The complete orthonormal input basis. -/
noncomputable def inputBasis
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n)) :
    OrthonormalBasis (ι × History ι n) ℂ (S ⊗[ℂ] R) :=
  m.systemBasis.tensorProduct m.records.basis

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] [FiniteDimensional ℂ R'] in
@[simp]
theorem inputBasis_apply
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n))
    (p : ι × History ι n) : m.inputBasis p = m.input p := by
  rw [show m.inputBasis p =
      m.systemBasis p.1 ⊗ₜ[ℂ] m.records.basis p.2 by
    exact m.systemBasis.tensorProduct_apply' m.records.basis p]
  rfl

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] [FiniteDimensional ℂ R'] in
/-- Controlled repeat outputs are orthonormal. -/
theorem output_orthonormal
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n)) :
    Orthonormal ℂ m.output := by
  constructor
  · intro p
    rw [show m.output p = m.systemBasis p.1 ⊗ₜ[ℂ]
        m.nextRecords.basis (History.snoc p.2 p.1) by rfl]
    simp [m.systemBasis.orthonormal.norm_eq_one,
      m.nextRecords.basis.orthonormal.norm_eq_one]
  · intro p q hpq
    by_cases hi : p.1 = q.1
    · have hh : p.2 ≠ q.2 := by
        intro h
        exact hpq (Prod.ext hi h)
      have hs : History.snoc p.2 p.1 ≠ History.snoc q.2 q.1 := by
        intro h
        apply hh
        apply History.snoc_injective p.1
        simpa [hi] using h
      rw [show inner ℂ (m.output p) (m.output q) =
          inner ℂ (m.systemBasis p.1) (m.systemBasis q.1) *
            inner ℂ (m.nextRecords.basis (History.snoc p.2 p.1))
              (m.nextRecords.basis (History.snoc q.2 q.1)) by
        exact TensorProduct.inner_tmul ℂ _ _ _ _]
      rw [m.nextRecords.basis.inner_eq_zero hs, mul_zero]
    · rw [show inner ℂ (m.output p) (m.output q) =
          inner ℂ (m.systemBasis p.1) (m.systemBasis q.1) *
            inner ℂ (m.nextRecords.basis (History.snoc p.2 p.1))
              (m.nextRecords.basis (History.snoc q.2 q.1)) by
        exact TensorProduct.inner_tmul ℂ _ _ _ _]
      rw [m.systemBasis.inner_eq_zero hi, zero_mul]

/-- Linear controlled-repeat map determined on the complete input basis. -/
noncomputable def repeatMap
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n)) :
    S ⊗[ℂ] R →ₗ[ℂ] S ⊗[ℂ] R' where
  toFun x := ∑ p, m.inputBasis.repr x p • m.output p
  map_add' x y := by simp [map_add, add_smul, Finset.sum_add_distrib]
  map_smul' c x := by simp [map_smul, smul_smul, Finset.smul_sum]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] [FiniteDimensional ℂ R'] in
@[simp]
theorem repeatMap_input
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n))
    (p : ι × History ι n) : m.repeatMap (m.input p) = m.output p := by
  classical
  rw [← m.inputBasis_apply p]
  change (∑ x, m.inputBasis.repr (m.inputBasis p) x • m.output x) = m.output p
  rw [m.inputBasis.repr_self]
  simp [EuclideanSpace.single]

/-- The controlled repeat map is an isometry. -/
noncomputable def repeatIsometry
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n)) :
    S ⊗[ℂ] R →ₗᵢ[ℂ] S ⊗[ℂ] R' :=
  m.repeatMap.isometryOfOrthonormal (v := m.inputBasis.toBasis)
    m.inputBasis.orthonormal (by
      have heq : (m.repeatMap ∘ m.inputBasis.toBasis :
          ι × History ι n → S ⊗[ℂ] R') = m.output := by
        funext p
        change m.repeatMap (m.inputBasis p) = m.output p
        rw [m.inputBasis_apply]
        exact m.repeatMap_input p
      rw [heq]
      exact m.output_orthonormal)

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] [FiniteDimensional ℂ R'] in
/-- Same-system repeatability: preserve the eigenstate and append the same outcome. -/
@[simp]
theorem repeatIsometry_input
    (m : RepeatStepData (ι := ι) (S := S) (R := R) (R' := R') (n := n))
    (i : ι) (h : History ι n) :
    m.repeatIsometry (m.systemBasis i ⊗ₜ[ℂ] m.records.state h) =
      m.systemBasis i ⊗ₜ[ℂ] m.nextRecords.state (History.snoc h i) :=
  m.repeatMap_input (i, h)

end RepeatStepData

end Everett.Measurement
