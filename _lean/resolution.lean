import Mathlib

namespace Resolution

open FirstOrder

universe u

variable (L : FirstOrder.Language)

/-- A theory is a set of first-order sentences. -/
abbrev Theory := Set L.Sentence

/-- A structure satisfies a theory when it satisfies
    every sentence belonging to that theory. -/
def Satisfies
    (M : Type u) [L.Structure M]
    (T : Theory L) : Prop :=
  ∀ φ ∈ T, φ.Realize M

/-- Resolution: a fixed theory fails in one structure
    but succeeds in a proper structural extension.

    The embedding preserves and reflects atomic relations,
    and preserves interpretations of function symbols.

    The embedding is not required to be elementary:
    quantified sentences may change truth values.

    The language and theory remain unchanged. -/
def Resolved
    (T : Theory L) : Prop :=
  ∃ (M₀ M₁ : Type u)
    (_ : L.Structure M₀)
    (_ : L.Structure M₁),
    ∃ f : M₀ ↪[L] M₁,
      (∃ y : M₁, ∀ x : M₀, f x ≠ y) ∧
      ¬ Satisfies L M₀ T ∧
      Satisfies L M₁ T

end Resolution