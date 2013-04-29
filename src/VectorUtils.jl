module VectorUtils

import  Base.show, Base.print_matrix,
        Base.size, Base.strides, Base.stride,
        Base.similar, Base.vec,
        Base.getindex, Base.setindex!,
        Base.push!, Base.pop!, Base.shift!, Base.empty!,
        Base.search, Base.beginswith

export  ChainedVector, SubVector,
        show, print_matrix,
        size, strides, stride,
        similar, vec,
        getindex, setindex!,
        push!, pop!, shift!, empty!,
        search, beginswith, beginswithat

include("ChainedVector.jl")
include("SubVector.jl")
end
