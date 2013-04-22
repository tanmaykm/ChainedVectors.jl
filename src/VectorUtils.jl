module VectorUtils

import  Base.show, Base.print_matrix,
        Base.size, Base.strides, Base.stride,
        Base.similar,
        Base.getindex, Base.setindex!,
        Base.push!, Base.pop!, Base.shift!, Base.empty!,
        Base.search

export  ChainedVector, SubVector,
        show, print_matrix,
        size, strides, stride,
        similar,
        getindex, setindex!,
        push!, pop!, shift!, empty!,
        search

include("ChainedVector.jl")
include("SubVector.jl")
end
