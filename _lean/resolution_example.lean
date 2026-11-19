import Mathlib

/-!
A finite-domain toy witness for Resolution.
The *same* assertion, "there are exactly seven objects", is
false in the six-element structure and true in its proper extension.
This file models satisfaction via cardinality, not via
`FirstOrder.Language.Sentence.Realize`.
-/

namespace ResolutionToy

/-- The underlying domains of two structures in the empty language. -/
abbrev M₀ := Fin 6
abbrev M₁ := Fin 7

/-- The canonical inclusion of the smaller domain in the larger. -/
def inclusion : M₀ ↪ M₁ :=
  Fin.castLEEmb (by omega : 6 ≤ 7)

/-- The unchanged assertion: "There are exactly seven objects." -/
def ExactlySeven (M : Type) [Fintype M] : Prop :=
  Fintype.card M = 7

/-- The embedding is proper: 6 is not in its image. -/
theorem inclusion_proper :
    ∃ y : M₁, ∀ x : M₀, inclusion x ≠ y := by
  refine ⟨⟨6, by omega⟩, ?_⟩
  intro x h
  have hx : (x : ℕ) < 6 := x.isLt
  have hy : (inclusion x).val = 6 := congrArg Fin.val h
  have heq : (inclusion x).val = x.val := rfl
  omega

/-- The unchanged assertion fails in the smaller structure. -/
theorem not_satisfied_in_M₀ : ¬ ExactlySeven M₀ := by
  simp [ExactlySeven, M₀]

/-- The unchanged assertion holds in the larger structure. -/
theorem satisfied_in_M₁ : ExactlySeven M₁ := by
  simp [ExactlySeven, M₁]

/-- A proper embedding changes satisfaction of one fixed assertion. -/
theorem resolution_witness :
    (∃ y : M₁, ∀ x : M₀, inclusion x ≠ y) ∧
    ¬ ExactlySeven M₀ ∧ ExactlySeven M₁ := by
  exact ⟨inclusion_proper, not_satisfied_in_M₀, satisfied_in_M₁⟩

end ResolutionToy
