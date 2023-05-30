# | Help for `Option`

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

(_note)
"
}

export def short [] {
$"(syn title 'type `Option`')

    The `Option` type represents an optional value: every Option is 
    either Some and contains a value, or None, and does not. Rather
    than using `null` to represent the absence of a value, we can 
    embbed that absence in an `Option`. This forces us to handle the
    `None` case rather than crashing. Of course, since this type is
    not checked by the `nu` compiler, wrongful use nullifies its
    importance.

    Use the `Option help` command to get help on this type

    > (syn cmd 'Option') (syn sub 'help')           (syn cmt '# display short help')
    > (syn cmd 'Option') (syn sub 'help') (syn opr '--')long    (syn cmt '# display long help')
    > (syn cmd 'Option') (syn sub 'help') (syn lit "'map'")     (syn cmt '# display help for a topic')

    Note that, to actually use this type, you have to import it like
    this

    > (syn kw 'use') (syn lit '/path/to/stdx') (syn opr '*')

    This will not work and will only import a wrapper to the `Option help`
    command.

    > (syn kw 'use') (syn lit '/path/to/stdx/Option')

    You can also import it like this, but this detaches the commands from
    the `Option` prefix, and some commands might collide with the ones from
    `core`

    > (syn kw 'use') (syn lit '/path/to/stdx/Option/') (syn opr '*')
"
}

export def _pred [] {
$"(syn title 'Querying the variant')
    The `Option is-some` command returns `true` if the input `Option`
    is `Some`, while the `Option is-none` command returns `true` if the
    input `Option` is `None`.

    The `Option is-some-and` returns `true` if the input `Option` is 
    `Some` and the contained value matches the predicate

    An additional, `Option is-option` is provided for checking whether
    the input is a valid `Option`
"
}

export def _unwrap [] {
$"(syn title 'Extracting values from an `Option`')
    To extract a value from an `Option`, we have several methods for
    doing so. We have listed them from the 'not-so-good' to the best

    (syn title '1.') (syn title-2 'Using a cellpath')
    An `Option` is internally a record with the following signature

    |>    record<type: string, some: bool, data: any>

    This means that you can use a cell-path to access, the nested.

    > (syn kw 'let') val (syn opr '=') (syn wrap-in-parens $'(syn cmd "Option") (syn sub new) (syn lit "'stdx'")') 
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'val.data') (syn lit "'stdx'") 

    > (syn kw 'let') val (syn opr '=') (syn wrap-in-parens $'(syn cmd "Option") (syn sub new)') 
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'val.data') (syn lit "null") 
    
    This is method defeats the purpose of using an `Option` and is
    highly discouraged, unless it is guarded by first checking for
    'Some-ness'

    > (syn kw 'let') val (syn opr '=') (syn wrap-in-parens $'(syn cmd "Option") (syn sub new)') 
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn kw "if") (syn del '(')(syn var 'val') (syn pipe) (syn cmd "Option") (syn sub "is-some")(syn del ')') (syn del '{') (syn var 'val.data') (syn del '}') (syn kw "else") (syn del '{') (syn lit "'nothing'") (syn del '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn lit "'nothing'")

    (syn title '2.') (syn title-2 'Using the `Option unwrap` command')
    This is basically the above method \(using cell-paths) wrapped
    in a command, but with an error if the `Option` is `None`

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn del '[')(syn lit '1 2 3 4')(syn del ']')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Option') (syn sub 'unwrap')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '[')(syn lit '1 2 3 4')(syn del ']')

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new')(syn del ')')
    > (syn cmd 'assert') (syn sub 'error') (syn del '{') (syn var 'val') (syn pipe) (syn cmd 'Option') (syn sub 'unwrap') (syn del '}')

    (syn title '3.') (syn title-2 'Using the `Option unwrap-or`')
    With this command, you provide a value to be returned if the
    `Option` is `None`. 

    > (syn kw 'let') maybe_guy (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'maybe_guy') (syn pipe) (syn cmd 'Option') (syn sub 'unwrap-or') (syn opr '{') name(syn colon) (syn lit "'John Doe'")(syn comma) age(syn colon) (syn lit '25') (syn opr '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn opr '{') name(syn colon) (syn lit "'John Doe'")(syn comma) age(syn colon) (syn lit '25') (syn opr '}') 

    (syn title '4.') (syn title-2 'Pattern matching')
    This is the best method, but because of the way the `Option` type
    is represented, it might become verbose.

    >. (syn kw 'match') (syn var 'val') (syn del '{') 
    >.    (syn opr '{') type(syn colon) (syn lit 'Option')(syn comma) some(syn colon) (syn lit 'true'), data: (syn var 'x') (syn opr '}') (syn opr '=>') (syn var 'x')(syn comma) 
    >.    (syn lit '_') (syn opr '=>') (syn lit "'found nothing'")(syn comma)
    >. (syn del '}')
"
}

