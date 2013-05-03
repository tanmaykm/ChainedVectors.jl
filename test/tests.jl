using ChainedVectors

function test_chained_vector()
    v1 = [1, 2, 3]
    v2 = [4, 5, 6]
    cv = ChainedVector{Int}(v1, v2)
    for i in 1:6
        @assert i == cv[i]
        cv[i] += 10
        @assert (10+i) == cv[i]
    end

    v1 = b"Hello World "
    v2 = b"Goodbye World "
    cv = ChainedVector{Uint8}(v1, v2)
    @assert 7 == search(cv, 'W')
    @assert 21 == search(cv, 'W', 8)
    @assert 0 == search(cv, 'W', 22)
    @assert false == try; search(cv, 'W', 0); end
    @assert false == try; search(cv, 'W', 100); end

    @assert true == beginswith(cv, b"Hello")
    @assert false == beginswith(cv, b"ello")
    @assert true == beginswithat(cv, 7, b"World")
    @assert true == beginswithat(cv, 21, b"World")
    @assert false == beginswithat(cv, 22, b"World")
    @assert false == beginswithat(cv, 20, b"World")
    @assert true == beginswithat(cv, 13, b"Goodbye")
    @assert true == beginswithat(cv, 7, b"World Goodbye")
    @assert false == beginswithat(cv, 7, b"WorldGoodbye")

    x = shift!(cv)
    push!(cv, x)
    x = pop!(cv)
    unshift!(cv, x)
    @assert 26 == length(cv)

    empty!(cv)
    @assert 0 == length(cv)
end

function test_sub_vector()
    v1 = [1, 2, 3, 4, 5, 6]
    sv = SubVector(v1, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
        sv[i-1] += 10
        @assert (10+i) == sv[i-1]
    end

    v2 = b"Hello World"
    sv = SubVector(v2, 1:5)
    @assert "Hello" == bytestring(sv)
end

function test_chained_vector_sub()
    v1 = [1, 2, 3, 4, 5, 6]
    v2 = [7, 8, 9, 10, 11, 12]
    cv = ChainedVector{Int}(v1, v2)

    sv = sub(cv, 3:10)
    for i in 3:10
        @assert i == sv[i-2]
        sv[i-2] += 10
        @assert (i+10) == sv[i-2]
        sv[i-2] -= 10
    end

    sv = sub(cv, 8:11)
    for i in 8:11
        @assert i == sv[i-7]
        sv[i-7] += 10
        @assert (i+10) == sv[i-7]
        sv[i-7] -= 10
    end

    sv = sub(cv, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
        sv[i-1] += 10
        @assert (i+10) == sv[i-1]
        sv[i-1] -= 10
    end
end

function test_fast_sub_vec()
    v1 = [1, 2, 3, 4, 5, 6]
    sv = fast_sub_vec(v1, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
        sv[i-1] += 10
        @assert (i+10) == sv[i-1]
        sv[i-1] -= 10
    end
end


test_chained_vector()
test_sub_vector()
test_chained_vector_sub()
test_fast_sub_vec()

