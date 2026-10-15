# HTML_Entities.jl

[![CI](https://github.com/JuliaString/HTML_Entities.jl/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/JuliaString/HTML_Entities.jl/actions/workflows/ci.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/JuliaString/HTML_Entities.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaString/HTML_Entities.jl)
[![Release](https://img.shields.io/github/release/JuliaString/HTML_Entities.jl.svg)](https://github.com/JuliaString/HTML_Entities.jl/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE.md)

Support for using HTML entity names for characters.

This package provides a table of the 2125 named character references defined by HTML, with
fast lookups in both directions:

* from an entity name to the Unicode character(s) it represents,
* from a character, or a pair of characters, to all of the entity names for it,
* from a prefix to all of the entity names that start with it (for completions).

## Installation

Requires Julia 1.10 or later.

```julia
using Pkg
Pkg.add("HTML_Entities")
```

## Usage

Nothing is exported. The lookup functions come from
[StrTables.jl](https://github.com/JuliaString/StrTables.jl) and take the table
`HTML_Entities.default` as their first argument.

```julia
using HTML_Entities, StrTables

const tab = HTML_Entities.default

lookupname(tab, "nle")             # "≰"
lookupname(tab, "lvnE")            # "≨︀"  (two characters: U+2268 U+FE00)
lookupname(tab, "foobar")          # ""    (unknown name)

matchchar(tab, 'α')                # ["alpha"]
matches(tab, "≨︀")       # ["lvertneqq", "lvnE"]
longestmatches(tab, "≰ abcd")      # ["NotLessEqual", "nle", "nleq"]
completions(tab, "um")             # ["umacr", "uml"]
```

| Function | Description |
|:---------|:------------|
| `lookupname(tab, name)` | The string for an entity name, or `""` if not found |
| `matchchar(tab, ch)` | All entity names for a single character |
| `matches(tab, str)` | All entity names that exactly match a string of one or two characters |
| `longestmatches(tab, str)` | All entity names for the longest match at the start of `str` |
| `completions(tab, prefix)` | All entity names that start with `prefix` |

`HTML_Entities.default` is also an `AbstractVector{String}` of all entity names, in sorted order.

## Static compilation

The table is loaded from `data/html.dat` at precompile time and stored in the package image.
Nothing is read from disk at runtime, and the table has a concrete type, so the package can be
used in executables built with [JuliaC.jl](https://github.com/JuliaLang/JuliaC.jl) and `--trim=safe`.

## Regenerating the data

The entity definitions are in [`deps/htmlnames.jl`](deps/htmlnames.jl). To rebuild the table,
delete `data/html.dat` and run:

```sh
julia --project=. -e 'using Pkg; Pkg.instantiate(); include("deps/build.jl")'
```
