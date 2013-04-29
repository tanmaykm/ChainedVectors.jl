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
    push!(cv, x)
    @assert 26 == length(cv)
end

function test_sub_vector()
    v1 = [1, 2, 3, 4, 5, 6]
    sv = SubVector(v1, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
    end

    v1 = [1, 2, 3]
    v2 = [4, 5, 6]
    cv = ChainedVector{Int}(v1, v2)
    sv = SubVector(cv, 2:5)
    for i in 2:5
        @assert i == sv[i-1]
    end
end

function time_vect()
    v = zeros(Int, 1024*1024*64)
    vect_time = @elapsed begin
        x = 0
        i = 1
        while(i < length(v))
            x += v[i]
            i+=1
        end
        println(x)
    end
    println("Vector: $vect_time")
end

function time_cv()
    cv = ChainedVector{Int}(zeros(Int, 1024*1024*32), zeros(Int, 1024*1024*32))
    cv_time = @elapsed begin
        i = 1
        x = 0
        l = length(cv)
        while(i < l)
            x += cv[i]
            i+=1
        end
        println(x)
    end

    println("ChainedVector: $cv_time")
end

function time_subarr()
    v = zeros(Int, 1024*1024*64)
    sa = sub(v, 2:length(v)-1)
    sa_time = @elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        println(x)
    end
    println("SubArray: $sa_time")
end

function time_subvect()
    v = zeros(Int, 1024*1024*64)
    sa = SubVector(v, 2:length(v)-1)
    sv_time = @elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        println(x)
    end
    println("SubVector: $sv_time")
end

function time_subvect_of_chainedvect()
    cv = ChainedVector{Int}(zeros(Int, 1024*1024*32), zeros(Int, 1024*1024*32))
    sa = SubVector(cv, 2:length(cv)-1)
    sv_time = @elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        println(x)
    end
    println("SubVector of ChainedVector: $sv_time")
end

test_chained_vector()
test_sub_vector()
time_subvect_of_chainedvect()
time_vect()
time_cv()
time_subvect()
time_subarr()


