# | Help for `List`

use ./syn.nu

export def long [] {
$"
(short)

(_list)
"
}

export def short [] {
$"(syn title 'module `List`')

    The `List` module extends `core filter` and `std iter` by providing
    additional methods, and making safe wrappers around the partial commands
    These methods are 'strict' may not work with malfunctioned input, especially
    the ones that expect closures.

    Use the `List help` command to get help on this module

    > (syn cmd 'List') (syn sub 'help')           (syn cmt '# display short help')
    > (syn cmd 'List') (syn sub 'help') (syn opr '--')long    (syn cmt '# display long help')
    > (syn cmd 'List') (syn sub 'help') (syn lit "'map'")     (syn cmt '# display help for a topic')
    > (syn cmd 'List') (syn sub 'help') (syn lit "'commands'")     (syn cmt '# display a list of available commands')

    Note that, to actually use this module, you have to import it like
    this

    > (syn kw 'use') (syn lit '/path/to/stdx') (syn opr '*')

    This will not work and will only import a wrapper to the `List help`
    command.

    > (syn kw 'use') (syn lit '/path/to/stdx/List')

    You can also import it like this, but this detaches the commands from
    the `List` prefix, and some commands might collide with the ones from
    `core`

    > (syn kw 'use') (syn lit '/path/to/stdx/List/') (syn opr '*')
"
}

export def _list [] {
let cmds = (
    [
        (_head)
        (_last)
        (_init)
        (_intersperse)
        (_foldr)
        (_foldl)
        (_scanr)
        (_scanl)
        (_find)
        (_part)
        (_idx)
        (_ids)
        (_zwith)
        (_and)
        (_or)
    ] | str join "\n"
)

$"(syn title 'Available commands')
($cmds)
"
}

export def _head [] {
$"(syn title 'List head')
    (syn title-2 'Extract the first element, if any')

    > (syn kw 'let') maybe_head (syn opr '=') (syn del '([]') (syn pipe) (syn cmd 'List') (syn sub 'head')(syn del ')')
    > (syn cmd 'assert') (syn del '(')(syn var 'maybe_head') (syn pipe) (syn cmd 'Option') (syn sub 'is-none')(syn del ')')
"
}

export def _last [] {
$"(syn title 'List last')
    (syn title-2 'Extract the last element, if any')

    > (syn kw 'let') maybe_last (syn opr '=') (syn del '([')(syn lit '2 3 4')(syn del ']') (syn pipe) (syn cmd 'List') (syn sub 'last')(syn del ')')
    > (syn cmd 'assert') (syn del '(')(syn var 'maybe_last') (syn pipe) (syn cmd 'Option') (syn sub 'is-some-and') (syn del '{')(syn pipe)x(syn pipe) (syn var 'x') (syn opr '==') (syn lit '4') (syn del '}')(syn del ')')
"
}

export def _init [] {
$"(syn title 'List init')
    (syn title-2 'Extract the all element except the last')

    > (syn kw 'let') init (syn opr '=') (syn del '([')(syn lit '2 3 4')(syn del ']') (syn pipe) (syn cmd 'List') (syn sub 'init')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'init') (syn del '(')(syn del '[')(syn lit '2 3')(syn del ']')(syn del ')')
"
}

export def _intersperse [] {
$"(syn title 'List intersperse')
    (syn title-2 'Inserts the argument between the elements')

    > (syn kw 'let') list (syn opr '=') (syn del '([')(syn lit '2 3 4')(syn del ']') (syn pipe) (syn cmd 'List') (syn sub 'intersperse') (syn lit '0')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'list') (syn del '[')(syn lit '2 0 3 0 4')(syn del ']')
"
}

export def _flat_map [] {
$"(syn title 'List flat-map')
    (syn title-2 'Maps a function returning a list over a list and concatenate the results' )

    >. (syn kw 'let') list (syn opr '=') (syn del '(')
    >.    (syn del '[')(syn del '[')(syn lit '1 2 3')(syn del ']') (syn del '[')(syn lit '4 5 7')(syn del ']')(syn del '[')(syn lit '8 9 0')(syn del ']')(syn del ']') (syn pipe) (syn cmd 'List') (syn sub 'flat-map') (syn del '{')(syn pipe)x(syn pipe) (syn var 'x') (syn pipe) (syn cmd 'math') (syn sub 'sum') (syn del '}')
    >. (syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'list') (syn del '[')(syn lit '6 16 17')(syn del ']')
"
}

