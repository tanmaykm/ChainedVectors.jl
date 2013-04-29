
function fast_sub_vec(arr::Vector, r::Range1{Int}) 
    @assert (r.start > 0) && (r.start+r.len-1 <= length(arr))
    p = pointer(arr, r.start)
    pointer_to_array(p, r.len, false)
end

