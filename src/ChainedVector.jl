
type ChainedVector{T} <: AbstractVector{T}
    chain::Vector{Vector{T}}
    sizes::Vector{Int}
    sz::Int
    
    function ChainedVector(arr::Vector{T}...)
        sizes = [ length(v) for v in arr ]
        new([v for v in arr], sizes, sum(sizes))
    end
end

show(io::IO, cv::ChainedVector) = println(io, "ChainedVector of size $(cv.sz)")
function print_matrix(io::IO, cv::ChainedVector) 
    if(0 == cv.sz) 
        println(io, "empty")
    else
        elems = cv[1:min(5, cv.sz)]
        print(io, "[")
        for elem in elems; print(io, elem, ", "); end
        (length(elems) < cv.sz) && print(io, "...")
        println(io, "]")
    end
end

length(cv::ChainedVector) = cv.sz
size(cv::ChainedVector) = (cv.sz,)
strides(cv::ChainedVector) = (1,)
stride(cv::ChainedVector, n::Integer) = (n > 1) ? cv.sz : 1

function similar{T}(cv::ChainedVector{T}, tv::Type, dims::(Int, Int)) 
    @assert dims[2] == 1
    ChainedVector{tv}(Array(tv, dims[1]))
end

vec{T}(cv::ChainedVector{T}) = copy!(Array(T, cv.sz), cv)

macro _get_vec_pos(cv, ind)
    quote
        cidx = 1
        while($(ind) > $(cv).sizes[cidx]); $(ind) -= $(cv).sizes[cidx]; cidx += 1; end
        cidx
    end
end

function getindex(cv::ChainedVector, ind::Integer)
    cidx = @_get_vec_pos cv ind
    (cv.chain[cidx])[ind]
end

function setindex!{T}(cv::ChainedVector{T}, x::T, ind::Integer)
    cidx = @_get_vec_pos cv ind
    (cv.chain[cidx])[ind] = x
end

function push!{T}(cv::ChainedVector{T}, v::Vector{T})
    push!(cv.chain, v)
    l = length(v)
    push!(cv.sizes, l)
    cv.sz += l
    cv
end

function pop!(cv::ChainedVector)
    (cv.sz == 0) && error("array is empty")
    cv.sz -= pop!(cv.sizes)
    pop!(cv.chain)
end

function shift!(cv::ChainedVector)
    (cv.sz == 0) && error("array is empty")
    cv.sz -= shift!(cv.sizes)
    shift!(cv.chain)
end

function unshift!{T}(cv::ChainedVector{T}, v::Vector{T})
    unshift!(cv.chain, v)
    l = length(v)
    unshift!(cv.sizes, l)
    cv.sz += l
    cv
end

function empty!(cv::ChainedVector)
    if(cv.sz > 0)
        cv.sz = 0
        empty!(cv.sizes)
        empty!(cv.chain)
    end
end

function sub(cv::ChainedVector, r::Range1{Int})
    # if the range does not straddle a chain element boundary, return a fast vector
    start_pos = r.start
    cidx = @_get_vec_pos cv start_pos
    if(length(r) <= (cv.sizes[cidx]-start_pos+1))
        return fast_sub_vec(cv.chain[cidx], start_pos:(start_pos+length(r)-1))
    end
    # else return a safe sub vector
    return SubVector(cv, r)
end

function search(cv::ChainedVector{Uint8}, b, i::Integer)
    if i < 1 error(BoundsError) end
    n = length(cv)
    if i > n return i == n+1 ? 0 : error(BoundsError) end

    begin_pos = 1
    for a in cv.chain
        len = length(a)
        if((begin_pos + len - 1) >= i)
            p = pointer(a)
            offset = (begin_pos >= i) ? 0 : (i - begin_pos)
            q = ccall(:memchr, Ptr{Uint8}, (Ptr{Uint8}, Int32, Uint), p+offset, b, len-offset)
            (C_NULL != q) && (return int(q-p+begin_pos))
        end
        begin_pos += len
    end
    return 0
end

search(cv::ChainedVector{Uint8}, b) = search(cv,b,1)

function beginswithat(cv::ChainedVector{Uint8}, pos::Int, b::Array{Uint8,1}) 
    lb = length(b) 
    (int(length(cv)) < int(pos+lb-1)) && return 0

    # get the vector that contains pos
    cidx = @_get_vec_pos cv pos
    # if b can be contained fully, return strcmp
    ls1 = cv.sizes[cidx] - pos + 1
    if(ls1 >= lb) 
        return (ccall(:strncmp, Int32, (Ptr{Uint8}, Ptr{Uint8}, Uint), pointer(cv.chain[cidx])+pos-1, b, lb) == 0)
    end
    # else return && of two strcmps
    return (ccall(:strncmp, Int32, (Ptr{Uint8}, Ptr{Uint8}, Uint), pointer(cv.chain[cidx])+pos-1, b, ls1) == 0) &&
           (ccall(:strncmp, Int32, (Ptr{Uint8}, Ptr{Uint8}, Uint), pointer(cv.chain[cidx+1]), pointer(b)+ls1, lb-ls1) == 0) 
end
beginswith(cv::ChainedVector{Uint8}, b::Array{Uint8,1}) = beginswithat(cv, 1, b)