export def _foldr [] {
$"(syn title 'List foldr')
    (syn title-2 'Reduces the list using the binary operator, from right to left')

    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn del '[')(syn lit 'true false false false true')(syn del ']') (syn pipe) (syn cmd 'List') (syn sub 'foldr') (syn del '{')(syn opr '|')x y(syn opr '|') (syn var 'x') (syn opr 'and') (syn var 'y') (syn del '}') (syn lit 'true') (syn del ')')
    > (syn cmd 'assert') (syn sub 'not') (syn var 'res') 
"
}


export def _foldl [] {
$"(syn title 'List foldl')
    (syn title-2 'Reduces the list using the binary operator, from left to right:')

    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn del '[')(syn lit '1 2 3 4 5')(syn del ']') (syn pipe) (syn cmd 'List') (syn sub 'foldl') (syn del '{')(syn opr '|')x y(syn opr '|') (syn var 'x') (syn opr '+') (syn var 'y') (syn del '}') (syn lit '54') (syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn lit '69')
"
}


export def _scanr [] {
$"(syn title 'List scanr')
    (syn title-2 'Returns a list of successive reduced values from the left')

    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn lit '1')(syn opr '..')(syn lit '4') (syn pipe) (syn cmd 'List') (syn sub 'scanr') (syn del '{')(syn opr '|')x y (syn opr '|') (syn var 'x') (syn opr '+') (syn var 'y') (syn del '}') (syn lit '0') (syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '[')(syn lit '10 9 7 4 0')(syn del ']')
"
}

export def _scanl [] {
$"(syn title 'List scanl')
    (syn title-2 'Returns a list of successive reduced values from the right')

    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn lit '1')(syn opr '..')(syn lit '4') (syn pipe) (syn cmd 'List') (syn sub 'scanl') (syn del '{')(syn opr '|')x y (syn opr '|') (syn var 'x') (syn opr '+') (syn var 'y') (syn del '}') (syn lit '0') (syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '[')(syn lit '0 1 3 6 10')(syn del ']')
"
}

export def _find [] {
$"(syn title 'List find')
    (syn title-2 'Returns the first element matching the predicate, if any')

    > (syn kw 'let') vcs_list (syn opr '=') (syn del '[')(syn lit `'git' 'mercurial' 'darcs' 'svn'`)(syn del ']')
    > (syn kw 'let') finder (syn opr '=') (syn del '{')(syn pipe)x(syn pipe) (syn var 'x') (syn opr 'starts-with') (syn lit `'d'`) (syn del '}')
    > (syn kw 'let') maybe_vcs = (syn del '(')(syn var 'vcs_list') (syn pipe) (syn cmd 'List') (syn sub 'find') (syn var 'finder')(syn del ')')
    > (syn cmd 'assert') (syn del '(')(syn var 'maybe_vcs') (syn pipe) (syn cmd 'Option') (syn sub 'is-some')(syn del ')')
"
}


export def _part [] {
$"(syn title 'List partition')
    (syn title-2 'Returns the pair of lists of elements which do and do not satisfy the predicate')

    > (syn kw 'let') is_even (syn opr '=') (syn del '{')(syn pipe)x(syn pipe) (syn var 'x') (syn opr 'mod') (syn lit '2') (syn opr '==') (syn lit '0') (syn del '}')
    > (syn kw 'let') parts (syn opr '=') (syn del '(')(syn lit '0')(syn opr '..')(syn lit '100') (syn pipe) (syn cmd 'List') (syn sub 'partition') (syn var 'is_even')(syn del ')')
    > (syn cmd 'assert') (syn del '(')(syn var parts.0) (syn pipe) (syn cmd 'all') (syn var 'is_even')(syn del ')')
    > (syn cmd 'assert') (syn sub 'not') (syn del '(')(syn var parts.1) (syn pipe) (syn cmd 'all') (syn var 'is_even')(syn del ')')
"
}


