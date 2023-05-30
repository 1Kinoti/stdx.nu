# | impl `List` 

use ./common.nu
use ./option.nu
use ./result.nu

export def is-list [l: any] {
    ($l | describe) starts-with "list"
}

export def head_ [l: any] {
    $l | branch "head" {|x|
        if ($x | is-empty) {
            option new
        } else {
            option new $x.0
        }
    }
}

export def last [l: any] {
    $l | branch "last" {|x|
        if ($x | is-empty) {
            option new
        } else {
            option new ($x | get ($in | length | $in - 1)) 
        }
    }
}

export def flat-map [
    fn: closure,
    l: any,
] {
    $l | branch "flat-map" {|x|
        let go = {|x, y|
            $y ++ (do $fn $x)
        }

        fold_ $go [] $x -r
    }
}

export def filter-map [
    fn: closure,
    l: any,
] {
    $l | branch "filter-map" {|x|
       
    }
}

export def find-index [
    fn: closure,
    l: any,
] {
    $l | branch "find-index" {|x|
        find-indices $fn $x | head_ $in
    }
}

export def zip-with [
    fn: closure,
    that: list,
    this: any,
] {
    $this | branch "zip-with" {|x|
        let go = {|x, y|
            (do $fn $x.0 $x.1) ++ $y
        }

        fold_ $go [] ($this | zip $that) -r
    }
}

export def partition [
    fn: closure,
    l: any,
] {
    $l | branch "partition" {|x|
        let go = {|x, y|
            if (do $fn $x) {
                [($x ++ $y.0), $y.1]
            } else {
                [$y.0, ($x ++ $y.1)]
            }
        }

        fold_ $go [[] []] $x -r
    }
}

export def find-indices [
    fn: closure,
    l: any,
] {
    $l | branch "find-indices" {|x|
        let go = {|x, y|
            if (do $fn $x.1) {
                $x.0 ++ $y
            } else {
                $y
            }
        }

        fold_ $go [] -r (
            $x | enumerate | each {|x| [$x.index, $x.item]}
        )
    }
}

export def find [
    fn: closure,
    l: any,
] {
    $l | branch "find" {|x|
        let go = {|x, y|
            get-first (
                if (do $fn $x) { option new $x } else { option new }
            ) $y
        }

        fold_ $go (option new) $x -r
    }
}

export def and [l: any] {
    $l | branch "and" {|x|
       let ty = ($l | describe) 
       if $ty == "list<bool>" {
            let go = {|x, y|
                $x and $y
            }

            fold_ $go true $x -r
       } else {
           error make -u {
               msg: (
                   [
                       "`List and` expected an input of type `list<bool>`"
                       $"but was supplied an input of type `($ty)`"
                   ] | str join "\n"
               )
           }
       }
    }
}

export def or [l: any] {
    $l | branch "or" {|x|
       let ty = ($l | describe) 
       if $ty == "list<bool>" {
            let go = {|x, y|
                $x or $y
            }

            fold_ $go false $x -r
       } else {
           error make -u {
               msg: (
                   [
                       "`List or` expected an input of type `list<bool>`"
                       $"but was supplied an input of type `($ty)`"
                   ] | str join "\n"
               )
           }
       }
    }
}

export def intersperse [
    sep: any,
    l: any
] {
    $l | branch "intersperse" {|x|
        let go = {|x, y|
            [$x, $sep] ++ $y
        }

        fold_ $go [] $x -r | init_ $in
    }
}

export def init_ [
    l: any,
] {
    $l | branch "init" {|x|
        if ($x | is-empty) {
           []
        } else {
            $x | take ($in | length | $in - 1)
        }
    }
}

export def fold_ [
    fn: closure,
    init: any,
    l: any,
    --right(-r): bool,
    --left(-l): bool,
] {
    let name = (if $right { "foldr" } else { "foldl" })
    $l | branch $name {|x|
        if $right {
            $x | reverse | reduce -f $init $fn
        } else {
            $x | reduce -f $init (flip $fn)
        }
    }
}

export def cat_ [
    l: any,
    --option(-o): bool,
    --result(-r): bool,
] {
    let name = (
        if $option {
            ["Option" "cat-options"]
        } else {
            ["Result" "cat-results"]
        }
    )

    if $option {
        if (is-list $l) and ($l | all {|x| option is-option $x }) {
            let go = {|x, y|
                if (option is-some $x) {
                    $y ++ $x.data
                } else {
                    $y 
                }
            }

            fold_ $go [] $l -r
        } else {
            error make -u { msg: $"`($name.0) ($name.1)` expects a list of `($name.0)`s" }
        }
    } else {
        if (is-list $l) and ($l | all {|x| result is-result $x }) {
            let go = {|x, y|
                if (result is-ok $x) {
                    $y ++ $x.data
                } else {
                    $y 
                }
            }

            fold_ $go [] $l -r
        } else {
            error make -u { msg: $"`($name.0) ($name.1)` expects a list of `($name.0)`s" }
        }
    } 
}

export def traverse [
    fn: closure,
    --option(-o): bool,
    --result(-r): bool,
] {
    
}

export def scan [
    fn: closure,
    init: any,
    l: any,
    --right(-r): bool,
    --left(-l): bool,
] {
    let name = (if $right { "scanr" } else { "scanl" })
    $l | branch $name {|x|
        if $right {
            def head [xs] { $xs | first }
            let f = {|x, y|
                do $fn $x (head $y) | append $y
            }

            fold_ $f [$init] $x -r 
        } else {
            let f = {|x, y|
                let z = ($x | get ($in | length | $in - 1))
                $x | append (do $fn $z $y)
            }

            fold_ $f [$init] $x -l
        }
    }
}

def get-first [
    a: record<type: string, some: bool, data: any>,
    b: record<type: string, some: bool, data: any>,
] {
    match [$a, $b] {
        [{ type: "Option", some: false, data: $__ }, $b] => $b,
                                                [$a, $_] => $a
   }
}

def flip [
    fn: closure,
] {
    {|a, b| do $fn $b $a }
}

def branch [
    name: string,
    fn: closure,
] {
    if (is-list $in) or ($in | describe | $in starts-with 'table') {
        do $fn $in
    } else if ($in | describe | $in == 'range') {
        do $fn ($in | reduce -f [] {|a, b| $b ++ $a })
    } else {
        error make -u { msg: (expected-list $name) }
    }
}

def expected-list [
    fn: string          # The name of the function
] {
    $"`List ($fn)` expects a list input"
}
