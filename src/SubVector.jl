
type SubVector{T} <: AbstractVector{T}
    full::Vector{T}
    start::Int
    len::Int

    function SubVector(arr::Vector{T}, r::Range1{Int})
        @assert (r.start > 0) && (r.len <= length(arr))
        new(arr, r.start, r.len)
    end
end

show{T}(io::IO, sv::SubVector{T}) = println(io, "SubVector of size $(sv.len)")
function print_matrix{T}(io::IO, sv::SubVector{T}) 
    if(0 == sv.len) 
        println(io, "empty")
    else
        elems = sv[sv.start:min(5, sv.len)]
        print(io, "[")
        for elem in elems; print(io, elem, ", "); end
        (length(elems) < sv.len) && print(io, "...")
        println(io, "]")
    end
end

size{T}(sv::SubVector{T}) = sv.len
strides{T}(::SubVector{T}) = (1,)

function stride{T}(::SubVector{T}, n::Integer) 
    @assert n == 1
    1
end

function similar{T}(sv::SubVector{T}, tv::Type, dims::(Int, Int)) 
    @assert dims[2] == 1
    SubVector{tv}(Array(tv, dims[1]), 1:dims[1])
end

vec{T}(sv::SubVector{T}) = copy!(Array(T, sv.sz), sv)

function getindex{T}(sv::SubVector{T}, ind::Integer)
    @assert (ind > 0) && (ind <= sv.len)
    sv.full[ind+sv.start-1]
end

function setindex!{T}(sv::SubVector{T}, x::T, ind::Integer)
    @assert (ind > 0) && (ind <= sv.len)
    sv.full[ind+sv.start-1] = x
end

