#!/bin/bash

set -euxo pipefail

rustup target add aarch64-linux-android

export TVM_NDK_CC="D:\ProgramData\Android\Sdk\ndk\26.1.10909125\toolchains\llvm\prebuilt\windows-x86_64\bin\aarch64-linux-android24-clang"
export ANDROID_NDK="D:\ProgramData\Android\Sdk\ndk\26.1.10909125"
export JAVA_HOME="C:\Users\Xjchen\.jdks\openjdk-18.0.2.1"
export PATH=$PATH:"/c/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.36.32532/bin/Hostx64/x64"
export JAVA_INCLUDE_PATH=$JAVA_HOME/include
export JAVA_INCLUDE_PATH2=$JAVA_HOME/include/win32
#export JNI=$JAVA_INCLUDE_PATH/jni.h
export MAKE="D:\ProgramData\Android\Sdk\ndk\26.1.10909125\prebuilt\windows-x86_64\bin\make"
export TVM_HOME='D:/MyFileAtD/mobllm/mlc-llm/android/../3rdparty/tvm'
alias link.exe="/c/\"Program Files\"/\"Microsoft Visual Studio\"/2022/Community/VC/Tools/MSVC/14.37.32822/bin/Hostx64/x64/link.exe"

mkdir -p build/model_lib

"D:\.conda\envs\mlc-chat-venv\python" prepare_model_lib.py

cd build
touch config.cmake
if [ ${TVM_HOME-0} -ne 0 ]; then
  echo "set(TVM_HOME ${TVM_HOME})" >> config.cmake
fi

"D:\ProgramData\Android\Sdk\cmake\3.22.1\bin\cmake" .. \
      -G "MinGW Makefiles" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=. \
      -DCMAKE_CXX_FLAGS="-O3" \
      -DANDROID_ABI=arm64-v8a \
      -DANDROID_NATIVE_API_LEVEL=android-24 \
      -DANDROID_PLATFORM=android-24 \
      -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON \
      -DANDROID_STL=c++_static \
      -DUSE_HEXAGON_SDK=OFF \
      -DMLC_LLM_INSTALL_STATIC_LIB=ON \
      -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON \
      -DUSE_OPENCL=ON \
      -DUSE_CUSTOM_LOGGING=ON \

"D:\ProgramData\Android\Sdk\ndk\26.1.10909125\prebuilt\windows-x86_64\bin\make" tvm4j_runtime_packed -j10
"D:\ProgramData\Android\Sdk\cmake\3.22.1\bin\cmake" --build . --target install --config release -j
