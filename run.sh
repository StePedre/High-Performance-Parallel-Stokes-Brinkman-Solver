#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build"
NUM_PROCS="${1:-4}"

# Forces OpenMPI to use a short path for temporary files
export TMPDIR=/tmp

CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DPROFILING=ON"
mkdir -p "$BUILD_DIR"
pushd "$BUILD_DIR" > /dev/null

# Configure and build
cmake .. ${CMAKE_FLAGS}
make -j"$(nproc)"

# Run the main program
echo -e "\n=== Running main program with ${NUM_PROCS} MPI processes ==="
mpirun --oversubscribe -n "${NUM_PROCS}" ./main

popd > /dev/null
