# | impl `Result`

use ./common.nu

export def help [] {
    "Result a"
}

export def is-result [it: any] {
    match $it {
        { type: "Result", ok: true,  data: $__ } => true,
        { type: "Result", ok: false, data: $__ } => true,
                             _   => false
    }
}

export def new [
    it: any
    --ok: bool
] {
    if $ok {
        { type: "Result", ok: true,  data: $it }
    } else {
        { type: "Result", ok: false, data: $it }
    }
}

export def is-ok [res: any] {
    if (is-result $res) {
        $res.ok == true
    } else {
        error make -u (expected-result "Result is-ok")
    }
}

export def is-err [res: any] {
    if (is-result $res) {
        $res.ok == false
    } else {
        error make -u (expected-result "Result is-err")
    }
}

export def is-ok-and [res: any, fn: closure] { 
    let data = {
        name    : "Result is-ok-and",
        is_enum : {|x| is-result $x},
        is_right: {|x| is-ok $x  },
        expected: (expected-result "Result is-ok-and")
    }

    common is-right-and $res $fn $data
}

export def is-err-and [res: any, fn: closure] { 
    let data = {
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        on_right: {|_x| false },
        on_left : {|x|
            $fn | common is-predicate "Result is-err-and" $x.data
        
            do $fn $x.data
        },
        expected: (expected-result "Result is-err-and")
    }

    common branch $data
}

export def fmap [fn: closure, res: any] {
    let data = {
        pure    : {|x| new $x --ok }
        enum    : "Result",
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        expected: (expected-result "Result map")
    }

    common fmap $res $fn $data
}

export def map-err [fn: closure, res: any] {
    let data = {
        pure    : {|x| new $x }
        enum    : "Result",
        is_enum : {|x| is-result $x },
        is_right: {|x| is-err $x },
        expected: (expected-result "Result map-err")
    }

    common fmap $res $fn $data
}

export def apply [
    ra:  any,
    rb: record<type: string, ok: bool, data: any>,
] {
    if not (is-result $rb) { error make -u (expected-result "Result apply")}

    let data = {
        enum    : "Result",
        pure    : {|x| new $x --ok },
        right   : "ok",
        is_enum : {|x| is-result $x},
        is_right: {|x| is-ok $x },
        expected: (expected-result "Result apply")
    }

    common apply $ra $rb $data
}

export def lift-a2 [
    fn: closure,
    ra: any,
    rb: record<type: string, ok: bool, data: any>,
] {
    if not (is-result $rb) { error make -u (expected-result "Result lift-a2")}

    let data = {
        enum    : "Result",
        pure    : {|x| new $x --ok },
        right   : "ok",
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        expected: (expected-result "Result lift-a2")
    }

    common lift-a2 $ra $rb $fn $data
}

export def nat [
    res: any
    --option: bool,
    --list: bool
] {
    let data = {
        enum    : "Result",
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        expected: (expected-result (
            if $option { "Result hush" } else { "Result to-list" }
        ))
    }

    if $option {
        common nat $res $data --option
    } else if $list {
        common nat $res $data --list
    } else {
        common panic "no flags passed to `Result nat`"
    }
}

export def bind [fn: closure, res: any] {
    let data = {
        enum    : "Result",
        pure    : {|x| new $x --ok },
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        expected: (expected-result "Result bind")
    }

    common bind $res $fn $data
}

export def join [opt: any] {
    let data = {
        impure  : {|x| new $x },
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        expected: (expected-result "Result flatten"),
    }

    common join $opt $data
}

export def unwrap [res: any, --or: any] {
    let data = {
        enum    : "Result",
        left    : "an `Err`",
        is_enum : {|x| is-result $x},
        is_right: {|x| is-ok $x  },
        expected: (expected-result (
            if ($or == null) { "Result unwrap" } else { "Result unwrap-or" }
        ))
    }

    common unwrap $res $data $or
}

export def show [res: any] {
    let data = {
        is_enum : {|x| is-result $x },
        is_right: {|x| is-ok $x },
        on_right: {|x| $"Result::Ok\(($x.data))" },
        on_left : {|x| $"Result::Err\(($x.data))" },
        expected: (expected-result "Result show")
    }

    $res | common branch $data
}

def expected-result [
    fn: string          # The name of the function
] {
    [
        $"`($fn)` expects an `Result` input"
        "To lift an input into an `Result`, consider using"
        "`Result ok`, `Result err`, `Result lift`, or `Result lift-err"
    ] | str join "\n"
}
