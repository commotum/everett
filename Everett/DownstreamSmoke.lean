module

import Everett.API

/-!
# Downstream import smoke test

This module behaves like a separate consumer: it imports only `Everett.API`.
-/

namespace Everett.DownstreamSmoke

open Everett.RelativeState Everett.Records Everett.Records.Independent
open Everett.Weights
open scoped TensorProduct

variable {H₁ H₂ : Type*}
  [NormedAddCommGroup H₁] [InnerProductSpace ℂ H₁] [FiniteDimensional ℂ H₁]
  [NormedAddCommGroup H₂] [InnerProductSpace ℂ H₂] [FiniteDimensional ℂ H₂]

example (x u : H₁) (v : H₂) :
    conditional x (u ⊗ₜ[ℂ] v) = inner ℂ x u • v :=
  conditional_tmul x u v

example {Outcome : Type*} [Fintype Outcome] (a : Outcome → ℂ) {n : ℕ}
    (h : History Outcome n) :
    sequenceWeight a h = ∏ k, outcomeWeight a (h k) :=
  sequenceWeight_eq_prod a h

end Everett.DownstreamSmoke
