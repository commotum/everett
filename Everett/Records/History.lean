module

public import Mathlib.Data.Fin.Tuple.Basic

/-!
# Length-indexed finite histories

A history is a total function on `Fin n`; its length is part of its type.
-/

@[expose] public section

namespace Everett.Records

/-- A length-`n` ordered sequence of outcomes. -/
abbrev History (Outcome : Type*) (n : ℕ) := Fin n → Outcome

namespace History

/-- The unique empty history. -/
def empty (Outcome : Type*) : History Outcome 0 :=
  fun i => Fin.elim0 i

/-- A one-event history. -/
def singleton {Outcome : Type*} (a : Outcome) : History Outcome 1 :=
  Fin.snoc (empty Outcome) a

/-- Append one outcome at the end of a history. -/
def snoc {Outcome : Type*} {n : ℕ} (h : History Outcome n) (a : Outcome) :
    History Outcome (n + 1) :=
  Fin.snoc h a

/-- Total lookup at an in-range position. -/
def lookup {Outcome : Type*} {n : ℕ} (h : History Outcome n) (i : Fin n) : Outcome :=
  h i

/-- Restrict a history to its first `k` entries. -/
def take {Outcome : Type*} {n k : ℕ} (h : History Outcome n) (hk : k ≤ n) :
    History Outcome k :=
  fun i => h (Fin.castLE hk i)

@[simp]
theorem lookup_snoc_castSucc {Outcome : Type*} {n : ℕ} (h : History Outcome n)
    (a : Outcome) (i : Fin n) : lookup (snoc h a) i.castSucc = lookup h i := by
  simp [lookup, snoc]

@[simp]
theorem lookup_snoc_last {Outcome : Type*} {n : ℕ} (h : History Outcome n)
    (a : Outcome) : lookup (snoc h a) (Fin.last n) = a := by
  simp [lookup, snoc]

@[simp]
theorem take_snoc {Outcome : Type*} {n : ℕ} (h : History Outcome n) (a : Outcome) :
    take (snoc h a) (Nat.le_succ n) = h := by
  funext i
  have hi : Fin.castLE (Nat.le_succ n) i = i.castSucc := Fin.ext rfl
  simp [take, snoc, hi]

/-- Appending the same last outcome is injective in the prior history. -/
theorem snoc_injective {Outcome : Type*} {n : ℕ} (a : Outcome) :
    Function.Injective (fun h : History Outcome n => snoc h a) := by
  intro h k heq
  funext i
  have := congrFun heq i.castSucc
  simpa only [snoc, Fin.snoc_castSucc] using this

/-- Split a nonempty history into its prefix and last outcome. -/
def snocEquiv (Outcome : Type*) (n : ℕ) :
    History Outcome n × Outcome ≃ History Outcome (n + 1) :=
  (Equiv.prodComm (History Outcome n) Outcome).trans
    (Fin.snocEquiv fun _ : Fin (n + 1) => Outcome)

@[simp]
theorem snocEquiv_apply {Outcome : Type*} {n : ℕ}
    (p : History Outcome n × Outcome) :
    snocEquiv Outcome n p = snoc p.1 p.2 := rfl

end History

end Everett.Records
