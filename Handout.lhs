> module Handout (
>  historyStack
> ) where
> import Lambda
> import Stack
> import NumBool
> import Control.Monad.State
> import Control.Monad
> import Prelude hiding ((^),(^^))

> historyStack = do

06-02552 Principles of Programming Languages The University of Birmingham Spring Semester 2009-10 School of Computer Science ⃝c Uday Reddy2009-10

Handout 2: Lambda Calculus Examples

In this handout, we look at several examples of lambda terms in order to provide a flavour of what is possible with the lambda calculus.


1 Notations
-----------

For convenience, we often give names to the lambda terms we examine. These names will be either written in bold (such as name) or underlines (such as name). Note that these names are not part of the lambda calculus itself. They are external. We also feel free to use these names in other lambda terms. In that situation, we should think of the names as standing in for the lambda terms that they name.

Even though the lambda calculus is untyped, a large majority of the lambda terms that we look at can be given types. In fact, looking at the types of the terms provides insight into the kind of functions these terms represent. So, wherever possible, we mention the types of the functions. We use capital letters A, B, . . . to represent arbitrary types and the → symbol to represent function types. For example, A → B represents the type of functions from A to B, i.e., functions that given A-typed arguments, return B-typed results. We use a bracketing convention to parse type expressions with multiple → symbols: A type expression of the form A1 → A2 → · · · An → B means A1 →(A2 →···(An →B)···). We say that the → operator associates to the right.

> (^^) ("(\\x -> (\\y -> (\\z -> x + y + z))) 1 2 3", (\x -> (\y -> (\z -> x + y + z))) 1 2 3)
> (^^) ("(\\x -> (\\y -> (\\z -> 1 + z))) 1 2 3", (\x -> (\y -> (\z -> 1 + z))) 1 2 3)
> (^^) ("(\\x -> (\\y -> (\\z -> (+) 1))) 1 2 3 4", (\x -> (\y -> (\z -> (+) 1))) 1 2 3 4)


2 Examples
----------

1. Identity. The lambda term:

id = λx.x

> let id'' = \x->x

denotes the identity function, i.e., the function that simply returns its argument as its result. Indeed, by β- equivalence, (λx. x) M ≡ M for any term M .

