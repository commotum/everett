module

import Everett.Probability.Frequency

/-!
# Finite frequency examples
-/

namespace Everett.Probability.Examples

open Everett.Probability Everett.Weights

noncomputable def fairBool : FiniteDistribution Bool where
  mass _ := 1 / 2
  nonnegative _ := by norm_num
  sum_mass := by simp

noncomputable def certainTrue : FiniteDistribution Bool where
  mass b := if b then 1 else 0
  nonnegative b := by cases b <;> simp
  sum_mass := by simp

example : empiricalFrequency true (Everett.Records.History.empty Bool) = 0 := by simp

example : expectation fairBool 6 (empiricalCount true) = 6 * (1 / 2 : ℝ) :=
  expectation_empiricalCount fairBool true 6

example : countVariance fairBool true 6 = 6 * (1 / 2 : ℝ) * (1 - 1 / 2) :=
  countVariance_eq fairBool true 6

example : exceptionalFrequencyMass fairBool true 10 (1 / 5) ≤
    (1 / 2 : ℝ) * (1 - 1 / 2) / (10 * (1 / 5) ^ 2) :=
  exceptionalFrequencyMass_le fairBool true 10 (by norm_num) (1 / 5) (by norm_num)

example : exceptionalFrequencyMass certainTrue true 8 (1 / 10) = 0 := by
  apply exceptionalFrequencyMass_eq_zero_of_mass_eq_one
  · norm_num
  · norm_num
  · simp [certainTrue]

example : exceptionalFrequencyMass certainTrue false 8 (1 / 10) = 0 := by
  apply exceptionalFrequencyMass_eq_zero_of_mass_eq_zero
  · norm_num
  · norm_num
  · simp [certainTrue]

example : Filter.Tendsto
    (fun n : ℕ => exceptionalFrequencyMass fairBool true (n + 1) (1 / 5))
    Filter.atTop (nhds 0) :=
  exceptionalFrequencyMass_tendsto_zero fairBool true (1 / 5) (by norm_num)

end Everett.Probability.Examples
