
#const _fastsv_gc_protect = WeakKeyDict{Vector, Vector}()
const _fastsv_gc_protect = Dict{Uint, Vector}()

function fast_sub_vec(arr::Vector, r::Range1{Int}) 
    if((r.start > 0) && (r.start+length(r)-1 <= length(arr)))
        p = pointer(arr, r.start)
        newv = pointer_to_array(p, length(r), false)
        #_fastsv_gc_protect[newv] = arr
        _fastsv_gc_protect[object_id(newv)] = arr
        finalizer(newv, x->delete!(_fastsv_gc_protect, object_id(x)))
        return newv
    end
    throw(BoundsError())
end

