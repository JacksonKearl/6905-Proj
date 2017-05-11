# Ambgen: Recipes, your way

Ambgen consists of two central components:

- a powerful, yet still simple and easily extensible substitution engine, capable
  of taking recipes for the construction of a wide variety of modular systems
  (from food recipes to circuit diagrams), and reformulating them under a set of
   arbitrary constraints
- an eloquent domain specific language useful for both representing recipes in machine
  readable format, but also able to be easily reformatted into a convenient, human
  readable format.

## The Language


## The Engine

The Ambgen substitution engine features two distinct stages: a conflict detection step,
where we walk the recipe tree from the root downwards, marking nodes which are not
permissible under the given environment, followed by a conflict resolution step,
where we walk the conflicting nodes from the leaves upwards, repeatedly calling a
modular, two stage conflict resolution algorithm.

Ambgen works off of a representation of instructions as a recursive LISP-like language
consisting of lists of `(symbol ((arg1: val1)... )` pairs, where the first element of
a given list is some means of combination for the rest of the items in that list, which
may be either lists themselves, or the `(symbol ((arg1: val1)... )` pair discussed above.
As a simple example, see the combination of eggs and sugar via a whisk:
```scheme
((WHISK ((time: 4 minutes)))
    (EGG   ((amount: 3 units) (description: "free range")))
    (SUGAR ((amount: 4 cups)))
```
(More examples of this language present in the `sub-engine/demo.scm` and `sub-engine/main.scm` files)

In the conflict resolution step, we first perform a fanning out step, in which we
discover all possible resolutions of a given conflict, irrespective of the environment,
then we perform a filtering step, which in this cases uses the McCarthy `amb` operator
to return a generator over all possible valid replacements.

The syntax for this in the general case is as follows:
```scheme
(create-subtitution
  symbol-to-replace
  reduce ; receives the output of the fan, and the called environment
  fan    ; receives the params of the symbol to be substituted
)
```

In the case of this recipe customizer, we can be assured that there are only finitely many
options to consider, so we may use constructs like defining a list of possible substitutions
for a given symbol, as follows:

```scheme
(create-subtitution
  'parsley
  iter-amb
  (lambda (params)
    `((italian-parsley ,params))))
```

Where the fourth parameter to the `create-substitution` call is a `fan` function, and the `reduce` function, `iter-amb` is as follows:
```scheme
(define (iter-amb environment)
  (let ((acceptable?
        (lambda (item) ((acceptable-given-environment-recursive environment) item))))

    (lambda (possibilities)
      (list-amb (filter acceptable? possibilities)))))
      ```

In this, the simplest possible case, we define parsley to be replaceable by Italian parsley of the
same form. See `sub-engine/library.scm` and `sub-engine/demo.scm` for more advanced examples of the
power of the substitution engine.

However, this does not mean that all substitution formulas must be finite, or even predetermined.
By the right choice of `fan` and `reduce` functions, lots of different types of substitutions are possible,
from formulaic choices for things like resistor/capacitor substitution, to cost function optimization, suitable
for a wide variety of applications.
