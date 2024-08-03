#!/bin/bash

Tips: This work done by me, which work with claude ai :)

# 函数：显示使用说明
show_usage() {
    echo "Usage: $0 -i <input_file> [-d]"
    echo "  -i <input_file>  Specify the input file to compress"
    echo "  -d               Use dictionary mode for compression/decompression"
    echo "  -h               Display this help message"
}

# 解析命令行参数
INPUT_FILE=""
USE_DICTIONARY=false

while getopts ":i:dh" opt; do
    case ${opt} in
        i )
            INPUT_FILE=$OPTARG
            ;;
        d )
            USE_DICTIONARY=true
            ;;
        h )
            show_usage
            exit 0
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            show_usage
            exit 1
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            show_usage
            exit 1
            ;;
    esac
done

# 检查必需的参数
if [ -z "$INPUT_FILE" ]; then
    echo "Error: Input file is required."
    show_usage
    exit 1
fi

# 确保zstd已安装
if ! command -v zstd &> /dev/null
then
    echo "zstd could not be found. Please install it first."
    exit 1
fi

# 设置变量
WORK_DIR=$(dirname "$INPUT_FILE")
INPUT_FILENAME=$(basename "$INPUT_FILE")
MAIN_NAME="${INPUT_FILENAME%.*}"
COMPRESSED_FILE="${WORK_DIR}/${MAIN_NAME}.zst"
DECOMPRESSED_FILE="${WORK_DIR}/${MAIN_NAME}.decompressed"
COMPRESSION_LEVEL=19
DICTIONARY_FILE="${WORK_DIR}/${MAIN_NAME}.dict"

# 设置压缩和解压命令
if $USE_DICTIONARY; then
    echo "Creating a new dictionary..."
    zstd --train -B10M "$INPUT_FILE" -o "$DICTIONARY_FILE"
    COMPRESS_CMD="zstd -$COMPRESSION_LEVEL -D $DICTIONARY_FILE"
    DECOMPRESS_CMD="zstd -d -D $DICTIONARY_FILE"
    echo "Dictionary created: $DICTIONARY_FILE"
else
    COMPRESS_CMD="zstd -$COMPRESSION_LEVEL"
    DECOMPRESS_CMD="zstd -d"
    echo "Using standard compression without dictionary"
fi

# 压缩
echo "Starting compression..."
COMPRESSION_START=$(date +%s)
$COMPRESS_CMD "$INPUT_FILE" -o "$COMPRESSED_FILE"
COMPRESSION_END=$(date +%s)

# 计算压缩时间
COMPRESSION_TIME=$((COMPRESSION_END - COMPRESSION_START))

# 计算文件大小和压缩比
ORIGINAL_SIZE=$(stat -c%s "$INPUT_FILE")
COMPRESSED_SIZE=$(stat -c%s "$COMPRESSED_FILE")
COMPRESSION_RATIO=$(echo "scale=2; $ORIGINAL_SIZE / $COMPRESSED_SIZE" | bc)

# 解压
echo "Starting decompression..."
DECOMPRESSION_START=$(date +%s)
$DECOMPRESS_CMD "$COMPRESSED_FILE" -o "$DECOMPRESSED_FILE"
DECOMPRESSION_END=$(date +%s)

# 计算解压时间
DECOMPRESSION_TIME=$((DECOMPRESSION_END - DECOMPRESSION_START))

# 验证解压文件的完整性
echo "Verifying decompressed file integrity..."
if cmp -s "$INPUT_FILE" "$DECOMPRESSED_FILE"; then
    echo "Decompressed file is identical to the original."
else
    echo "Warning: Decompressed file differs from the original."
fi

# 输出结果
echo "Results:"
echo "Original size: $(numfmt --to=iec-i --suffix=B --format="%.2f" $ORIGINAL_SIZE)"
echo "Compressed size: $(numfmt --to=iec-i --suffix=B --format="%.2f" $COMPRESSED_SIZE)"
echo "Compression ratio: ${COMPRESSION_RATIO}:1"
echo "Compression time: ${COMPRESSION_TIME} seconds"
echo "Decompression time: ${DECOMPRESSION_TIME} seconds"

# 清理
echo "Cleaning up..."
rm "$COMPRESSED_FILE" "$DECOMPRESSED_FILE"
if $USE_DICTIONARY; then
    rm "$DICTIONARY_FILE"
fi

echo "Test completed."