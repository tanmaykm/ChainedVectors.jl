using ChainedVectors

const ARRAY_SZ = isempty(ARGS) ? (32*1024*1024) : int(ARGS[1])

macro nogc_elapsed(ex)
    quote
        gc_disable()
        local t0 = time_ns()
        local val = $(esc(ex))
        local ret = (time_ns()-t0)/1e9
        gc_enable(); gc()
        ret
    end
end

function time_vect()
    v = zeros(Int, ARRAY_SZ)
    vect_time = @nogc_elapsed begin
        x = 0
        i = 1
        while(i < length(v))
            x += v[i]
            i+=1
        end
        #println(x)
    end
    println("Vector: $vect_time")
end

function time_cv()
    cv = ChainedVector{Int}(zeros(Int, int(ARRAY_SZ/2)), zeros(Int, int(ARRAY_SZ/2)))
    cv_time = @nogc_elapsed begin
        i = 1
        x = 0
        l = length(cv)
        while(i < l)
            x += cv[i]
            i+=1
        end
        #println(x)
    end

    println("ChainedVector: $cv_time")
end

function time_subarr()
    v = zeros(Int, ARRAY_SZ)
    sa = sub(v, 2:length(v)-1)
    sa_time = @nogc_elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        #println(x)
    end
    println("SubArray: $sa_time")
end

function time_subvect()
    v = zeros(Int, ARRAY_SZ)
    sa = SubVector(v, 2:length(v)-1)
    sv_time = @nogc_elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        #println(x)
    end
    println("SubVector: $sv_time")
end

function time_fast_sub_vec()
    v = zeros(Int, ARRAY_SZ)
    sa = fast_sub_vec(v, 2:length(v)-1)
    sv_time = @nogc_elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        #println(x)
    end
    println("FastSubVector: $sv_time")
end

function time_subvect_of_chainedvect()
    cv = ChainedVector{Int}(zeros(Int, int(ARRAY_SZ/2)), zeros(Int, int(ARRAY_SZ/2)))
    sa = SubVector(cv, 2:length(cv)-1)
    sv_time = @nogc_elapsed begin
        i = 1
        x = 0
        l = length(sa)
        while(i < l)
            x += sa[i]
            i += 1
        end
        #println(x)
    end
    println("SubVector of ChainedVector: $sv_time")
end

println("Times for getindex across all elements of vectors of $ARRAY_SZ integers.")
println("Split into two $(int(ARRAY_SZ/2)) buffers for ChainedVectors.")
time_subvect_of_chainedvect()
time_vect()
time_cv()
time_subvect()
time_fast_sub_vec()
time_subarr()


