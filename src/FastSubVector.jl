
const _fastsv_gc_protect = WeakKeyDict{Vector, Vector}()

function fast_sub_vec(arr::Vector, r::Range1{Int}) 
    if((r.start > 0) && (r.start+r.len-1 <= length(arr)))
        p = pointer(arr, r.start)
        newv = pointer_to_array(p, r.len, false)
        _fastsv_gc_protect[newv] = arr
        return newv
    end
    throw(BoundsError())
end

