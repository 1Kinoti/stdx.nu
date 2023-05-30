# | Help for `Result`

use ./syn.nu

export def long [] {
$"
(short)

(_new)

(_pred)

(_unwrap)

(syn title 'Transforming contained values')
(_map)

(_flatten)

(_bind)

(_apply)

(_lift-a2)

(_hush)
"
}

export def short [] {
$"(syn title 'type `Result`')

    The `Result` type is used for representing fallible operations. It 
    is either an `Ok a`, representing success and containing a value, or
    an `Err b`, representing error and containing an error value.

    Use the `Result help` command to get help on this type

    > (syn cmd 'Result') (syn sub 'help')           (syn cmt '# display short help')
    > (syn cmd 'Result') (syn sub 'help') (syn opr '--')long    (syn cmt '# display long help')
    > (syn cmd 'Result') (syn sub 'help') (syn lit "'map'")     (syn cmt '# display help for a topic')

    Note that, to actually use this type, you have to import it like
    this

    > (syn kw 'use') (syn lit '/path/to/stdx') (syn opr '*')

    This will not work and will only import a wrapper to the `Result help`
    command.

    > (syn kw 'use') (syn lit '/path/to/stdx/Result')

    You can also import it like this, but this detaches the commands from
    the `Result` prefix, and some commands might collide with the ones from
    `core`

    > (syn kw 'use') (syn lit '/path/to/stdx/Result/') (syn opr '*')
"
}

export def _new [] {
$"(syn title 'Creating a Result')
    To create a `Result`, we have two methods, which are used differently
    depending on the source pf the data.

    (syn title '1.') (syn title-2 'Data as an argument')
    When data is given as an argument, we use `Result ok` and `Result err`

    > (syn kw 'let') val_ok (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '4')(syn del ')')
    > (syn kw 'let') val_err (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'err') (syn lit "'could not fetch contents'")(syn del ')')

    (syn title '2.') (syn title-2 'Data as pipeline input')
    When data is piped in, we use `Result lift` and `Result lift-err`

    > (syn kw 'let') val_ok (syn opr '=') (syn del '(')(syn del '[')(syn lit '1 2 3 4')(syn del ']') (syn pipe) (syn cmd 'Result') (syn sub 'lift')(syn del ')')
    > (syn kw 'let') err_code (syn opr '=') (syn del '(')(syn lit '404') (syn pipe) (syn cmd 'Result') (syn sub 'lift-err')(syn del ')')
"
}

export def _pred [] {
$"(syn title 'Querying the variant')
    The `Result is-ok` command returns `true` if the input `Result`
    is `Ok`, while the `Result is-ee` command returns `true` if the
    input `Result` is `Err`.

    The `Result is-ok-and` returns `true` if the input `Result` is 
    `Ok` and the contained value matches the predicate

    An additional, `Result is-result` is provided for checking whether
    the input is a valid `Result`
"
}

export def _unwrap [] {
$"(syn title 'Extracting values from a `Result`')
    To extract a value from a `Result`, we have several methods for
    doing so. We have listed them from the 'not-so-good' to the best

    (syn title '1.') (syn title-2 'Using a cellpath')
    A `Result` is internally a record with the following signature

    |>    record<type: string, ok: bool, data: any>

    This means that you can use a cell-path to access, the nested.

    > (syn kw 'let') val (syn opr '=') (syn wrap-in-parens $'(syn cmd "Result") (syn sub "ok") (syn lit "'stdx'")') 
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'val.data') (syn lit "'stdx'") 

    > (syn kw 'let') unhelpful (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'lift-err') (syn lit `'an error occurred'`)(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'unhelpful.data') (syn lit "'an error occurred'") 
    
    This is method defeats the purpose of using a `Result` and is
    highly discouraged, unless it is guarded by first checking for
    'Ok-ness'

    > (syn kw 'let') val (syn opr '=') (syn wrap-in-parens $'(syn cmd "Result") (syn sub "err") (syn lit "404")') 
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn kw "if") (syn del '(')(syn var 'val') (syn pipe) (syn cmd "Result") (syn sub "is-ok")(syn del ')') (syn del '{') (syn var 'val.data') (syn del '}') (syn kw "else") (syn del '{') (syn lit "'could not find it'") (syn del '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn lit "'could not find it'")

    (syn title '2.') (syn title-2 'Using the `Result unwrap` command')
    This is basically the above method \(using cell-paths) wrapped
    in a command, but with an error if the `Result` is `Err`

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn del '[')(syn lit '1 2 3 4')(syn del ']')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'unwrap')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '[')(syn lit '1 2 3 4')(syn del ']')

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'lift-err') (syn lit `'unknown error'`)(syn del ')')
    > (syn cmd 'assert') (syn sub 'error') (syn del '{') (syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'unwrap') (syn del '}')

    (syn title '3.') (syn title-2 'Using the `Result unwrap-or`')
    With this command, you provide a value to be returned if the
    `Result` is `Err`. 

    > (syn kw 'let') fetch_guy (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'lift err') (syn lit `'could not fetch the person'`)(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'fetch_guy') (syn pipe) (syn cmd 'Result') (syn sub 'unwrap-or') (syn opr '{') name(syn colon) (syn lit "'John Doe'")(syn comma) age(syn colon) (syn lit '25') (syn opr '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn opr '{') name(syn colon) (syn lit "'John Doe'")(syn comma) age(syn colon) (syn lit '25') (syn opr '}') 

    (syn title '4.') (syn title-2 'Pattern matching')
    This is the best method, but because of the way the `Result` type
    is represented, it might become verbose.

    >. (syn kw 'match') (syn var 'val') (syn del '{') 
    >.    (syn opr '{') type(syn colon) (syn lit 'Result')(syn comma) ok(syn colon) (syn lit 'true'), data: (syn var 'x') (syn opr '}') (syn opr '=>') (syn var 'x')(syn comma) 
    >.    (syn lit '_') (syn opr '=>') (syn lit "'mmmmh, this is unexpected'")(syn comma)
    >. (syn del '}')
"
}
export def _map [] {
$"(syn title 'Result map') and (syn title 'Result map-err')
    `Result map` tranforms the `Result a e` to a `Result b e` using the supplied
    closure if `Ok`, else returns the `Err` unchanged

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '42')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'map') (syn del '{')(syn opr '|')x(syn opr '|') (syn var 'x') (syn opr '+') (syn lit '27') (syn del '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '69')(syn del ')')

    `Result map-err` on the other hand tranforms the `Result a e` to a `Result a f`
    using the closure if `Err`, else returns the `Ok` unchanged

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'err') (syn lit `'file does not exist'`)(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'map-err') (syn del '{')(syn opr '|')x(syn opr '|') (syn var 'x') (syn pipe) (syn cmd 'str') (syn sub 'upcase') (syn del '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Result') (syn sub 'err') (syn lit `'FILE DOES NOT EXIST'`)(syn del ')')
"
}

