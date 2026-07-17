module

import Everett.Measurement.Repeatability
import Everett.Records.Independent

/-!
# Same-system and independent-copy repetition examples
-/

namespace Everett.Measurement.RepetitionExamples

open Everett.Measurement Everett.Records
open Everett.Records.Independent

abbrev Qubit := EuclideanSpace ℂ Bool

noncomputable def qubitBasis : OrthonormalBasis Bool ℂ Qubit :=
  EuclideanSpace.basisFun Bool ℂ

noncomputable def repeatAtOne : RepeatStepData
    (ι := Bool) (S := Qubit) (R := RecordSpace Bool 1) (R' := RecordSpace Bool 2)
    (n := 1) where
  systemBasis := qubitBasis
  records := encoding Bool 1
  nextRecords := encoding Bool 2

/-- A matching existing record is extended by the same nondemolished outcome. -/
example (i : Bool) :
    repeatAtOne.repeatIsometry
        (qubitBasis i ⊗ₜ[ℂ] (encoding Bool 1).state (History.singleton i)) =
      qubitBasis i ⊗ₜ[ℂ]
        (encoding Bool 2).state (History.snoc (History.singleton i) i) :=
  repeatAtOne.repeatIsometry_input i (History.singleton i)

/-- Boolean negation as an explicit change of basis labels. -/
def boolNotEquiv : Bool ≃ Bool where
  toFun := Bool.not
  invFun := Bool.not
  left_inv b := by cases b <;> rfl
  right_inv b := by cases b <;> rfl

noncomputable def changedBasis : OrthonormalBasis Bool ℂ Qubit :=
  qubitBasis.reindex boolNotEquiv

noncomputable def changedRepeat : RepeatStepData
    (ι := Bool) (S := Qubit) (R := RecordSpace Bool 1) (R' := RecordSpace Bool 2)
    (n := 1) where
  systemBasis := changedBasis
  records := encoding Bool 1
  nextRecords := encoding Bool 2

theorem changedBasis_true_eq_original_false : changedBasis true = qubitBasis false := by
  simp [changedBasis, boolNotEquiv]

theorem falseThenTrue_ne_falseThenFalse :
    History.snoc (History.singleton false) true ≠
      History.snoc (History.singleton false) false := by
  intro h
  have hlast := congrFun h (Fin.last 1)
  have ht : History.lookup (History.snoc (History.singleton false) true) (Fin.last 1) =
      true := History.lookup_snoc_last (History.singleton false) true
  have hf : History.lookup (History.snoc (History.singleton false) false) (Fin.last 1) =
      false := History.lookup_snoc_last (History.singleton false) false
  cases ht.symm.trans (hlast.trans hf)

/-- The changed basis labels the original `false` vector as `true`, so old-label repeatability fails. -/
example :
    changedRepeat.repeatIsometry
        (qubitBasis false ⊗ₜ[ℂ]
          (encoding Bool 1).state (History.singleton false)) =
      qubitBasis false ⊗ₜ[ℂ]
        (encoding Bool 2).state
          (History.snoc (History.singleton false) true) := by
  rw [← changedBasis_true_eq_original_false]
  exact changedRepeat.repeatIsometry_input true (History.singleton false)

variable (a : Bool → ℂ)

example : iteratedState a 0 = (encoding Bool 0).state (History.empty Bool) := rfl

example : iteratedState a 1 =
    branchingStep a 0 ((encoding Bool 0).state (History.empty Bool)) := rfl

example : iteratedState a 2 =
    branchingStep a 1
      (branchingStep a 0 ((encoding Bool 0).state (History.empty Bool))) := rfl

/-- The two-copy recursive state has the product-amplitude history expansion. -/
example : iteratedState a 2 =
    ∑ h : History Bool 2, (∏ k, a (h k)) • (encoding Bool 2).state h :=
  iteratedState_eq_sum a 2

end Everett.Measurement.RepetitionExamples
