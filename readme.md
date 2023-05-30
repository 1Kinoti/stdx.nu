# stdx.nu

`stdx` provides additional types and commands to nushell `core` and `std`

## installation

### using `git`

```sh
> git clone https://github.com/1Kinoti/stdx.nu stdx.nu
> cd stdx.nu
> cp stdx <your desired location>

# to make it globally available, and this to your `config.nu`
use /path/to/stdx

# to make it usable without the `stdx` prefix
use /path/to/stdx *

# to use it in a script/project/library
use /path/to/stdx
```

## features

### Option

`stdx` provides an `Option` type (also called `Maybe`) and a number
of methods associated with it like, `map`, `is-some`, `bind` among others

to use the `Option` type
```nu
> use /path/to/stdx *
> Option help
```

> read more about the `Option` type [here][001] and/or [here][002]

### Result

`stdx` provides an `Result` type and a number of methods associated
with it like, `map`, `is-ok`, `bind` among others

> read more about the `Result` type [here][003], [here][004] 
> [here][005] and/or [here][006]

to use the `Result` type
```nu
> use /path/to/stdx *
> Result help
```

### List

`stdx` extends all the available `list` methods with the `List` type
that provides additional commands like `List foldr`, `List scanl` etc
and makes some `core` list function safer by making them return an `Option`
instead of an error if they fail, for example

```
> [] | first       # errors
> [] | List head   # returns an `Option None`
```

## contributing

contributions are welcome!

### running tests

```
use stdx/test; test
```

[001]: https://doc.rust-lang.org/std/option/index.html "option.rs"
[002]: https://hackage.haskell.org/package/base-4.18.0.0/docs/Data-Maybe.html "maybe.hs"
[003]: https://doc.rust-lang.org/std/result/index.html "result.rs"
[004]: https://hackage.haskell.org/package/base-4.18.0.0/docs/Data-Either.html "either.hs"
[005]: https://hackage.haskell.org/package/validation "validation.hs"
[006]: https://docs.rs/itertools/latest/itertools/enum.Either.html "either.rs"
