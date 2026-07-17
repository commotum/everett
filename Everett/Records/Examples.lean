module

import Everett.Records.Branches

/-!
# Finite record and coherent-branch examples
-/

namespace Everett.Records.Examples

open Everett.Records

def noEvents : History Bool 0 := History.empty Bool

def falseEvent : History Bool 1 := History.singleton false

def trueEvent : History Bool 1 := History.singleton true

def falseThenTrue : History Bool 2 := History.snoc falseEvent true

example : History.lookup falseEvent 0 = false := by
  change History.lookup (History.snoc (History.empty Bool) false) (Fin.last 0) = false
  exact History.lookup_snoc_last (History.empty Bool) false

example : History.lookup falseThenTrue (Fin.last 1) = true := by
  change History.lookup (History.snoc falseEvent true) (Fin.last 1) = true
  exact History.lookup_snoc_last falseEvent true

example : History.take falseThenTrue (Nat.le_succ 1) = falseEvent := by
  exact History.take_snoc falseEvent true

theorem falseEvent_ne_trueEvent : falseEvent ≠ trueEvent := by
  intro h
  have hlast := congrArg (fun q => History.lookup q (Fin.last 0)) h
  have hf : History.lookup falseEvent (Fin.last 0) = false := by
    change History.lookup (History.snoc (History.empty Bool) false) (Fin.last 0) = false
    exact History.lookup_snoc_last (History.empty Bool) false
  have ht : History.lookup trueEvent (Fin.last 0) = true := by
    change History.lookup (History.snoc (History.empty Bool) true) (Fin.last 0) = true
    exact History.lookup_snoc_last (History.empty Bool) true
  exact Bool.false_ne_true (hf.symm.trans (hlast.trans ht))

abbrev RecordSpace (n : ℕ) := EuclideanSpace ℂ (History Bool n)

noncomputable def recordEncoding (n : ℕ) : Encoding Bool n (RecordSpace n) :=
  Encoding.canonical Bool n

example : inner ℂ ((recordEncoding 1).state falseEvent)
    ((recordEncoding 1).state trueEvent) = 0 := by
  exact (recordEncoding 1).basis.inner_eq_zero falseEvent_ne_trueEvent

noncomputable example : RecordSpace 1 →ₗᵢ[ℂ] RecordSpace 2 :=
  (recordEncoding 1).appendIsometry (recordEncoding 2) true

example :
    (recordEncoding 1).appendIsometry (recordEncoding 2) true
        ((recordEncoding 1).basis falseEvent) =
      (recordEncoding 2).state falseThenTrue := by
  exact (recordEncoding 1).appendIsometry_basis (recordEncoding 2) true falseEvent

noncomputable def oneStepBranches : Branches Bool 1 (RecordSpace 1) where
  amplitude h := if h = trueEvent then Complex.I else 1
  vector := (recordEncoding 1).basis

theorem oneStepBranches_orthonormal : Orthonormal ℂ oneStepBranches.vector :=
  (recordEncoding 1).basis.orthonormal

example : inner ℂ (oneStepBranches.term falseEvent)
    (oneStepBranches.term trueEvent) = 0 :=
  oneStepBranches.inner_term_eq_zero oneStepBranches_orthonormal
    falseEvent_ne_trueEvent

example : ‖oneStepBranches.coherentState‖ ^ 2 =
    oneStepBranches.totalNormSquareData :=
  oneStepBranches.norm_coherentState_sq oneStepBranches_orthonormal

end Everett.Records.Examples
