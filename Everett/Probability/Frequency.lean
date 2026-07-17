module

public import Everett.Weights.Product

/-!
# Finite empirical frequencies and exceptional branch weight
-/

@[expose] public section

namespace Everett.Probability

open Everett.Records Everett.Weights

variable {Outcome : Type*} [Fintype Outcome]

/-- Product mass of a history under a finite one-step distribution. -/
noncomputable def productMass (d : FiniteDistribution Outcome) {n : ℕ}
    (h : History Outcome n) : ℝ :=
  ∏ k, d.mass (h k)

@[simp]
theorem productMass_empty (d : FiniteDistribution Outcome) :
    productMass d (History.empty Outcome) = 1 := by
  simp [productMass]

@[simp]
theorem productMass_snoc (d : FiniteDistribution Outcome) {n : ℕ}
    (h : History Outcome n) (i : Outcome) :
    productMass d (History.snoc h i) = productMass d h * d.mass i := by
  rw [productMass, Fin.prod_univ_castSucc]
  simp [History.snoc, productMass]

theorem sum_productMass (d : FiniteDistribution Outcome) (n : ℕ) :
    ∑ h : History Outcome n, productMass d h = 1 := by
  rw [show (∑ h : History Outcome n, productMass d h) =
      (∑ i, d.mass i) ^ n by
    simp_rw [productMass]
    exact (Fintype.sum_pow d.mass n).symm]
  rw [d.sum_mass, one_pow]

/-- Real indicator for one distinguished outcome. -/
def indicator [DecidableEq Outcome] (target i : Outcome) : ℝ :=
  if i = target then 1 else 0

theorem sum_mass_mul_indicator [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) :
    ∑ i, d.mass i * indicator target i = d.mass target := by
  simp [indicator]

/-- Number of occurrences, represented in `ℝ` for moment calculations. -/
noncomputable def empiricalCount [DecidableEq Outcome] (target : Outcome) {n : ℕ}
    (h : History Outcome n) : ℝ :=
  ∑ k, indicator target (h k)

omit [Fintype Outcome] in
@[simp]
theorem empiricalCount_empty [DecidableEq Outcome] (target : Outcome) :
    empiricalCount target (History.empty Outcome) = 0 := by
  simp [empiricalCount]

omit [Fintype Outcome] in
@[simp]
theorem empiricalCount_snoc [DecidableEq Outcome] (target : Outcome) {n : ℕ}
    (h : History Outcome n) (i : Outcome) :
    empiricalCount target (History.snoc h i) =
      empiricalCount target h + indicator target i := by
  rw [empiricalCount, Fin.sum_univ_castSucc]
  simp [History.snoc, empiricalCount]

/-- Expectation with respect to the finite product mass. -/
noncomputable def expectation (d : FiniteDistribution Outcome) (n : ℕ)
    (X : History Outcome n → ℝ) : ℝ :=
  ∑ h, productMass d h * X h

/-- Expected occurrence count is `n p`. -/
theorem expectation_empiricalCount [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) :
    ∀ n, expectation d n (empiricalCount target) = n * d.mass target := by
  intro n
  induction n with
  | zero =>
      rw [expectation]
      have hall : ∀ h : History Outcome 0, h = History.empty Outcome :=
        fun h => Subsingleton.elim _ _
      simp_rw [hall]
      simp
  | succ n ih =>
      rw [expectation, ← (History.snocEquiv Outcome n).sum_comp,
        Fintype.sum_prod_type]
      simp only [History.snocEquiv_apply]
      simp_rw [productMass_snoc, empiricalCount_snoc]
      simp only [mul_add, Finset.sum_add_distrib]
      have hfirst :
          (∑ x : History Outcome n,
            ∑ i, productMass d x * d.mass i * empiricalCount target x) =
            expectation d n (empiricalCount target) * ∑ i, d.mass i := by
        rw [expectation]
        simpa only [mul_assoc, mul_left_comm, mul_comm] using
          (Fintype.sum_mul_sum
            (fun x : History Outcome n => productMass d x * empiricalCount target x)
            d.mass).symm
      have hsecond :
          (∑ x : History Outcome n,
            ∑ i, productMass d x * d.mass i * indicator target i) =
            (∑ x : History Outcome n, productMass d x) *
              ∑ i, d.mass i * indicator target i := by
        simpa only [mul_assoc, mul_left_comm, mul_comm] using
          (Fintype.sum_mul_sum (fun x : History Outcome n => productMass d x)
            (fun i => d.mass i * indicator target i)).symm
      rw [hfirst, hsecond, ih, d.sum_mass, sum_productMass,
        sum_mass_mul_indicator]
      norm_num [Nat.cast_succ]
      ring

