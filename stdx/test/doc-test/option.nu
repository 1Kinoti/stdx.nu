# | doc tests for `stdx Option`

use ../../src/Option/
use ./fetch.nu extract

export def tests [] {
    def mk-test [
       name: string,
       test: string,
    ] {
       { name: $name, test: $test }
    }

    [
        (mk-test "Option map" (Option help map))
        (mk-test "Option flatten" (Option help flatten))
        (mk-test "Option bind" (Option help bind))
        (mk-test "Option apply" (Option help apply))
        (mk-test "Option lift-a2" (Option help lift-a2))
        (mk-test "Option note" (Option help note))
    ] | each {|t| mk-test $t.name (extract $t.test) }
}
