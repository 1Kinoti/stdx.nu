# | Test suite for the `Option` type

use std *
use ../../../src/Option/

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

    let f = (42 | Option pure)
    assert equal ($f | Option map $id) (do $id $f)

    let g = (Option new) 
    assert equal ($g | Option map $id) (do $id $g)
}

# Composition
#
# fmap (f . g) x == fmap f . fmap g x
def functor-composition [] {
    let f = ("stdx" | Option pure)
    let len  = {|x| $x | length}
    let half = {|y| $y / 2 }
    let half_len = {|z| do $half (do $len $z) }

    assert equal ($f | Option map $half_len) ($f | Option map $len | Option map $half)
}

# | -- Applicative laws

# Identity
#
# pure id <*> x = x
def applicative-identity [] {
    let id = {|x| $x }
    let f = ([1 2 3] | Option pure)

    assert equal (($id | Option pure) | Option apply $f) $f
}

# Composition
#
# pure (.) <*> u <*> v <*> w == u <*> (v <*> w)
def applicative-composition [] {
    let dot = {|f|
        {|g| {|x| do $f (do $g $x) } }
    }

    let u = (1 | Option pure)
    let v = ({|x| $x * 2} | Option pure)
    let w = ({|x| $x + 1} | Option pure)

    # this is going to be messy
    let lhs = (
        (
            (($dot | Option pure) | Option apply $w) | Option apply $v
        ) | Option apply $u
    )

    let rhs = (
        $w
        | Option apply (
            $v | Option apply $u
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
        | Option pure
        | Option apply (1 | Option pure)
    )

    let rhs = (
        do $f 1 | Option pure 
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
        | Option pure
        | Option apply ('stdx' | Option pure)
    )

    let rhs = (
        do $dollar 'stdx'
        | Option pure
        | Option apply ($u | Option pure)
    )

    assert equal $lhs $rhs
}

# | -- Monad laws

# Right Identity 
#
# m >>= return == m
def monad-identity-right [] {
    alias "Option return" = Option pure

    let m = (42 | Option return)
    
    assert equal ($m | Option bind {|x| $x | Option return }) $m
}

# Left Identity
#
# return x >>= f == f x
def monad-identity-left [] {
    alias "Option return" = Option pure
   
    let f = {|x| $x | Option return }
    let x = 1

    assert equal ($x | Option return | Option bind $f) (do $f $x)
}
