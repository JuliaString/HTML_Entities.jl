"""
# Public API (nothing is exported)

* lookupname(str)
* matches(str)
* longestmatches(str)
* completions(str)
"""
module HTML_Entities
using StrTables

const VER = UInt32(1)

struct HTML_Table{T,O} <: AbstractEntityTable
    ver::UInt32
    tim::String
    inf::String
    base32::UInt32
    base2c::UInt32
    nam::PackedTable{T,UInt8,O}
    ind::Vector{UInt16}
    val16::Vector{UInt16}
    ind16::Vector{UInt16}
    val32::Vector{UInt16}
    ind32::Vector{UInt16}
    val2c::Vector{UInt32}
    ind2c::Vector{UInt16}
end

const DATA_PATH = joinpath(@__DIR__, "..", "data", "html.dat")
include_dependency(DATA_PATH)

# The table is loaded at precompile time and stored in the package image,
# so no file I/O is needed at runtime (and it works with `juliac --trim`)
const default = HTML_Table(StrTables.load(DATA_PATH)...)

end # module HTML_Entities
