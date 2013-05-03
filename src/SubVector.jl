
immutable SubVector{S<:AbstractVector, T} <: AbstractVector{T}
    full::S
    start::Int
    len::Int

    function SubVector(arr::AbstractVector{T}, r::Range1{Int})
        if((r.start > 0) && (r.start+r.len-1 <= length(arr)))
            return new(arr, r.start, r.len)
        end
        throw(BoundsError())
    end
end
SubVector{T}(a::AbstractVector{T}, r::Range1{Int}) = SubVector{typeof(a), T}(a,r)

show(io::IO, sv::SubVector) = println(io, "SubVector of size $(sv.len)")
function print_matrix(io::IO, sv::SubVector) 
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

length(sv::SubVector) = sv.len
size(sv::SubVector) = (sv.len,)
strides(::SubVector) = (1,)
stride(sv::SubVector, n::Integer) = (n > 1) ? sv.len : 1

function similar{T}(sv::SubVector{T}, tv::Type, dims::(Int, Int)) 
    @assert dims[2] == 1
    SubVector(Array(tv, dims[1]), 1:dims[1])
end

vec{S,T}(sv::SubVector{S,T}) = copy!(Array(T, sv.len), sv)

getindex(sv::SubVector, ind::Integer) = (0 < ind <= sv.len) ? sv.full[ind+sv.start-1] : throw(BoundsError())
setindex!{T}(sv::SubVector, x::T, ind::Integer) = (0 < ind <= sv.len) ? (sv.full[ind+sv.start-1] = x) : throw(BoundsError())
bytestring(sv::SubVector) = bytestring(vec(sv))

