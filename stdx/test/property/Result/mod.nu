# | Test suite for the `Result` type

use ../../../src/Result/
use std * 

export def tests [] {
    def mk-test [
       name: string,
       test: closure,
    ] {
       { name: $name, test: $test }
    }
    [
        (mk-test "functor-identity" {|| functor-identity }),
        (mk-test "functor-composition" {|| functor-composition }),
        (mk-test "applicative-identity" {|| applicative-identity }),
        (mk-test "applicative-composition" {|| applicative-composition }),
        (mk-test "applicative-homomorphism" {|| applicative-homomorphism }),
        (mk-test "applicative-interchange" {|| applicative-interchange }),
        (mk-test "monad-identity-right" {|| monad-identity-right }),
        (mk-test "monad-identity-left" {|| monad-identity-left }),
    ]
}

# | -- Functor laws

# Identity
#
# fmap id x == id x
def functor-identity [] {
    let id = {|x| $x }

    let f = (42 | Result pure)
    assert equal ($f | Result map $id) (do $id $f)

    let g = (404 | Result lift-err) 
    assert equal ($g | Result map $id) (do $id $g)
}

# Composition
#
# fmap (f . g) x == fmap f . fmap g x
def functor-composition [] {
    let f = ("stdx" | Result pure)
    let len  = {|x| $x | length}
    let half = {|y| $y / 2 }
    let half_len = {|z| do $half (do $len $z) }

    assert equal ($f | Result map $half_len) ($f | Result map $len | Result map $half)
}

# | -- Applicative laws

# Identity
#
# pure id <*> x = x
def applicative-identity [] {
    let id = {|x| $x }
    let f = ([1 2 3] | Result pure)

    assert equal (($id | Result pure) | Result apply $f) $f
}

# Composition
#
# pure (.) <*> u <*> v <*> w == u <*> (v <*> w)
def applicative-composition [] {
    let dot = {|f|
        {|g| {|x| do $f (do $g $x) } }
    }

    let u = (1 | Result pure)
    let v = ({|x| $x * 2} | Result pure)
    let w = ({|x| $x + 1} | Result pure)

    # this is going to be messy
    let lhs = (
        (
            (($dot | Result pure) | Result apply $w) | Result apply $v
        ) | Result apply $u
    )

    let rhs = (
        $w
        | Result apply (
            $v | Result apply $u
        )
    )

    assert equal $lhs $rhs
}

# | Homomorphism
#
# pure f <*> pure x == pure (f x)
def applicative-homomorphism [] {
    let f = {|x| $x + 1}
    let lhs = (
        $f 
        | Result pure
        | Result apply (1 | Result pure)
    )

    let rhs = (
        do $f 1 | Result pure 
    )

    assert equal $lhs $rhs
}

# | Interchange
#
# u <*> pure y == pure ($ y) <*> u
def applicative-interchange [] {
    let dollar = {|x|
        {|f| do $f $x}
    }

    let u = {|x| $x | length}

    let lhs = (
        $u
        | Result pure
        | Result apply ('stdx' | Result pure)
    )

    let rhs = (
        do $dollar 'stdx'
        | Result pure
        | Result apply ($u | Result pure)
    )

    assert equal $lhs $rhs
}

# | -- Monad laws

# Right Identity 
#
# m >>= return == m
def monad-identity-right [] {
    alias "Result return" = Result pure

    let m = (42 | Result return)
    
    assert equal ($m | Result bind {|x| $x | Result return }) $m
}

# Left Identity
#
# return x >>= f == f x
def monad-identity-left [] {
    alias "Result return" = Result pure
   
    let f = {|x| $x | Result return }
    let x = 1

    assert equal ($x | Result return | Result bind $f) (do $f $x)
}