> (^^) ("id' 5", id' 5)
> (^^) ("(id' (+1)) 1", (id' (+1)) 1)

If the identity function is given argument of type A, the result is again of type A. So, the identity function has type A → A for every type A. (In other words, it has infinite number of types, one for each instantiation of the symbolic type A: int → int and bool → bool, (int → bool) → (int → bool) are some example instances.)

> -- id' :: a -> a


2. Selection. The lambda term:

fst = λx. λy. x

> let fst'' = \x->(\y->x)

takes two arguments and returns the first argument as the result (ignoring the second argument). Notice that (λx. λy. x) M N ≡ (λy. M) N ≡ M by β-equivalence.

> (^^) ("(\\x.\\y.x) M N = (\\y.M) N = M", nCmp ((\x -> (\y -> x)) 5 1) ((\y -> y) 5))
> (^^) ("fst' 1 2", fst' 1 2)

However, the manner in which the two arguments are provided to fst is typical of the lambda calculus higher-order character. The fst function is first given an argument, say of type A, and it returns a function. This (returned) function takes another argument, say of type B, and returns the original first argument (of type A). In other words, the type of fst is A → (B → A).

> -- fst :: a -> (b -> a)

> let p1 = fst' 1
> (^^) ("partially applied (fst' 1) to 2", p1 2)


-- snd'

snd = λx. λy. y

> (^^) ("snd' 1 2", snd' 1 2)

￼Similarly, the lambda term returns the second argument that it is given (ignoring its first argument). It has the type A → (B → B).

> -- snd' :: a -> (b -> b)


3. Constant functions. The function λx. 0 returns 0 no matter what argument we give it. It is a “constant function”. Similarly, λx. 1 is a constant function that returns 1.

> (^^) ("\\x.0", (\x -> 0) 99)

We can define a lambda term to build such constant functions:

K = λx.λy.x

> let k' = fst'

Now, K 0 is the constant function that returns 0. In general, K x is the constant function that returns x.
Note that K and fst are the same function, in fact the same lambda term. The only difference is in our view of them.

> (^^) ("k' 1 2", k' 1 2)


4. Application. The lambda term:

apply = λf. λx. f x

> let apply' = \f -> (\x -> f x)

takes a function and a value as argument and applies the function to the argument.

To give a type to the function, notice that f is a function and it takes x as an argument. So, if x is of type A then f must be of type A → B for some B. So, the overall type of apply can be written as

(A → B) → A → B

> -- apply :: (a -> b) -> a -> b

A → B is a possible type of f, A is the possible type of x, and B is the result type of apply which is the same as result type of f.

> (^^) ("apply' (+1) 1", apply' (+1) 1)
> (^^) ("apply' id' 1", apply' id' 1)

The lambda term:

twice = λf. λx. f (f x)

> let twice'' = \f -> (\x -> f (f x))

is similar to apply but applies the function f twice. It applies f to x obtaining a result, and applies f to this result once more. Its type is similar to that of apply but, since f is applied again to the result of f , the argument type and the result type of f should be the same, say A. So, the overall type of twice is (A → A) → A → A.

> -- twice' :: (a -> a) -> a -> a
> (^^) ("twice' (+1) 0", twice' (+1) 0)

Similarly, the lambda term

thrice = λf. λx. f (f (f x))

> let thrice'' = \f -> (\x -> f (f (f x)))

applies f thrice.

> (^^) ("thrice' (+1) 0", thrice' (+1) 0)


5. Function composition. If f is a function of type A → B and g is of type B → C, mathematicians speak of their composition which is function denoted g ◦ f of type A → C. Given an argument, g ◦ f first applies f to the argument and then applies g to the result of this application.

> -- comp' :: (a -> b) -> (b -> c) -> (a -> c)

We define a lambda term that captures function composition:

comp = λg.λf.λx.g (f x) Now, comp g f is the same as what mathematicians write as g ◦ f .

> (^^) ("comp' (+1) (+2) 5", comp' (+1) (+2) 5)

The type of comp can be expressed as
(B → C) → (A → B) → (A → C)

> -- comp' :: (b -> c) -> (a -> b) -> (a -> c)

for any types A, B and C. You should verify that this is indeed the correct type for comp. Note that twice f is equivalent comp f f .

> (^^) ("twice' (+1) 0 == comp' (+1) (+1) 0", nCmp (twice' (+1) 0) (comp' (+1) (+1) 0))

Similarly, thrice f is equivalent to comp f (comp f f ) as well as comp (comp f f ) f .


> (^^) ("(thrice' (+1) 0) == (comp' (+1) (comp' (+1) (+1))) 0 == (comp' (comp' (+1) (+1)) (+1) 0)", nCmp3 (thrice' (+1) 0) ((comp' (+1) (comp' (+1) (+1))) 0) ((comp' (comp' (+1) (+1)) (+1)) 0))



6. Self application. Here is a lambda-term that appears strange from a traditional mathematical point of view: sa = λx. x x

> let self'' = \x -> x x

This function takes an argument x, which is apparently a function. It applies the function to itself and returns whatever is the result.

What is strange is that x is a function that can take itself as an argument. Are there any such functions? Indeed, there are. id is clearly a function that can be applied to itself. Notice:

id id = (λx. x) id = id The fst and snd functions can also be applied to themselves:

fst fst = (λx.λy.x) fst = λy.fst

snd snd = (λx.λy.y) snd = λy.y = id

For a more substantive example of self-application, consider applying the twice function to itself:

twice twice =

= λx. twice (twice x)

(λf. λx. f (f x)) twice = comp twice twice

You can calculate that comp twice twice is a quite normal function that creates a four-fold application of a given function.

What happens if we apply sa to itself?

sa sa = (λx. x x) sa = sa sa

So, if we try to use β-reduction to find out what sa sa means, we get nowhere. This term corresponds to an “infinite loop” in lambda calculus. It is denoted by the symbol Ω.

7. The Y combinator. The following famous term is called the Y combinator. Y = λt. (λx. t (x x)) (λx. t (x x))

This term looks almost like the self-application of sa, but it is different in that it involves an additional function t in a subtle way. Consider an application Y t and let us see what we can learn about it using β-reduction:

Yt = (λx.t(xx))(λx.t(xx))

= t ((λx. t (x x)) (λx. t (x x))) by β-reduction

= t (Y t) noticing that the inner term is Y t

So, Y t is equal to the function t applied to itself! One can use this to repeatedly unfold Y t. Y t = t (Y t) = t (t (Y t)) = t (t (t (Y t))) = · · ·

This might seem like another form of an infinite loop, but it is actually quite useful. In fact, it is used to encode recursive functions in the lambda calculus.

Consider the recursive definition of a function such as the factorial:

define factorial = λn. if (= n 1) 1

(∗ n (factorial (− n 1))

On the surface, this is a circular definition and cannot be expressed in lambda calculus. To resolve the difficulty, we first treat the right hand side of the definition as a function of “factorial”:

define factorial = T factorial

define T = λf.λn.if(=n1)1

(∗n(f (−n1))

The definition of T is quite normal, but the first line is still a circular definition. However, this is exactly the kind of circularity that the Y combinator allows us to capture. The Y combinator satisfies the equality Y T = T (Y T ). So, we can just say that factorial is Y T and we get what we want without any circular definitions.

Does this actually work? Here is a sample calculation:
￼￼￼￼￼￼(YT)2 = T (YT)2

= if(=21)1(∗2(YT (−21)))
= (∗2(YT1)) = (∗21)
=2
(YT)1 = T (YT)1
= if(=11)1(∗1(YT (−11)))
=1

β-reduction calculating arithmetic separate calculation

β-reduction calculating arithmetic

￼￼￼￼￼￼￼￼￼Thus, in general, all recursive function definitions can be represented in the lambda calculus as applications of the Y combinator. This gives the lambda calculus the power of Turing machine computations.

8. Subtleties of self application. Even though self-application allows calculations using the laws of the lambda calculus, what it means conceptually is not at all clear. We can see some of the problems by just trying to give a type to sa = λx. x x. Suppose the argument x is of type A. But, since x is being applied as a function to x, the type of x should be of the form A → . . .. How can x be of type A as well as A → . . .? Is there a type A such that A = (A → B)? In traditional mathematics (set theory), there is no such type.

However, we have just seen that there are quite a few functions that can be applied to themselves. We have also seen that we can usefully encode recursive functions using self application. Calculations using the lambda calculus produce quite normal and sensible results. This explains why the lambda calculus has been called a “calculus”. It is a system for doing calculations. However, it does not have meaning. So it was thought for a long time.

Finally, in 1960s, Dana Scott, then a Professor at Oxford University, and himself a former student of Alonzo Church, discovered a meaning for the lambda calculus. He formulated structures called “domains” which can be used to represent types (instead of traditional sets). In domains, there are indeed types A such that A = (A → B). This led to the development of an elegant theory of domains, which serves as the foundation for the mathematical meaning of programming languages. A survey article on Domain Theory, written by S. Abramsky and A. Jung appears in the Handbook of Logic in Computer Science, Oxford University Press, 1994.

Self application is used very fundamentally in implementing object-oriented programming languages. Suppose we have an object x with a method m. We might invoke this method by writing something like x.m(y). However,

inside the method m, there would be references to keywords like “self” or “this” which are supposed to represent the object x itself. But how does m know what the object x is? One way of solving the problem is to translate the method m into a function m′ that takes two arguments: in addition to the proper argument y, the object on which the method is being invoked. So, the definition of m′ looks like:

m′ = λself.λy....the body of m ...

The object x has a collection of such functions encoding the methods. The method call x.m(y) is then translated as x.m′(x)(y). This is a form of self application. The function m′, which is a part of the structure x, is applied to the structure x itself. The meaning of such self application is explained in the article “Two semantic models of object-oriented languages” by S. Kamin and U. S. Reddy in the volume Theoretical Aspects of Object-Oriented Programming, MIT Press, 1994.


-->  return ()
