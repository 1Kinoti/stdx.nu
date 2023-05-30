# | impl `Option`

use ./common.nu

export def help [] {
    "Option a"
}

export def is-option [it: any] {
    match $it {
        { type: "Option", some: true,  data: $__ } => true,
        { type: "Option", some: false, data: $__ } => true,
                                               _   => false
    }
}

export def new [it?: any] {
    if ($it == null) {
        { type: "Option", some: false, data: null }
    } else {
        { type: "Option", some: true,  data: $it  }
    }
}

export def is-some [opt: any] {
    if (is-option $opt) {
        $opt.some == true
    } else {
        error make -u {
            msg: (expected-option "Option is-some")
        }
    }
}

export def is-none [opt: any] {
    if (is-option $opt) {
        $opt.some == false
    } else {
        error make -u {
            msg: (expected-option "Option is-none")
        }
    }
}

export def is-some-and [opt: any, fn: closure] { 
    let data = {
        name    : "Option is-some-and",
        is_enum : {|x| is-option $x},
        is_right: {|x| is-some $x  },
        expected: (expected-option "Option is-some-and")
    }

    common is-right-and $opt $fn $data
}

export def fmap [fn: closure, opt: any] {
    let data = {
        pure    : {|x| new $x }
        enum    : "Option",
        is_enum : {|x| is-option $x },
        is_right: {|x| is-some $x },
        expected: (expected-option "Option map"),
    }

    common fmap $opt $fn $data
}

export def apply [
    oa:  any,
    ob: record<type: string, some: bool, data: any>,
] {
    if not (is-option $ob) { error make -u (expected-option "Option apply")}

    let data = {
        enum    : "Option",
        pure    : {|x| new $x },
        right   : "some",
        is_enum : {|x| is-option $x},
        is_right: {|x| is-some $x },
        expected: (expected-option "Option apply")
    }

    common apply $oa $ob $data
}

export def lift-a2 [
    fn: closure,
    oa: any,
    ob: record<type: string, some: bool, data: any>,
] {
    if not (is-option $ob) { error make -u (expected-option "Option lift-a2")}

    let data = {
        enum    : "Option",
        pure    : {|x| new $x },
        right   : "some",
        is_enum : {|x| is-option $x },
        is_right: {|x| is-some $x },
        expected: (expected-option "Option lift-a2")
    }

    common lift-a2 $oa $ob $fn $data
}

export def nat [
    opt: any,
    --result: string,
    --list: bool
] {
    let data = {
        enum    : "Option",
        is_enum : {|x| is-option $x },
        is_right: {|x| is-some $x },
        expected: (expected-option (
            if $result != null { "Option note" } else { "Option to-list" }
        ))
    }

    if $result != null {
        common nat $opt $data --result $result
    } else if $list {
        common nat $opt $data --list
    } else {
       common panic "no flags passed to `Option nat`"
    }
}

export def bind [fn: closure, opt: any] {
    let data = {
        enum    : "Option",
        pure    : {|x| new $x },
        is_enum : {|x| is-option $x },
        is_right: {|x| is-some $x },
        expected: (expected-option "Option bind"),
    }

    common bind $opt $fn $data
}

export def join [opt: any] {
    let data = {
        impure  : {|x| new $x },
        is_enum : {|x| is-option $x },
        is_right: {|x| is-some $x },
        expected: (expected-option "Option flatten"),
    }

    common join $opt $data
}

export def unwrap [opt: any, --or: any] {
    let data = {
        enum    : "Option",
        left    : "a `None`",
        is_enum : {|x| is-option $x},
        is_right: {|x| is-some $x  },
        expected: (expected-option (
            if ($or == null) { "Option unwrap" } else { "Option unwrap-or" }
        ))
    }

    common unwrap $opt $data $or 
}

export def show [opt: any] {
    let data = {
        is_enum : {|x| is-option $x },
        is_right: {|x| is-some $x },
        on_right: {|x| $"Option::Some\(($x.data))" },
        on_left : {|_x| "Option::None" },
        expected: (expected-option "Option show")
    }

    $opt | common branch $data
}

def expected-option [
    fn: string          # The name of the function
    # this: string,
    # that: string
] {
    [
        $"`($fn)` expects an `Option` input\n"
        "\tTo lift an input into an `Option`, consider using"
        "\t`Option new` or `Option lift`\n"
        # $"info: expected `Option<($this)>`, got `($that)`"
    ] | str join "\n"
}
