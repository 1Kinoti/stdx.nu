# | "nu does not have generics" get a load of this guy

export def unwrap [
    opt: any,
    info: record<
        enum: string,
        left: string,
        is_enum : closure,
        is_right: closure,
        expected: string,
    >,
    or: any,
] {
    let data = {
        is_enum : {|x| do $info.is_enum  $x },
        is_right: {|x| do $info.is_right $x },
        on_right: {|x|
            $x.data
        },
        on_left : {|x|
            let name = (
                if ($or == null) {
                    $"($info.enum) unwrap"
                } else {
                    $"($info.enum) unwrap-or"
                }
            )

            if ($or == null) {
                error make -u {
                    msg: $"Called `($name)` on ($info.left) value"
                }
            } else {
                $or
            }
        },
        expected: $info.expected 
    }

    $opt | branch $data
}

export def is-predicate [fn: string, a: any] {
    let x = (
        try {
            ((do $in $a) | describe) == "bool"
        } catch {
            false
        }
    )

    if not $x {
        let typ = ($a | describe)
        error make -u {
            msg: (
                [
                    $"`($fn)` expects a closure with this signature"
                    "\n\tclosure(a) -> bool"
                    "\twhere:"
                    $"\t       a: ($typ)"
                ] | str join "\n"
            )
        } 
    }
}

export def join [
    opt: any,
    data: record<
        impure  : closure,
        is_enum : closure,
        is_right: closure,
        expected: string,
    >
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|x|
            if (do $data.is_enum $x.data) {
                $x.data
            } else {
                do $data.impure $x
            }
        },
        on_left : {|x| $x },
        expected: $data.expected,
    }

   $opt | branch $data
}

# internal error
export def panic [msg?: string] {
    error make -u {
        msg: $":internal-error: ($msg)"
    }
}

export def nat [
    it: any,
    data: record<
        enum: string
        is_enum: closure,
        is_right: closure,
        expected: string,
    >,
    --option: bool,
    --result: string,
    --list: bool,
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|it|
            if $option {
                { type: 'Option', some: true,  data: $it.data }
            } else if $list {
                [$it.data]
            } else if $result != null {
                { type: 'Result', ok: true, data: $it.data }
            } else {
                panic "no flags passed to `($data.enum) nat`"
            } 
        },
        on_left : {|_it|
            if $option {
                { type: 'Option', some: false,  data: null }
            } else if $list {
                []
            } else if $result != null {
                { type: 'Result', ok: false, data: $result }
            } else {
                panic "no flags passed to `($data.enum) nat`"
            } 
        },
        expected: $data.expected,
    }

    $it | branch $data
}

export def lift-a2 [
    a: any,
    b: record,
    fn: closure,
    data: record<
        enum: string,
        pure: closure,
        right: string,
        is_enum: closure,
        is_right: closure,
        expected: string,
    > 
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|x|
            if (do $data.is_right $b) {
                $fn | is-binary-func $"($data.enum) lift-a2" $x.data $b.data 

                let z = (do $data.pure {|y| do $fn $y $b.data }) 
                
                let data = { 
                    enum : $data.enum,
                    pure : {|x| do $data.pure $x },
                    right: $data.right, 
                    is_enum: {|x| do $data.is_enum $x },
                    is_right: {|x| do $data.is_right $x },
                    expected: $data.expected,
                }

                apply $z $x $data
            } else {
                $b
            }
        },
        on_left : {|x| $x },
        expected: $data.expected,
    }

    $a | branch $data
}

export def apply [
    a: any,
    b: record,
    data: record<
        enum : string,
        pure : closure,
        right: string, 
        is_enum: closure,
        is_right: closure,
        expected: string,
    >
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|x|
            if (($x.data | describe) == "closure") {
                try {
                    do $data.pure (do $x.data $b.data)
                } catch {
                    error make -u {
                        msg: (
                            [
                                $"`($data.enum) apply` expects a nested closure with "
                                "this signature:"
                                $"\n\tclosure\(($b.data | describe)) -> T"
                            ] | str join "\n"
                        )
                    }
                }
            } else {
                error make -u {
                    msg: (
                        [
                            $"`($data.enum) apply` expects an input `($data.enum)` with"
                            "this signature:"
                            $"\n\trecord<($data.right): bool, data: closure>"
                        ] | str join "\n"
                    )
                }
            }
        },
        on_left : {|x| $x },
        expected: $data.expected,
    }

    $a | branch $data
}

export def bind [
    it: any,
    fn: closure,
    data: record<
        enum: string,
        pure: closure,
        is_enum: closure,
        is_right: closure,
        expected: string,
    >
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|x|
            let res = (do $fn $x.data)
            if (do $data.is_enum $res) {
                $res
            } else {
                error make {
                    msg: (
                        [
                            $"`($data.enum) bind` expects a closure with this signature"
                            $"\n\tclosure($x.data | describe) -> ($data.enum)<T>"
                        ] | str join "\n"
                    )
                }
            }
        },
        on_left : {|x| $x },
        expected: $data.expected,
    }

    $it | branch $data
}

export def fmap [
    it: any,
    fn: closure,
    data: record<
        pure: closure,
        enum: string,
        is_enum: closure,
        is_right: closure,
        expected: string,
    >
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|x|
            try {
                let x = (do $fn $x.data)
                do $data.pure $x 
            } catch {
                error make -u {
                    msg: (
                        [
                            $"`($data.enum) map` expects a closure with this signature"
                            "\n\tclosure(a) -> b"
                            "\twhere:"
                            $"\t       a: ($x.data | describe)"
                        ] | str join "\n"
                    ) 
                }
            }
        },
        on_left : {|x| $x },
        expected: $data.expected,
    }

    $it | branch $data
}

export def is-right-and [
    it: any,
    fn: closure,
    data: record<
        name: string,
        is_enum : closure,
        is_right: closure,
        expected: string,
    >
] {
    let data = {
        is_enum : {|x| do $data.is_enum $x },
        is_right: {|x| do $data.is_right $x },
        on_right: {|x|
            $fn | is-predicate $data.name $x.data

            do $fn $x.data
        },
        on_left : {|_x| false },
        expected: $data.expected,
    }

    $it | branch $data
}

export def branch [
    data: record<
        is_enum : closure,
        is_right: closure,
        on_right: closure,
        on_left : closure,
        expected: string,
    >
] {
    if (do $data.is_enum $in) {
        if (do $data.is_right $in) {
            do $data.on_right $in
        } else {
            do $data.on_left $in
        }
    } else {
        error make -u {
            msg: $data.expected,
        }
    }

}

# semi works, but good enough
def is-binary-func [
    fn: string, 
    a: any,
    b: any,
] {
    try {
       do $in $a $b
    } catch {
        let a = ($a | describe)
        let b = ($b | describe)
        error make -u {
            msg: (
                [
                    $"`($fn)` expects a closure with this signature"
                    "\n\tclosure(a, b) -> c"
                    "\twhere:"
                    $"\t       a: ($a)"
                    $"\t       b: ($b)"
                ] | str join "\n"
            )
        }
    }
}
