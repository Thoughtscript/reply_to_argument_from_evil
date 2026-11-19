import Mathlib

/-!
# Speaks–Mackie argument from evil: propositional abstraction

The original argument is retained as strings for reference. Its logical
representation below instantiates the universal premises P3 and P6 at God.
The countermodel refutes entailment from the *independent* premises
P1, P2, P3, P5, P6 without additional bridge principles.

The final two interpretations show differing truth values, NOT a
first-order proper-substructure Resolution. No such claim is made here.
-/

namespace ArgumentFromEvil

structure ArgumentFormulation where
  P1 : String
  P2 : String
  P3 : String
  P4 : String
  P5 : String
  P6 : String
  P7 : String
  P8 : String
  P9 : String
  C : String

def «Jeff Speaks Mackie Logical Argument from Evil formulation» : ArgumentFormulation :=
  { P1 := "God exists."
    P2 := "If God exists, then God is wholly good."
    P3 := "If something is wholly good, it always eliminates as much evil as it can."
    P4 := "If God exists, then God eliminates as much evil as God can. (2,3)"
    P5 := "If God exists, then God is omnipotent."
    P6 := "If something is omnipotent, it can do anything."
    P7 := "If God exists, then God can eliminate all evil. (5,6)"
    P8 := "If God exists, then God eliminates all evil. (4,7)"
    P9 := "God eliminates all evil. (1,8)"
    C := "There is no evil. (9)" }

/-- Truth assignments for the propositional abstraction. -/
structure Interpretation where
  GodExists : Prop
  WhollyGood : Prop
  Omnipotent : Prop
  EliminatesMaximum : Prop
  CanEliminateAll : Prop
  EliminatesAll : Prop
  EvilExists : Prop

def P1 (M : Interpretation) : Prop := M.GodExists
def P2 (M : Interpretation) : Prop := M.GodExists → M.WhollyGood
def P3 (M : Interpretation) : Prop := M.WhollyGood → M.EliminatesMaximum
def P4 (M : Interpretation) : Prop := M.GodExists → M.EliminatesMaximum
def P5 (M : Interpretation) : Prop := M.GodExists → M.Omnipotent
def P6 (M : Interpretation) : Prop := M.Omnipotent → M.CanEliminateAll
def P7 (M : Interpretation) : Prop := M.GodExists → M.CanEliminateAll
def P8 (M : Interpretation) : Prop := M.GodExists → M.EliminatesAll
def P9 (M : Interpretation) : Prop := M.EliminatesAll
def C (M : Interpretation) : Prop := ¬ M.EvilExists

/-- Independent premises; P4 and P7 are derived, not assumed. -/
def Premises (M : Interpretation) : Prop :=
  P1 M ∧ P2 M ∧ P3 M ∧ P5 M ∧ P6 M

/-- The bridge needed to derive P8 from P4 and P7. -/
def ComplexPredicateBridge (M : Interpretation) : Prop :=
  (M.EliminatesMaximum ∧ M.CanEliminateAll) → M.EliminatesAll

/-- The bridge needed to derive the conclusion from P9. -/
def ConclusionBridge (M : Interpretation) : Prop :=
  M.EliminatesAll → ¬ M.EvilExists

/-- Conjunctive complex predicate. -/
def ComplexConjunction {α : Type} (P Q R : α → Prop) : α → Prop :=
  fun x => P x ∧ Q x ∧ R x

/-- Disjunctive complex predicate. -/
def ComplexDisjunction {α : Type} (P Q R : α → Prop) : α → Prop :=
  fun x => P x ∨ Q x ∨ R x

/-- An exhaustive definition agrees with its proposed definiens everywhere. -/
def ExhaustiveDefinition {α : Type} (P Q : α → Prop) : Prop :=
  ∀ x, P x ↔ Q x

/-- A counterexample to an alleged exhaustive predicate definition. -/
def ComplexPredicateArgumentFails {α : Type} (P Q : α → Prop) : Prop :=
  ∃ x, ¬ (P x ↔ Q x)

theorem complex_predicate_counterexample {α : Type}
    (P Q : α → Prop) (h : ComplexPredicateArgumentFails P Q) :
    ¬ ExhaustiveDefinition P Q := by
  intro hdef
  obtain ⟨x, hx⟩ := h
  exact hx (hdef x)

theorem derived_P4 (M : Interpretation) (h : Premises M) : P4 M := by
  rcases h with ⟨_, h2, h3, _, _⟩
  exact fun hg => h3 (h2 hg)

theorem derived_P7 (M : Interpretation) (h : Premises M) : P7 M := by
  rcases h with ⟨_, _, _, h5, h6⟩
  exact fun hg => h6 (h5 hg)

theorem conclusion_with_bridges (M : Interpretation)
    (h : Premises M)
    (hb : ComplexPredicateBridge M)
    (hc : ConclusionBridge M) : C M := by
  rcases h with ⟨h1, h2, h3, h5, h6⟩
  have hmax : M.EliminatesMaximum := h3 (h2 h1)
  have hcan : M.CanEliminateAll := h6 (h5 h1)
  exact hc (hb ⟨hmax, hcan⟩)

/-- All independent premises hold, but the conclusion does not. -/
def counterexample : Interpretation where
  GodExists := True
  WhollyGood := True
  Omnipotent := True
  EliminatesMaximum := True
  CanEliminateAll := True
  EliminatesAll := False
  EvilExists := True

theorem premises_hold : Premises counterexample := by
  simp [Premises, P1, P2, P3, P5, P6, counterexample]

theorem conclusion_fails : ¬ C counterexample := by
  simp [C, counterexample]

theorem argument_not_valid :
    ¬ (∀ M : Interpretation, Premises M → C M) := by
  intro h
  exact conclusion_fails (h counterexample premises_hold)

/-- The conjunction of the independent premises and the conclusion. -/
def Theory (M : Interpretation) : Prop := Premises M ∧ C M

/-- Another interpretation where that conjunction is true. -/
def resolvedInterpretation : Interpretation where
  GodExists := True
  WhollyGood := True
  Omnipotent := True
  EliminatesMaximum := True
  CanEliminateAll := True
  EliminatesAll := True
  EvilExists := False

theorem theory_fails_in_counterexample : ¬ Theory counterexample := by
  intro h
  exact conclusion_fails h.2

theorem theory_holds_in_resolved_interpretation :
    Theory resolvedInterpretation := by
  simp [Theory, Premises, P1, P2, P3, P5, P6, C,
    resolvedInterpretation]

end ArgumentFromEvil
