# | Basic syntax highlighting using `ansi color codes`
#
# An example of how you would syntax highligh the foolowing
# line
#
# let-env FOO = 'bar'
#
# ```
# use syn
#
# $"
# (syn kw 'let-env') FOO (syn opr '=') (syn lit `'bar'`)
# "
# ```

alias res = ansi reset

# highlight a keyword
export def kw [wd: string] {
   $"(ansi lr)($wd)(res)"
}

# highlight a command head
export def cmd [wd: string] {
   $"(ansi lg)($wd)(res)"
}

# highlight a sub-command
export def sub [wd: string] {
   $"(ansi lyi)($wd)(res)"
}

# a `h2` title
export def title-2 [wd: string] {
    $"(ansi defi)($wd)(res)"
}

# a `h1` title
export def title [wd: string] {
    $"(ansi defb)($wd)(res)"
}

# highlight a comment
export def cmt [wd: string] {
    $"(ansi dgr)($wd)(res)"
}

# highlight a variable and its cellpath. to use this,
# you just have to write the var without the `$`. for
# example, to highlight `$nu.home-path`
# ```
#  use syn
#
#  $"(syn 'nu.home-path')"
# ```
export def var [wd: string] {
    $'(ansi lu)$(res)' + $wd | split row '.' | str join $"(ansi lu)('.')(res)"
}

# print a highlighted comma
export def comma [] {
    $"(ansi darkorange3a)(',')(res)"
}

# print a highlighted colon
export def colon [] {
    $"(ansi darkorange3a)(':')(res)"
}

# highlight a literal, to highlight a string, i would recommend
# using the backticks, two wrap the actual string and its quotes
# if any, because sinec you will be using this in a string
# interpolation, the oother quotes might cause trouble
export def lit [wd: string] {
    $"(ansi m)($wd)(res)"
}

# print a highlighted pipe
export def pipe [] {
    $"(ansi lub)('|')(res)"
}

# highlight am operator
export def opr [wd: string] {
    $"(ansi lu)($wd)(res)"
}

# highlight a delimiter
export def del [wd: string] {
    $"(ansi r)($wd)(res)"
} 

# wrap an expression in parenthesis
# @deprecated use `syn del` manually
export def wrap-in-parens [wd: string] {
    $"(del "(")($wd)(del ")")"
}
