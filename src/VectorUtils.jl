module VectorUtils

import  Base.getindex,
        Base.setindex!,
        Base.size,
        Base.strides,
        Base.stride,
        Base.show,
        Base.similar,
        Base.print_matrix

export  ChainedVector,
        SubVector,
        show,
        print_matrix,
        size,
        strides,
        stride,
        similar,
        getindex,
        setindex!,
        append

include("ChainedVector.jl")
include("SubVector.jl")
end