/-- Second raw moment of the occurrence count. -/
noncomputable def countSecondMoment [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) : ℝ :=
  expectation d n (fun h => empiricalCount target h ^ 2)

/-- The second count moment has the Bernoulli product form. -/
theorem countSecondMoment_eq [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) :
    ∀ n, countSecondMoment d target n =
      n * d.mass target * (1 - d.mass target) + (n * d.mass target) ^ 2 := by
  intro n
  induction n with
  | zero =>
      rw [countSecondMoment, expectation]
      have hall : ∀ h : History Outcome 0, h = History.empty Outcome :=
        fun h => Subsingleton.elim _ _
      simp_rw [hall]
      simp
  | succ n ih =>
      rw [countSecondMoment, expectation,
        ← (History.snocEquiv Outcome n).sum_comp, Fintype.sum_prod_type]
      simp only [History.snocEquiv_apply]
      simp_rw [productMass_snoc, empiricalCount_snoc]
      have hindicator_sq : ∀ i, indicator target i ^ 2 = indicator target i := by
        intro i
        simp [indicator]
      simp_rw [add_sq, hindicator_sq]
      simp only [mul_add, Finset.sum_add_distrib]
      have hsq :
          (∑ x : History Outcome n,
            ∑ i, productMass d x * d.mass i * empiricalCount target x ^ 2) =
            countSecondMoment d target n * ∑ i, d.mass i := by
        rw [countSecondMoment, expectation]
        rw [Fintype.sum_mul_sum]
        congr with x
        congr with i
        ring
      have hcross :
          (∑ x : History Outcome n,
            ∑ i, productMass d x * d.mass i *
              (2 * empiricalCount target x * indicator target i)) =
            expectation d n (empiricalCount target) *
              (∑ i, d.mass i * indicator target i) * 2 := by
        rw [expectation, Fintype.sum_mul_sum]
        simp only [Finset.sum_mul]
        congr 1
        funext x
        congr 1
        funext i
        ring
      have hind :
          (∑ x : History Outcome n,
            ∑ i, productMass d x * d.mass i * indicator target i) =
            (∑ x : History Outcome n, productMass d x) *
              ∑ i, d.mass i * indicator target i := by
        simpa only [mul_assoc, mul_left_comm, mul_comm] using
          (Fintype.sum_mul_sum (fun x : History Outcome n => productMass d x)
            (fun i => d.mass i * indicator target i)).symm
      rw [hsq, hcross, hind, ih, expectation_empiricalCount,
        sum_productMass, sum_mass_mul_indicator, d.sum_mass]
      norm_num [Nat.cast_succ]
      ring

/-- Variance of the occurrence count, defined from its finite moments. -/
noncomputable def countVariance [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) : ℝ :=
  countSecondMoment d target n -
    expectation d n (empiricalCount target) ^ 2

theorem countVariance_eq [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) :
    countVariance d target n = n * d.mass target * (1 - d.mass target) := by
  rw [countVariance, countSecondMoment_eq, expectation_empiricalCount]
  ring

/-- Empirical frequency, totalized to zero for an empty history. -/
noncomputable def empiricalFrequency [DecidableEq Outcome] (target : Outcome) {n : ℕ}
    (h : History Outcome n) : ℝ :=
  empiricalCount target h / n

omit [Fintype Outcome] in
@[simp]
theorem empiricalFrequency_empty [DecidableEq Outcome] (target : Outcome) :
    empiricalFrequency target (History.empty Outcome) = 0 := by
  simp [empiricalFrequency]

theorem productMass_nonnegative (d : FiniteDistribution Outcome) {n : ℕ}
    (h : History Outcome n) : 0 ≤ productMass d h := by
  exact Finset.prod_nonneg fun k _ => d.nonnegative (h k)

