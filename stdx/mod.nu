#  | `stdx` is an extension library for `nu core` and `nu std` which 
#  provides safe wrappers over the commands offered by these libraries.

use src/ *

export use List

export def List [] {
    List help
}

export use Option

export def Option [] {
    Option help
}

export use Result

export def Result [] {
    Result help
}
