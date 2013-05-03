ChainedVectors consist of a bunch of types that:
- chain multiple Vectors and make it appear like a single Vector
- give a window into a portion of the chained vector that appears like a single Vector. The window may straddle across boundaries of multiple elements in the chain.

ChainedVector
-------------
Chains multiple vectors. Only index translation is done and the constituent Vectors are not copied. This can be efficient in situations where avoiding allocation and copying of data is important. For example, during sequential file reading, ChainedVectors can be used to store file blocks progressively as the file is read. As it grows beyond a certain size, buffers from the head of the chain can be removed and resued to read further data at the tail.
````
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
````

ChainedVector{Uint8} has specialized methods for **search**, **beginswith**, and **beginswithat** that help in working with textual data.
````
julia> cv = ChainedVector{Uint8}(b"Hello World ", b"Goodbye World ")
26-element Uint8 ChainedVector:
[0x48, 0x65, 0x6c, 0x6c, 0x6f, ...]

julia> search(cv, 'W')
7

julia> search(cv, 'W', 8)
21

julia> search(cv, 'W', 22)
0

julia> beginswith(cv, b"Hello")
true

julia> beginswith(cv, b"ello")
false

julia> beginswithat(cv, 2, b"ello")
true

julia> beginswithat(cv, 7, b"World Goodbye")
true
````


Window view of a ChainedVector
------------------------------
Using the **sub** method, a portion of the data in the ChainedVector can be accessed as a view:
````
sub(cv::ChainedVector, r::Range1{Int})
````

Example:
````
julia> v1 = [1, 2, 3, 4, 5, 6];

julia> v2 = [7, 8, 9, 10, 11, 12];

julia> cv = ChainedVector{Int}(v1, v2);

julia> sv = sub(cv, 3:10)
8-element Int64 SubVector:
[3, 4, 5, 6, 7, ...]


julia> sv[1]
3

julia> # sv[7] is the same as cv[9] and v2[3]

julia> println("sv[7]=$(sv[7]), v2[3]=$(v2[3]), cv[9]=$(cv[9])")
sv[7]=9, v2[3]=9, cv[9]=9

julia> 

julia> # changing values through sv will be visible at cv and v2

julia> sv[7] = 71
71

julia> println("sv[7]=$(sv[7]), v2[3]=$(v2[3]), cv[9]=$(cv[9])")
sv[7]=71, v2[3]=71, cv[9]=71
````

The sub method returns a Vector that indexes into the chained vector at the given range. The returned Vector is not a copy and any modifications affect the Chainedvector and consequently the constituent vectors of the ChainedVector as well. The returned vector can be an instance of either a SubVector or a Vector obtained through the method fast\_sub\_vec. 

<dl>
<dt>SubVector</dt>
<dd>
Provides index translations for abstract vectors. 
Example:
<pre>
julia> v1 = [1, 2, 3, 4, 5, 6];

julia> sv = SubVector(v1, 2:5)
4-element Int64 SubVector:
[2, 3, 4, 5, ]


julia> sv[1]
2

julia> sv[1] = 20
20

julia> v1[2]
20
</pre>
</dd>
<dt>fast_sub_vec</dt>
<dd>
Provides an optimized way of creating a Vector that points within another Vector and uses the same underlying data. Since it reuses the same memory locations, it works only on concrete Vectors that give contiguous memory locations. Internally the instance of the view vector is maintained in a WeakKeyDict along with a reference to the larger vector to prevent gc from releasing the parent vector till the view is in use.
Example:
<pre>
julia> v1 = [1, 2, 3, 4, 5, 6];

julia> sv = fast_sub_vec(v1, 2:5)
4-element Int64 Array:
 2
 3
 4
 5

julia> 

julia> println("sv[1]=$(sv[1]), v1[2]=$(v1[2])")
sv[1]=2, v1[2]=2

julia> sv[1] = 20
20

julia> println("sv[1]=$(sv[1]), v1[2]=$(v1[2])")
sv[1]=20, v1[2]=20
</pre>
</dd>
</dl>


Tests and Benchmarks
--------------------
Below is the output of some benchmarks done using time\_tests.jl located in the test folder.
````
Times for getindex across all elements of vectors of 33554432 integers.
Split into two 16777216 buffers for ChainedVectors.

Vector: 0.041909848
ChainedVector: 0.261795721
SubVector: 0.172702399
FastSubVector: 0.041579312
SubArray: 3.848813439
SubVector of ChainedVector: 0.418898455
````

