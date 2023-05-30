# | Tests


use ./property/
use ./doc-test/
use ../src/ *

export def main [] {
    [
        (run "Option" (property Option tests))
        (run "Result" (property Result tests))

        (doc "Option" (doc-test option tests))
        (doc "Result" (doc-test result tests))
        (doc "List" (doc-test list tests))
    ] | str join "\n"
}

def run [
    module: string,
    tests: list<record<
       name: string,
       test: closure,
    >>
] {

    let res = (
        $tests
        | each {|t|
            try {
                do $t.test
                $"(ansi lg)ok!(ansi reset): property test `(ansi dgr)($t.name)(ansi reset)`"
            } catch {|e|
                [
                    $"(ansi lr)not-ok!(ansi reset): property tests for `(ansi dgr)($t.name)(ansi reset)` failed with"
                    $">\t(ansi dgr)($e.msg)(ansi reset)"
                ] | str join "\n" 
            }
        } 
        | List partition {|x|
            $x | ansi strip | str starts-with 'not-ok'
        }
    )

    let failures  = ( $res.0 | str join "\n" )
    let successes = ( $res.1 | str join "\n" )



$"(ansi lgb)running property tests for `($module)`(ansi reset)

($tests | length) tests ran
($res.1 | length) passed
($res.0 | length) failed

(ansi lgb)Passed(ansi reset)
(if ($successes | is-empty) { "None" } else { $successes } )

(ansi lrb)Failed(ansi reset)
(if ($failures | is-empty) { "None" } else { $failures } )
"
}

def doc [
    module: string,
    tests: list<record<
       name: string,
       test: string,
    >>
] {
    let res = (
        $tests 
        | each {|t|
            try {
                nu -c $"use std *; use stdx *; ($t.test)"
                $"(ansi lg)ok!(ansi reset): doc tests for `(ansi dgr)($t.name)(ansi reset)`"
            } catch {|e|
                [
                    $"(ansi lr)not-ok!:(ansi reset) doc tests for `(ansi dgr)($t.name)(ansi reset)` failed with"
                    $">\t(ansi dgr)($e.msg)(ansi reset)"
                ] | str join "\n"
            }
        }
        | List partition {|x|
            $x | ansi strip | str starts-with 'not-ok'
        }
    )

    let failures  = ( $res.0 | str join "\n" )
    let successes = ( $res.1 | str join "\n" )

$"(ansi lgb)running doc tests for `($module)(ansi reset)`

($tests | length) tests ran
($res.1 | length) passed
($res.0 | length) failed

(ansi lgb)Passed(ansi reset)
(if ($successes | is-empty) { "None" } else { $successes } )

(ansi lrb)Failed(ansi reset)
(if ($failures | is-empty) { "None" } else { $failures } )
"
}
