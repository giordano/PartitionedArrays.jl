


<img src="https://github.com/fverdugo/PartitionedArrays.jl/raw/master/assets/logo.png" width="300" title="Logo">

[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://fverdugo.github.io/PartitionedArrays.jl/dev)
[![Build Status](https://github.com/fverdugo/PartitionedArrays.jl/workflows/CI/badge.svg)](https://github.com/fverdugo/PartitionedArrays.jl/actions)
[![Coverage](https://codecov.io/gh/fverdugo/PartitionedArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/fverdugo/PartitionedArrays.jl)

## What



This package provides a data-oriented parallel implementation of partitioned vectors and sparse matrices needed in FD, FV, and FE simulations. The long-term goal of this package is to provide (when combined with other Julia packages as `IterativeSolvers.jl`) a Julia alternative to well-known distributed algebra back ends such as `PETSc`. `PartitionedArrays` is being used by other projects such as [`GridapDistributed`](https://github.com/gridap/GridapDistributed.jl), the parallel distributed-memory extension of the [`Gridap`](https://github.com/gridap/Gridap.jl) FE library.

The basic types implemented in `PartitionedArrays` are:
- `AbstractBackend`: Abstract type to be specialized for different execution models. Now, this package provides `SequentialBackend` and `MPIBackend`.
- `AbstractPData`: The low level abstract type representing some data partitioned over several chunks or parts. This is the core component of the data-oriented parallel implementation. Now, this package provides `SequentialData` and `MPIData`.
- `PRange`: A specialization of `AbstractUnitRange` that has information about how the ids in the range are partitioned in different chunks. This type is used to describe the parallel data layout of rows and cols in `PVector` and `PSparseMatrix` objects.
- `PVector`: A vector partitioned in (overlapping or non-overlapping) chunks.
- `PSparseMatrix`: A sparse matrix partitioned in (overlapping or non-overlapping) chunks of rows.
- `PTimer`: A time measuring mechanism designed for the execution model of this package.

On these types, several communication operations are defined:

- `gather!`, `gather`, `gather_all!`, `gather_all`
- `reduce`, `reduce_all`, `reduce_main`
- `scatter`
- `emit` (aka broadcast)
- `iscan`, `iscan_all`, `iscan_main`
- `xscan`, `xscan_all`, `xscan_main`
- `exchange!` `exchange`, `async_exchange!` `async_exchange`
- `assemble!`, `async_assemble!`

## Why

One can use PETSc bindings like [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) for parallel computations in Julia, but this approach has some limitations:

- PETSc is hard-coded for vectors/matrices of some particular element types (e.g. `Float64` and `ComplexF64`).

- PETSc forces one to use MPI as the parallel execution model. Drivers are executed as `mpirun -np 4 julia --project=. input.jl`, which means no interactive Julia sessions, no `Revise`, no `Debugger`. This is a major limitation to develop parallel algorithms.

This package aims to overcome these limitations. It implements (and allows to implement) parallel algorithms in a generic way independently of the underlying hardware / message passing software that is eventually used. At this moment, this library provides two back ends for running the generic parallel algorithms:
- `SequentialBackend`: The parallel data is split in chunks, which are stored in a conventional (sequential) Julia session (typically in an `Array`). The tasks in the parallel algorithms are executed one after the other. Note that the sequential back end does not mean to distribute the data in a single part. The data can be split in an arbitrary number of parts. 
- `MPIBackend`: Chunks of parallel data and parallel tasks are mapped to different MPI processes. The drivers are to be executed in MPI mode, e.g., `mpirun -n 4 julia --project=. input.jl`.


The `SequentialBackend` is specially handy for developing new code. Since it runs in a standard Julia session, one can use tools like `Revise` and `Debugger` that will certainly do your life easier at the developing stage. Once the code works with the `SequentialBackend`, it can be automatically deployed in a supercomputer via the `MPIBackend`.  Other back ends like a `ThreadedBacked`, `DistributedBackend`, or `MPIXBackend` can be added in the future.

## Performance

This figure shows a strong scaling test of the total time spent in setting up the main components of a FE simulation using `PartitionedArrays` as the distributed linear algebra backend. A good scaling is obtained beyond 25 thousand degrees of freedom (DOFs) per cpu core, which is usualy considered the point in which scalability starts to significanlty degrade in FE computations.

![](https://github.com/fverdugo/PartitionedArrays.jl/raw/master/assets/total_scaling.png)

The wall time includes
- Generation of a distributed Cartesian FE mesh
- Generation of local FE spaces
- Generation of a global DOF numbering
- Assembly of the distribtued sparse linear system
- Interpolation of a manufactured solution
- Computation of the residual (incudes a matrix-vector product) and its norm.

The results are obtained with the package [`PartitionedPoisson.jl`](https://github.com/fverdugo/PartitionedPoisson.jl).


## How to collaborate

We have a number of [issues waiting for help](https://github.com/fverdugo/PartitionedArrays.jl/labels/help%20wanted). You can start contributing to `PartitionedArrays.jl` by solving some of those issues. Contact with us to coordinate.




