VectorUtils are a couple of classes that:
- chain multiple Vectors to provide a single view (ChainedVector)
- provide a window view into a Vector (SubVector)

ChainedVector and SubVector do not copy the input array(s). They keep a reference to the array and provide index translations. This approach may be more efficient where avoiding allocation and copying of data result in significant savings, e.g. reading or streaming through a file. SubVector is similar to SubArray, but is simpler.

Example:
--------

````
julia> using VectorUtils

julia> v1 = [1, 2, 3]
3-element Int64 Array:
 1
 2
 3

julia> v2 = [4, 5, 6]
3-element Int64 Array:
 4
 5
 6

julia> cv = ChainedVector{Int}(v1, v2)
6-element Int64 ChainedVector:
[1, 2, 3, 4, 5, ...]


julia> cv[1]
1

julia> cv[5]
5

julia> v1 = [1, 2, 3, 4, 5, 6]
6-element Int64 Array:
 1
 2
 3
 4
 5
 6

julia> sv = SubVector{Int}(v1, 2:5) 
4-element Int64 SubVector:
[2, 3, 4, 5, ]


julia> sv[1]
2

julia> sv[4]
5

````

