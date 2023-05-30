# | `Help` for `stdx`

# | Help for `Result`
export def result [
     fn?: string
    --long(-l): bool, 
] {
    use ./res.nu

    if $fn != null {
        match (normalize $fn) {
            "predicate" | "iserr" | "isok" | "isright" | "isleft" | "isokand" | "iserrand" => (res _pred)
            "nothing" | "some" | "just" | "none" | "new" | "lift" => (res _new)
            "map"  | "fmap" => (res _map)
            "apply" | "ap" | "<*>" => (res _apply)
            "bind" | "andthen" | ">>=" => (res _bind)
            "lifta2" | "lifta3" => (res _lift-a2)
            "ok" | "okor" | "tooption" | "tomaybe" | "tosome" | "tonone" | "hush" => (res _hush)
            "flatten" | "join" => (res _flatten)
            "unwrap" | "extract" | "get" | "take" |
                "unwrapor" | "unwraperr" | "unwraporelse" | "unwrapordefault" => (res _unwrap)
            _ => (res short)
        }
    } else if $long {
        res long 
    } else {
        res short
    }
}

# | Help for `Option`
export def option [
    fn?: string
    --long(-l): bool,
] {
    use ./opt.nu

    if $fn != null {
        match (normalize $fn) {
            "predicate" | "issome" | "isnone" | "isjust" | "isnothing" | "issomeand" => (opt _pred)
            "nothing" | "some" | "just" | "none" | "new" | "lift" => (opt _new)
            "map"  | "fmap" => (opt _map)
            "apply" | "ap" | "<*>" => (opt _apply)
            "bind" | "andthen" | ">>=" => (opt _bind)
            "lifta2" | "lifta3" => (opt _lift-a2)
            "ok" | "okor" | "note" => (opt _note)
            "flatten" | "join" => (opt _flatten)
            "unwrap" | "extract" | "get" | "take" |
                "unwrapor" | "unwraporelse" | "unwrapordefault" => (opt _unwrap)
            _ => (opt short)
        }
    } else if $long {
        opt long 
    } else {
        opt short
    }
}

export def list [
     fn?: string
    --long(-l): bool,
] {
    use ./lst.nu

    if $fn != null {
        match (normalize $fn) {
            "head" | "first" | "next" => (lst _head),
            "last" | "tail" => (lst _last)
            "init" => (lst _init)
            "intersperse" => (lst _intersperse)
            "foldr" | "foldright" | "rightfold" => (lst _foldr)
            "foldl" | "foldleft" | "leftfold" => (lst _foldl)
            "scanr" | "scanright" | "rightscan" => (lst _scanr)
            "scanl" | "scanleft" | "leftscan" => (lst _scanl)
            "find" | "search" => (lst _find)
            "partition" | "split" | "parts" => (lst _part)
            "findindex" | "findidx" => (lst _idx)
            "findindices" | "findids" => (lst _ids)
            "zipwith" => (lst _zwith)
            "and" | "conjuction" => (lst _and)
            "or" | "disjuction" => (lst _or)
            _ => (lst _list)
        }
    } else if $long {
        lst long 
    } else {
        lst short
    }
}

def normalize [str: string] {
    $str
    | str replace '-' '_'
    | str replace '_' ''
    | str downcase
}
