module

import Everett.Weights.Product

/-!
# Finite additive and product-weight examples
-/

namespace Everett.Weights.Examples

open Everett.Records Everett.Records.Independent

def nonnegative_id : NonnegativeOnNonnegative (AddMonoidHom.id ℝ) :=
  fun x hx => by simpa using hx

example (x : ℝ) : AddMonoidHom.id ℝ x = AddMonoidHom.id ℝ 1 * x :=
  additive_eq_mul (AddMonoidHom.id ℝ) nonnegative_id x

example : radialWeight (AddMonoidHom.id ℝ) Complex.I = 1 := by
  simp [radialWeight]

/-- A normalized family with an explicit zero branch and a non-real branch. -/
noncomputable def boolAmplitude : Bool → ℂ
  | false => 0
  | true => Complex.I

theorem boolAmplitude_normalized : ∑ i, outcomeWeight boolAmplitude i = 1 := by
  simp [outcomeWeight, boolAmplitude]

noncomputable def boolOutcomeDistribution : FiniteDistribution Bool :=
  outcomeDistribution boolAmplitude boolAmplitude_normalized

example : boolOutcomeDistribution.mass false = 0 := by
  simp [boolOutcomeDistribution, outcomeDistribution, outcomeWeight, boolAmplitude]

example : boolOutcomeDistribution.mass true = 1 := by
  simp [boolOutcomeDistribution, outcomeDistribution, outcomeWeight, boolAmplitude]

noncomputable def trueThenTrue : History Bool 2 :=
  History.snoc (History.singleton true) true

noncomputable def trueThenFalse : History Bool 2 :=
  History.snoc (History.singleton true) false

example : sequenceWeight boolAmplitude trueThenTrue = 1 := by
  change ‖sequenceAmplitude boolAmplitude
    (History.snoc (History.singleton true) true)‖ ^ 2 = 1
  rw [sequenceAmplitude_snoc]
  change ‖sequenceAmplitude boolAmplitude
    (History.snoc (History.empty Bool) true) * boolAmplitude true‖ ^ 2 = 1
  rw [sequenceAmplitude_snoc, sequenceAmplitude_empty]
  simp [boolAmplitude]

example : sequenceWeight boolAmplitude trueThenFalse = 0 := by
  change ‖sequenceAmplitude boolAmplitude
    (History.snoc (History.singleton true) false)‖ ^ 2 = 0
  rw [sequenceAmplitude_snoc]
  simp [boolAmplitude]

example (h : History Bool 3) :
    (sequenceDistribution boolAmplitude boolAmplitude_normalized 3).mass h =
      ∏ k, boolOutcomeDistribution.mass (h k) := by
  exact sequenceDistribution_mass_eq_prod boolAmplitude boolAmplitude_normalized 3 h

end Everett.Weights.Examples
