using VectorUtils

function test_chained_vector()
    v1 = [1, 2, 3]
    v2 = [4, 5, 6]
    cv = ChainedVector{Int}(v1, v2)
    for i in 1:6
        @assert i == cv[i]
    end

    v1 = convert(Vector{Uint8}, "Hello World ")
    v2 = convert(Vector{Uint8}, "Goodbye World ")
    cv = ChainedVector{Uint8}(v1, v2)
    @assert 7 == search(cv, 'W')
    @assert 21 == search(cv, 'W', 8)
    @assert 0 == search(cv, 'W', 22)
    @assert true == beginswith(cv, convert(Vector{Uint8}, "Hello"))
    @assert false == beginswith(cv, convert(Vector{Uint8}, "ello"))
    @assert true == beginswithat(cv, 7, convert(Vector{Uint8}, "World"))
    @assert true == beginswithat(cv, 21, convert(Vector{Uint8}, "World"))
    @assert false == beginswithat(cv, 22, convert(Vector{Uint8}, "World"))
    @assert false == beginswithat(cv, 20, convert(Vector{Uint8}, "World"))
    @assert true == beginswithat(cv, 13, convert(Vector{Uint8}, "Goodbye"))
    @assert true == beginswithat(cv, 7, convert(Vector{Uint8}, "World Goodbye"))
    @assert false == beginswithat(cv, 7, convert(Vector{Uint8}, "WorldGoodbye"))

    x = shift!(cv)
    push!(cv, x)
    x = pop!(cv)
    unshift!(cv, x)
    @assert 26 == length(cv)
end

function test_sub_vector()
    v1 = [1, 2, 3, 4, 5, 6]
    sv = SubVector(v1, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
    end
end

function test_chained_vector_sub()
    v1 = [1, 2, 3, 4, 5, 6]
    v2 = [7, 8, 9, 10, 11, 12]
    cv = ChainedVector{Int}(v1, v2)

    sv = sub(cv, 3:10)
    for i in 3:10
        @assert i == sv[i-2]
    end

    sv = sub(cv, 8:11)
    for i in 8:11
        @assert i == sv[i-7]
    end

    sv = sub(cv, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
    end
end

function test_fast_sub_vec()
    v1 = [1, 2, 3, 4, 5, 6]
    sv = fast_sub_vec(v1, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
    end
end


test_chained_vector()
test_sub_vector()
test_chained_vector_sub()
test_fast_sub_vec()