export def _flatten [] {
$"(syn title 'Result flatten')
    `Result flatten` removes one level of nesting from a `Result \(Result a e)`

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '42')(syn del ')')
    > (syn kw 'let') nested (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn var 'val')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn del '(')(syn var 'nested') (syn pipe) (syn cmd 'Result') (syn sub 'flatten')(syn del ')') (syn var 'val') 
"
}

export def _bind [] {
$"(syn title 'Result bind')
    `Result bind` transforms the input `Result a e` to a `Result b e`, by
    applying the supplied function, that itself produces another `Result`,
    leading to a nested `Result`, then flattening the result

    >. (syn kw 'let') int_half (syn opr '=') (syn opr '{')(syn opr '|')x(syn opr '|')
    >.   (syn kw 'if') (syn del '(')(syn var 'x') (syn pipe) (syn cmd 'describe') (syn pipe) (syn var 'in') (syn opr '!=') (syn lit "'int'")(syn del ')') (syn del '{')
    >.       (syn cmd 'Result') (syn sub 'err') (syn lit `'we only do integers, sorry :)'`) 
    >.   (syn del '}') (syn kw 'else') (syn del '{') 
    >.       (syn cmd 'Result') (syn sub 'ok') (syn wrap-in-parens $'(syn var "x") (syn opr "/") (syn lit "2")')
    >.   (syn del '}') 
    >. (syn opr '}')
    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '42')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'bind') (syn var 'int_half')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '21')(syn del ')')
"
}

export def _apply [] {
$"(syn title 'Result apply')
    `Result apply` applies the function in a `Result closure` to the contained
    value on an `Result`.

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit "'stdx'")(syn del ')')
    > (syn kw 'let') fn  (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn del '{')(syn opr '|')x(syn opr '|') (syn var 'x') (syn pipe) (syn cmd 'length')(syn del '}')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'fn') (syn pipe) (syn cmd 'Result') (syn sub 'apply') (syn var 'val')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '1')(syn del ')')
"
}

export def _lift-a2 [] {
$"(syn title 'Result lift-a2')
    `Result lift-a2` applies a binary function to two `Result`s

    > (syn kw 'let') add (syn opr '=') (syn del '{')(syn opr '|')x, y(syn opr '|') (syn var 'x') (syn opr '+') (syn var 'y') (syn del '}') 
    > (syn kw 'let') a (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '42')(syn del ')')
    > (syn kw 'let') b (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '27')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'a') (syn pipe) (syn cmd 'Result') (syn sub 'lift-a2') (syn var 'add') (syn var 'b')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '69')(syn del ')')
"    
}

export def _hush [] {
$"(syn title 'Result hush')
    `Result hush` transforms an `Ok a` to a `Some a`, and an `Err e` to a
    `None` discarding the `Err` value

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'ok') (syn lit '4')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'hush')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '4')(syn del ')')
     
    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Result') (syn sub 'err') (syn lit '404')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Result') (syn sub 'hush')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Option') (syn sub 'new')(syn del ')')
"
}
