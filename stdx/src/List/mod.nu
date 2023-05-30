# | `stdx List`
#
# Extensions for `core filter` that work on lists

use ../Help/
use ../Util/

# | -- Help and Usage

# | Prints help information on `List`
export def help [
    topic?: string
    --long(-l): bool
] {
    if $long {
        Help list -l
    } else {
        Help list $topic 
    }
}

# | -- Basic functions

# Extract the first element of a list, if any
export def head [] {
    Util list head_ $in
}

# Extract the last element of a list, if any
export def last [] {
    Util list last $in
}

# Extract the all element of a list except the last
export def init [] {
    Util list init_ $in
}

# | -- List transformations

# Inserts the argument between the elements of the list 
export def intersperse [
    sep: any
] {
    Util list intersperse $sep $in
}

# | -- Folds

# | Reduces the list using the binary operator, 
# from right to left
export def foldr [
    fn: closure,
    init: any,
] {
    Util list fold_ $fn $init $in -r
}

# | Reduces the list using the binary operator, 
# from right to left
export def foldl [
    fn: closure,
    init: any,
] {
    Util list fold_ $fn $init $in -l
}

# | Maps a function returning a list over a list 
# and concatenate the results
export def flat-map [
    fn: closure
] {
    Util list flat-map $fn $in
}

# | Returns the conjunction of a Boolean list
export def and [] {
    Util list and $in
}

# | Returns the disjunction of a Boolean list
export def or [] {
    Util list or $in
}

# | -- Building lists

# | Returns a list of successive reduced values from the left
export def scanl [
    fn: closure,
    init: any,
] {
    Util list scan $fn $init $in -l
}

# | Returns a list of successive reduced values from the right
export def scanr [
    fn: closure,
    init: any,
] {
    Util list scan $fn $init $in -r
}

# | -- Predicates

#  | Returns `true` if the input is a `List`
export def is-list [] {
    Util list is-list $in
}

# | -- Searching lists

# | Returns the first element of the structure matching
# the predicate, if any
export def find [
    fn: closure 
] {
    Util list find $fn $in
}

# | Returns the pair of lists of elements which do and do not
# satisfy the predicate
export def partition [
    fn: closure
] {
    Util list partition $fn $in
}

# | -- Indexing lists

# | Returns the index of the first element in the list 
# satisfying the predicate, if any
export def find-index [
    fn: closure
] {
    Util list find-index $fn $in 
}

# | Returning the indices of all elements satisfying the 
# predicate, in ascending order
export def find-indices [
    fn: closure
] {
    Util list find-indices $fn $in 
}

# | -- Zipping lists

# | Zips two lists and combines each pair using the function
export def zip-with [
    fn: closure
    other: list,
] {
    Util list zip-with $fn $other $in
}