/-- Generic finite weighted Chebyshev inequality. -/
theorem finite_chebyshev {ι : Type*} [Fintype ι]
    (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (X : ι → ℝ) (μ ε : ℝ) (hε : 0 < ε) :
    ∑ i ∈ Finset.univ.filter (fun i => ε ≤ |X i - μ|), w i ≤
      (∑ i, w i * (X i - μ) ^ 2) / ε ^ 2 := by
  classical
  let bad := Finset.univ.filter (fun i => ε ≤ |X i - μ|)
  calc
    ∑ i ∈ Finset.univ.filter (fun i => ε ≤ |X i - μ|), w i = ∑ i ∈ bad, w i := rfl
    _ ≤ ∑ i ∈ bad, w i * (X i - μ) ^ 2 / ε ^ 2 := by
      apply Finset.sum_le_sum
      intro i hi
      have hdev : ε ≤ |X i - μ| := (Finset.mem_filter.mp hi).2
      have hsq : ε ^ 2 ≤ (X i - μ) ^ 2 := by
        nlinarith [sq_abs (X i - μ)]
      have hratio : 1 ≤ (X i - μ) ^ 2 / ε ^ 2 := by
        apply (le_div_iff₀ (sq_pos_of_pos hε)).2
        simpa using hsq
      have hm := mul_le_mul_of_nonneg_left hratio (hw i)
      simpa [mul_div_assoc] using hm
    _ ≤ ∑ i, w i * (X i - μ) ^ 2 / ε ^ 2 := by
      apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ bad)
      intro i _ _
      exact div_nonneg (mul_nonneg (hw i) (sq_nonneg _)) (sq_nonneg _)
    _ = (∑ i, w i * (X i - μ) ^ 2) / ε ^ 2 := by
      rw [Finset.sum_div]

/-- The centered second moment of the count equals its variance formula. -/
theorem sum_productMass_mul_count_sub_sq [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) :
    ∑ h : History Outcome n,
        productMass d h * (empiricalCount target h - n * d.mass target) ^ 2 =
      n * d.mass target * (1 - d.mass target) := by
  have hsum := sum_productMass d n
  have hmean := expectation_empiricalCount d target n
  have hsecond := countSecondMoment_eq d target n
  rw [countSecondMoment, expectation] at hsecond
  rw [expectation] at hmean
  calc
    _ = (∑ h, productMass d h * empiricalCount target h ^ 2) -
        2 * (n * d.mass target) *
          (∑ h, productMass d h * empiricalCount target h) +
        (n * d.mass target) ^ 2 * ∑ h, productMass d h := by
      rw [show (∑ h, productMass d h *
          (empiricalCount target h - n * d.mass target) ^ 2) =
          ∑ h, (productMass d h * empiricalCount target h ^ 2 -
            2 * (n * d.mass target) *
              (productMass d h * empiricalCount target h) +
            (n * d.mass target) ^ 2 * productMass d h) by
        apply Finset.sum_congr rfl
        intro h _
        ring]
      rw [Finset.sum_add_distrib, Finset.sum_sub_distrib]
      simp only [← Finset.mul_sum]
      ring
    _ = n * d.mass target * (1 - d.mass target) := by
      rw [hsecond, hmean, hsum]
      ring

/-- Centered second moment of empirical frequency for a nonempty history. -/
theorem sum_productMass_mul_frequency_sub_sq [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) (hn : 0 < n) :
    ∑ h : History Outcome n,
        productMass d h * (empiricalFrequency target h - d.mass target) ^ 2 =
      d.mass target * (1 - d.mass target) / n := by
  have hn0 : (n : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hn)
  have hpoint : ∀ h : History Outcome n,
      empiricalFrequency target h - d.mass target =
        (empiricalCount target h - n * d.mass target) / n := by
    intro h
    rw [empiricalFrequency]
    field_simp
  simp_rw [hpoint, div_pow, ← mul_div_assoc]
  rw [← Finset.sum_div, sum_productMass_mul_count_sub_sq]
  field_simp

/-- Total product mass of histories with frequency deviation at least `ε`. -/
noncomputable def exceptionalFrequencyMass [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) (ε : ℝ) : ℝ :=
  ∑ h ∈ Finset.univ.filter
    (fun h : History Outcome n => ε ≤ |empiricalFrequency target h - d.mass target|),
    productMass d h

