# | Extracting examples from docs

use ../../src/Util/list.nu partition

export def extract [str: string] {
    let lists = (
        $str
        | ansi strip
        | lines
        | each {|l| $l | str trim }
        | filter {|x| $x starts-with '>' } 
        | partition {|l| $l starts-with '>.'} $in
    )

    let multi = (
        $lists.0 | each {|l| $l | str substring 2.. | str trim } | str join ' '
    )

    let single = (
        $lists.1 | each {|l| $l | str substring 1.. | str trim } | str join '; '
    )

    if ($multi | is-empty ) {
        $single
    } else {
        $multi + '; ' + $single
    }
}
