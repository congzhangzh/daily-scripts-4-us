#!/bin/bash

shopt -s globstar

build_project() {
    build_type=$1
    src_dir=$2
    build_dir="${src_dir}/build_${build_type}"

    echo "--begin-- Building ${src_dir}/CMakeLists.txt in ${build_dir} with ${build_type} mode..."

    start_time=$(date +%s)

    mkdir -p "${build_dir}" && cd "${build_dir}"
    if [ $? -ne 0 ]; then
        echo "Failed to change directory to ${build_dir}"
        echo "--end-- Error during setup"
        return 1
    fi

    cmake -DCMAKE_BUILD_TYPE=${build_type} "${src_dir}" && make -j$(nproc)
    ret_val=$?

    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))

    if [ ${ret_val} -eq 0 ]; then
        echo "--end-- Success( ${elapsed_time}s )"
    else
        echo "--end-- Error ${ret_val}(${elapsed_time}s )"
    fi

    return ${ret_val}
}

overall_start_time=$(date +%s)
echo "--begin-- All projects built successfully!"
for d in **/; do
    if [[ -f "${d}/CMakeLists.txt" ]]; then
        echo "--begin-- Found CMakeLists.txt in ${d}"

        build_project debug "${d}"
        if [ $? -ne 0 ]; then
            echo "--end-- Debug build failed for ${d}/CMakeLists.txt"
            exit 1
        fi

        build_project release "${d}"
        if [ $? -ne 0 ]; then
            echo "--end-- Release build failed for ${d}/CMakeLists.txt"
            exit 1
        fi

        echo "--end-- Finished processing ${d}/CMakeLists.txt"
    fi
done

overall_end_time=$(date +%s)
overall_elapsed_time=$((overall_end_time - overall_start_time))
echo "--end-- Total time taken: ${overall_elapsed_time}s"