export def _new [] {
$"(syn title 'Creating an Option')
    To create an `Option`, we have the `Option new` command with this
    signature

    |>    (syn cmd 'Option') (syn sub 'new') (syn lit 'value')(syn opr '?')

    Where the value is provided, a `Some value` is created, else a
    `None` is created.

    > (syn cmd 'Option') (syn sub 'new')      (syn cmt '# a `None` value')
    > (syn cmd 'Option') (syn sub 'new') (syn lit '42')   (syn cmt '# a `Some 42`')

    Sometimes, the value we want to create a value from a pipeline
    input. To do this, we have the `Option lift` command, with this
    signature.

    |>    (syn lit 'value')(syn opr '?') (syn pipe) (syn cmd 'Option') (syn sub 'lift') 

    > (syn cmd 'ls') (syn pipe) (syn cmd 'get') (syn lit '50')(syn opr '?') (syn pipe) (syn cmd 'Option') (syn sub 'lift') 
"
}

export def _note [] {
$"(syn title 'Option note')
    `Option note` transforms a `Some a` to an `Ok a`, and a `None` to an
    `Err` using the provided `err` value.

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '200')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Option') (syn sub 'note') (syn lit "'no value was provided'")(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn lit '200') (syn pipe) (syn cmd 'Result') (syn sub 'lift')(syn del ')')

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Option') (syn sub 'note') (syn lit "'no value was provided'")(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn lit "'no value was provided'") (syn pipe) (syn cmd 'Result') (syn sub 'lift-err')(syn del ')')
"
}

export def _flatten [] {
$"(syn title 'Option flatten')
    `Option flatten` removes one level of nesting from an `Option \(Option a)`

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '42')(syn del ')')
    > (syn kw 'let') nested (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn var 'val')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn del '(')(syn var 'nested') (syn pipe) (syn cmd 'Option') (syn sub 'flatten')(syn del ')') (syn var 'val') 
"
}

export def _map [] {
$"(syn title 'Option map')
    `Option map` tranforms the `Option a` to an `Option b` using the supplied
    value if `Some`, else returns the `None` unchanged

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '42')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Option') (syn sub 'map') (syn del '{')(syn opr '|')x(syn opr '|') (syn var 'x') (syn opr '+') (syn lit '27') (syn del '}')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '69')(syn del ')')
"
}

export def _apply [] {
$"(syn title 'Option apply')
    `Option apply` applies the function in an `Option closure` to the contained
    value on an `Option`.

    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit "'stdx'")(syn del ')')
    > (syn kw 'let') fn  (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn del '{')(syn opr '|')x(syn opr '|') (syn var 'x') (syn pipe) (syn cmd 'length')(syn del '}')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'fn') (syn pipe) (syn cmd 'Option') (syn sub 'apply') (syn var 'val')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '1')(syn del ')')
"
}

export def _lift-a2 [] {
$"(syn title 'Option lift-a2')
    `Option lift-a2` applies a binary function to two `Option`s

    > (syn kw 'let') add (syn opr '=') (syn del '{')(syn opr '|')x, y(syn opr '|') (syn var 'x') (syn opr '+') (syn var 'y') (syn del '}') 
    > (syn kw 'let') a (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '42')(syn del ')')
    > (syn kw 'let') b (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '27')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'a') (syn pipe) (syn cmd 'Option') (syn sub 'lift-a2') (syn var 'add') (syn var 'b')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '69')(syn del ')')
"    
}

export def _bind [] {
$"(syn title 'Option bind')
    `Option bind` transforms the input `Option a` to an `Option b`, by
    applying the supplied function, that itself produces another `Option`,
    leading to a nested `Option`, then flattening the result

    >. (syn kw 'let') int_half (syn opr '=') (syn opr '{')(syn opr '|')x(syn opr '|')
    >.   (syn kw 'if') (syn del '(')(syn var 'x') (syn pipe) (syn cmd 'describe') (syn pipe) (syn var 'in') (syn opr '!=') (syn lit "'int'")(syn del ')') (syn del '{')
    >.       (syn cmd 'Option') (syn sub 'new') 
    >.   (syn del '}') (syn kw 'else') (syn del '{') 
    >.       (syn cmd 'Option') (syn sub 'new') (syn wrap-in-parens $'(syn var "x") (syn opr "/") (syn lit "2")')
    >.   (syn del '}') 
    >. (syn opr '}')
    > (syn kw 'let') val (syn opr '=') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '42')(syn del ')')
    > (syn kw 'let') res (syn opr '=') (syn del '(')(syn var 'val') (syn pipe) (syn cmd 'Option') (syn sub 'bind') (syn var 'int_half')(syn del ')')
    > (syn cmd 'assert') (syn sub 'equal') (syn var 'res') (syn del '(')(syn cmd 'Option') (syn sub 'new') (syn lit '21')(syn del ')')
"
}
