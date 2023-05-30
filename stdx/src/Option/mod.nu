# | `stdx Option`
#
# Type `Option` represents an optional value: every `Option` is either `Some`
# and contains a value, or `None`, and does not.

use ../Util/
use ../Help/

# | -- Help and Usage

# | Prints help information on `Option`
export def help [
    topic?: string
    --long(-l): bool
] {
    if $long {
        Help option -l
    } else {
        Help option $topic 
    }
}

# | -- Constructors

# | The constructor for the `Option` type
export def new [data?: any] {
   Util option new $data
}

# | Another constructor for the `Option` type
export def lift [] {
    Util option new $in
}

# | -- Predicates

# | Returns `true` if the input is a valid `Option`
export def is-option [] {
    Util option is-option $in
}

# | Returns `true` if the `Option` is a `Some`
export def is-some [] {
    Util option is-some $in
}

# | Returns `true` if the `Option` is a `None`
export def is-none [] {
    Util option is-none $in
}

# | Returns `true` if the `Option` is a `Some` and the
# contained value matches the predicate
export def is-some-and [
    fn: closure    # the predicate
] {
    Util option is-some-and $in $fn
}

# | -- Natural Transformations

# | Converts an `Option a` into a `Result a b`
export def note [msg: string] {
    Util option nat $in --result $msg
}

# | Converts a `Option a` into a `List a`
export def to-list [] {
    Util option nat $in --list
}

# | Extracts all contained values of the elements that
# are `Some` from a list of `Option`s
export def cat-options [] {
    Util list cat_ $in -o
}

# | -- Extractors

# | Returns the contained `Some` value, emmiting an error
# if the value is `None`
export def unwrap [] {
    Util option unwrap $in
}

# | Returns the cotained `Some` value, or the default if `None`
export def unwrap-or [
    default: any    # the default value
] {
    Util option unwrap $in --or $default
}

# | -- Functor

# | Maps an `Option a` to an `Option b`, by applying a function
# with the signature `a -> b` to the contained value if `Some`,
# else returning `None`
export def map [
    fn: closure    # the function to apply
] {
    Util option fmap $fn $in
}

# | -- Applicative

# | Lifts a value into a `Option`
export alias pure = lift

# | Applys an `Option (a -> b)` to a `Option a`, by applying
# the nested function ^^^^^^^ to the argument
export def apply [
    opt: record<type: string, some: bool, data: any>
] {
    Util option apply $in $opt
}

# | Lifts a binary function into two `Option`s
export def lift-a2 [
    fn: closure,
    opt: record<type: string, some: bool, data: any>
] {
    Util option lift-a2 $fn $in $opt
}

# | -- Monad

# | Maps an `Option a` to an `Option b`, by applying a function
# with the signature `a -> Option b` to the contained value
# and flattening the result if `Some`, else returning `None`
export def bind [
    fn: closure    # the function to apply
] {
    Util option bind $fn $in
}

# | Removes one level of nestion from a nested `Option`
export def flatten [] {
    Util option join $in
}

# | -- Display

# | Prints the string respresentation of the `Option`
export def show [] {
    Util option show $in
}