export def _idx [] {
$"(syn title 'List find-index')
    (syn title-2 'Returns the index of the first element satisfying the predicate, if any')

    > (syn kw 'let') langs (syn opr '=') (syn del '[')(syn lit `'rust' 'haskell' 'typescript' 'nushell'`)(syn del ']')
    > (syn kw 'let') finder (syn opr '=') (syn del '{')(syn pipe)x(syn pipe) (syn var 'x') (syn opr 'starts-with') (syn lit `'x'`) (syn del '}')
    > (syn kw 'let') maybe_lang = (syn del '(')(syn var 'langs') (syn pipe) (syn cmd 'List') (syn sub 'find-index') (syn var 'finder')(syn del ')')
    > (syn cmd 'assert') (syn del '(')(syn var 'maybe_lang') (syn pipe) (syn cmd 'Option') (syn sub 'is-none')(syn del ')')
"
}


export def _ids [] {
$"(syn title 'List find-indices')
    (syn title-2 'Returning the indices of all elements satisfying the predicate, in ascending order')

    > (syn kw 'let') editors (syn opr '=') (syn del '[')(syn lit `'helix' 'lapce' 'neovim' 'notepad' 'vim'  'vs-code' 'kate'`)(syn del ']')
    > (syn kw 'let') finder (syn opr '=') (syn del '{')(syn pipe)x(syn pipe) (syn var 'x') (syn opr '=~') (syn lit `'vim'`) (syn del '}')
    > (syn kw 'let') vims = (syn del '(')(syn var 'editors') (syn pipe) (syn cmd 'List') (syn sub 'find-indices') (syn var 'finder')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'vims') (syn del '[')(syn lit '2 4')(syn del ']')
"
}


export def _zwith [] {
$"(syn title 'List zip-with')
    (syn title-2 'Zips two lists and combines each pair using the function')

    > (syn kw 'let') f_names (syn opr '=') (syn del '[')(syn lit `'john' 'mary' 'asuka' 'chandler' 'ayub' 'sienna' 'kate'`)(syn del ']')
    > (syn kw 'let') l_names (syn opr '=') (syn del '[')(syn lit `'adams' 'jane' 'akari' 'vlad' 'musa' 'serola' 'jean'`)(syn del ']')
    > (syn kw 'let') mk_name (syn opr '=') (syn del '{')(syn opr '|')f l(syn opr '|') (syn opr '{') first(syn colon) (syn var 'f')(syn comma) last(syn colon) (syn var 'l') (syn opr '}')  (syn del '}')
    > (syn kw 'let') names (syn opr '=') (syn del '(')(syn var 'f_names') (syn pipe) (syn cmd 'List') (syn sub 'zip-with') (syn var 'mk_name') (syn var 'l_names')(syn del ')')
    > (syn cmd 'assert') (syn del '(')(syn var 'names') (syn pipe) (syn cmd 'length') (syn pipe) (syn var 'in') (syn opr '==') (syn lit '7')(syn del ')')
"
}


export def _and [] {
$"(syn title 'List and')
    (syn title-2 'Returns the conjunction of a Boolean list')

    > (syn kw 'let') bools (syn opr '=') (syn del '[')(syn lit `true false true true false false`)(syn del ']')
    > (syn cmd 'assert') (syn sub 'not') (syn del '(')(syn var 'bools') (syn pipe) (syn cmd 'List') (syn sub 'and')(syn del ')')
"
}

export def _or [] {
$"(syn title 'List or')
    (syn title-2 'Returns the disjunction of a Boolean list')

    > (syn kw 'let') bools (syn opr '=') (syn del '[')(syn lit `true false true true false false`)(syn del ']')
    > (syn cmd 'assert') (syn del '(')(syn var 'bools') (syn pipe) (syn cmd 'List') (syn sub 'or')(syn del ')')
"
}
