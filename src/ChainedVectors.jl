module ChainedVectors

import  Base.show, Base.print_matrix,
        Base.length, Base.size, Base.strides, Base.stride,
        Base.similar, Base.vec, Base.bytestring,
        Base.getindex, Base.setindex!,
        Base.push!, Base.pop!, Base.shift!, Base.unshift!, Base.empty!,
        Base.search, Base.beginswith,
        Base.sub

export  ChainedVector, SubVector,
        show, print_matrix,
        length, size, strides, stride,
        similar, vec, bytestring,
        getindex, setindex!,
        push!, pop!, shift!, unshift!, empty!,
        search, beginswith, beginswithat,
        fast_sub_vec, sub

include("ChainedVector.jl")
include("SubVector.jl")
include("FastSubVector.jl")
end
