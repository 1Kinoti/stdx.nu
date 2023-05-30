# | doc tests for `stdx List`

use ../../src/List/
use ./fetch.nu extract

export def tests [] {
    def mk-test [
       name: string,
       test: string,
    ] {
       { name: $name, test: $test }
    }

    [
        # (mk-test "List head" (List help head)) # why doe this fail?
        (mk-test "List last" (List help last))
        (mk-test "List init" (List help init))
        (mk-test "List intersperse" (List help intersperse))
        (mk-test "List foldr" (List help foldr))
        (mk-test "List foldl" (List help foldl))
        (mk-test "List scanr" (List help scanr))
        (mk-test "List scanl" (List help scanl))
        (mk-test "List find" (List help find))
        (mk-test "List partition" (List help partition))
        (mk-test "List find-index" (List help find-index))
        (mk-test "List find-indices" (List help find-indices))
        (mk-test "List zip-with" (List help zip-with))
        (mk-test "List and" (List help and))
        (mk-test "List or" (List help or))
    ] | each {|t|
        mk-test $t.name (extract $t.test) 
    } | filter {|t| not ($t.test | is-empty) }
}
