# | doc tests for `stdx Result`

use ../../src/Result/
use ./fetch.nu extract

export def tests [] {
    def mk-test [
       name: string,
       test: string,
    ] {
       { name: $name, test: $test }
    }

    [
        (mk-test "Result map" (Result help map))
        (mk-test "Result flatten" (Result help flatten))
        (mk-test "Result bind" (Result help bind))
        (mk-test "Result apply" (Result help apply))
        (mk-test "Result lift-a2" (Result help lift-a2))
        (mk-test "Result hush" (Result help hush))
    ] | each {|t| mk-test $t.name (extract $t.test) }
}
