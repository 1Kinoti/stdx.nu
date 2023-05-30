# | `stdx Result`
#
# `Result a b` is the type used for returning and propagating errors. It can 
# either be an, `Ok a`, representing success and containing a value, or an 
# `Err b`, representing error and containing an error value.

use ../Help/
use ../Util/

# | -- Help and Usage

# | Prints help information on `Result`
export def help [
    topic?: string
    --long(-l): bool
] {
    if $long {
        Help result -l
    } else {
        Help result $topic 
    }
}

# | -- Constructors

# | A constructor for the `Ok` variant of `Result`
export def ok [a: any] {
    Util result new $a --ok
}

# | A constructor for the `Err` variant of `Result`
export def err [b: any] {
    Util result new $b
}

# | Another constructor for the `Ok` variant of `Result`
export def lift [] {
    Util result new $in --ok
}

# | Another constructor for the `Err` variant of `Result`
export def lift-err [] {
    Util result new $in
}

# | -- Predicates

# | Returns `true` if the input is a valid `Result`
export def is-result [] {
    Util result is-result $in
}

# | Returns `true` if the `Result` is an `Ok`
export def is-ok [] {
    Util result is-ok $in
}

# | Returns `true` if the `Result` is an `Err`
export def is-err [] {
    Util result is-err $in
}

# | Returns `true` if the `Result` is an `Ok` and the contained
# value matches the predicate
export def is-ok-and [
    fn: closure    # the predicate 
] {
    Util result is-ok-and $in $fn
}

# | Returns `true` if the `Result` is an `Err` and the contained
# value matches the predicate
export def is-err-and [
    fn: closure    # the predicate 
] {
    Util result is-err-and $in $fn
}

# | -- Natural Transformations

# | Converts a `Result a b` into an `Option a`
export def hush [] {
    Util result nat $in --option
}

# | Converts a `Result a b` into a `List a`
export def to-list [] {
    Util result nat $in --list
}

# | Extracts all contained values of the elements that
# are `Ok` from a list of `Result`s
export def cat-results [] {
    Util list cat_ $in -r
}

# | -- Extractors

# | Returns the contained `Ok` value, emmiting an error
# if the value is `Err`
export def unwrap [] {
    Util result unwrap $in
}

# | Returns the cotained `Ok` value, or the default if `Err`
export def unwrap-or [
    default: any    # the default value
] {
    Util result unwrap $in --or $default
}

# | -- Functor

# | Maps a `Result a e` to a `Result `b e`, by applying a function
# with the signature `a -> b`, to the contained value if `Ok`, else
# returning the `Result` unchanged
export def map [
    fn: closure    # the function to apply
] {
    Util result fmap $fn $in
}

# | -- Applicative

# | Lifts a value into a `Result`
export alias pure = lift

# | Applys a `Result (a -> b) e` to a `Result a e`, by applying
# the nested function ^^^^^^^ to the argument
export def apply [
    res: record<type: string, ok: bool, data: any>,
] {
    Util result apply $in $res
}

# | Lifts a binary function into two `Result`s
export def lift-a2 [
    fn: closure,
    res: record<type: string, ok: bool, data: any>,
] {
   Util result lift-a2 $fn $in $res
}

# | -- Monad

# | Maps an `Result a e` to an `Result b e`, by applying a function
# with the signature `a -> Result b e` to the contained value
# and flattening the result if `Ok`, else returning the `Result`
export def bind [
    fn: closure    # the function to apply
] {
    Util result bind $fn $in
}

# | Removes one level of nestion from a nested `Result`
export def flatten [] {
    Util result join $in
}

# | Lifts a value into a `Result`
export alias return = lift

# | -- Display

# | Prints the string respresentation of the `Result`
export def show [] {
    Util result show $in 
}

# | Extras

# | Maps a `Result a e` to a `Result `a f`, by applying a function
# with the signature `e -> f`, to the contained value if `Err`, else
# returning the `Result` unchanged
export def map-err [
    fn: closure    # the function to apply
] {
    Util result map-err $fn $in
}