/-- Explicit finite Chebyshev bound for exceptional branch weight. -/
theorem exceptionalFrequencyMass_le [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ)
    (hn : 0 < n) (ε : ℝ) (hε : 0 < ε) :
    exceptionalFrequencyMass d target n ε ≤
      d.mass target * (1 - d.mass target) / (n * ε ^ 2) := by
  rw [exceptionalFrequencyMass]
  calc
    _ ≤ (∑ h : History Outcome n,
        productMass d h * (empiricalFrequency target h - d.mass target) ^ 2) /
          ε ^ 2 :=
      finite_chebyshev (fun h : History Outcome n => productMass d h)
        (productMass_nonnegative d) (empiricalFrequency target) (d.mass target) ε hε
    _ = _ := by
      rw [sum_productMass_mul_frequency_sub_sq d target n hn]
      field_simp

/-- The product mass is exactly the Stage 7 squared-amplitude sequence mass. -/
theorem productMass_outcomeDistribution_eq_sequenceMass
    (a : Outcome → ℂ) (hnorm : ∑ i, outcomeWeight a i = 1)
    {n : ℕ} (h : History Outcome n) :
    productMass (outcomeDistribution a hnorm) h =
      (sequenceDistribution a hnorm n).mass h := by
  rw [sequenceDistribution_mass, sequenceWeight_eq_prod]
  rfl

theorem exceptionalFrequencyMass_nonnegative [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) (ε : ℝ) :
    0 ≤ exceptionalFrequencyMass d target n ε := by
  apply Finset.sum_nonneg
  intro h _
  exact productMass_nonnegative d h

/-- The exceptional finite-history mass converges to zero: convergence in probability. -/
theorem exceptionalFrequencyMass_tendsto_zero [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (ε : ℝ) (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => exceptionalFrequencyMass d target (n + 1) ε)
      Filter.atTop (nhds 0) := by
  apply squeeze_zero
  · intro n
    exact exceptionalFrequencyMass_nonnegative d target (n + 1) ε
  · intro n
    exact exceptionalFrequencyMass_le d target (n + 1) (Nat.succ_pos n) ε hε
  · have hcast : Filter.Tendsto (fun n : ℕ => ((n + 1 : ℕ) : ℝ))
        Filter.atTop Filter.atTop :=
      (Filter.tendsto_add_atTop_iff_nat 1).2 tendsto_natCast_atTop_atTop
    have hden : Filter.Tendsto (fun n : ℕ => ((n + 1 : ℕ) : ℝ) * ε ^ 2)
        Filter.atTop Filter.atTop :=
      hcast.atTop_mul_const (sq_pos_of_pos hε)
    exact tendsto_const_nhds.div_atTop hden

/-- A total-one finite distribution cannot live on an empty outcome type. -/
theorem outcome_nonempty (d : FiniteDistribution Outcome) : Nonempty Outcome := by
  apply Fintype.card_pos_iff.mp
  by_contra hcard
  have hzero : Fintype.card Outcome = 0 := Nat.eq_zero_of_not_pos hcard
  letI : IsEmpty Outcome := Fintype.card_eq_zero_iff.mp hzero
  have hempty : Finset.univ = (∅ : Finset Outcome) := by
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro i _
    exact isEmptyElim i
  have hsum := d.sum_mass
  rw [hempty] at hsum
  simp at hsum

theorem exceptionalFrequencyMass_eq_zero_of_mass_eq_zero [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) (hn : 0 < n)
    (ε : ℝ) (hε : 0 < ε) (hp : d.mass target = 0) :
    exceptionalFrequencyMass d target n ε = 0 := by
  apply le_antisymm
  · calc
      exceptionalFrequencyMass d target n ε ≤
          d.mass target * (1 - d.mass target) / (n * ε ^ 2) :=
        exceptionalFrequencyMass_le d target n hn ε hε
      _ = 0 := by rw [hp]; norm_num
  · exact exceptionalFrequencyMass_nonnegative d target n ε

theorem exceptionalFrequencyMass_eq_zero_of_mass_eq_one [DecidableEq Outcome]
    (d : FiniteDistribution Outcome) (target : Outcome) (n : ℕ) (hn : 0 < n)
    (ε : ℝ) (hε : 0 < ε) (hp : d.mass target = 1) :
    exceptionalFrequencyMass d target n ε = 0 := by
  apply le_antisymm
  · calc
      exceptionalFrequencyMass d target n ε ≤
          d.mass target * (1 - d.mass target) / (n * ε ^ 2) :=
        exceptionalFrequencyMass_le d target n hn ε hε
      _ = 0 := by rw [hp]; norm_num
  · exact exceptionalFrequencyMass_nonnegative d target n ε

end Everett.Probability
