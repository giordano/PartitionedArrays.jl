module InterfacesTests

include("../test_interfaces.jl")

nparts = 4
with_backend(test_interfaces,SequentialBackend(),nparts)

nparts = (2,2)
with_backend(test_interfaces,SequentialBackend(),nparts)

end # module

