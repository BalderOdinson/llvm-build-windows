@echo off
setlocal

rem !!! build requirements !!!
rem Visual Studio 2017 BuildTools
rem Python - https://www.python.org/downloads/
rem CMake - http://www.cmake.org/download/
rem 7za.exe - from "7-Zip Extra" from https://www.7-zip.org/download.html
rem ninja.exe from https://github.com/ninja-build/ninja/releases/latest

set VERSION=12.0.1

rem echo downloading and unpacking...
rem curl -sfL https://github.com/llvm/llvm-project/releases/download/llvmorg-%VERSION%/llvm-project-%VERSION%.src.tar.xz ^
rem   | 7za.exe x -bb0 -txz -si -so ^
rem   | 7za.exe x -bb0 -ttar -si -aoa 1>nul 2>nul

set INSTALL_DIR=%CD%\llvm-project-%VERSION%

rem ** You can add more targets to LLVM_TARGETS_TO_BUILD line, or just remove it to build all possible targets
rem ** Remove clang-tools-extra from LLVM_ENABLE_PROJECTS if you're not interested in clang-tidy.exe, clangd.exe and other clang tools
rem ** Build in configuration below takes ~13min on 16-core Ryzen
cmake ^
  -G Ninja ^
  -S "llvm-project-%VERSION%.src\llvm" ^
  -B "llvm-project-%VERSION%.build" ^
  -D CMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
  -D CMAKE_BUILD_TYPE="Release" ^
  -D LLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;polly" ^
  -D LLVM_TARGETS_TO_BUILD="AArch64;ARM;WebAssembly;X86" ^
  -D LLVM_ENABLE_BACKTRACES=OFF ^
  -D LLVM_ENABLE_UNWIND_TABLES=OFF ^
  -D LLVM_ENABLE_CRASH_OVERRIDES=OFF ^
  -D LLVM_ENABLE_TERMINFO=OFF ^
  -D LLVM_ENABLE_LIBXML2=OFF ^
  -D LLVM_ENABLE_LIBEDIT=OFF ^
  -D LLVM_ENABLE_LIBPFM=OFF ^
  -D LLVM_ENABLE_ZLIB=OFF ^
  -D LLVM_ENABLE_Z3_SOLVER=OFF ^
  -D LLVM_ENABLE_WARNINGS=OFF ^
  -D LLVM_ENABLE_PEDANTIC=OFF ^
  -D LLVM_ENABLE_WERROR=OFF ^
  -D LLVM_ENABLE_ASSERTIONS=OFF ^
  -D LLVM_BUILD_EXAMPLES=OFF ^
  -D LLVM_INCLUDE_EXAMPLES=OFF ^
  -D LLVM_BUILD_TESTS=OFF ^
  -D LLVM_INCLUDE_TESTS=OFF ^
  -D LLVM_BUILD_BENCHMARKS=OFF ^
  -D LLVM_INCLUDE_BENCHMARKS=OFF ^
  -D LLVM_BUILD_DOCS=OFF ^
  -D LLVM_INCLUDE_DOCS=OFF ^
  -D LLVM_ENABLE_BINDINGS=OFF ^
  -D LLVM_OPTIMIZED_TABLEGEN=ON ^
  -D LLVM_ENABLE_PLUGINS=OFF ^
  -D LLVM_USE_CRT_RELEASE=MD ^
  -D LLVM_ENABLE_IDE=OFF ^
  -D CLANG_BUILD_EXAMPLES=OFF ^
  -D CLANG_INCLUDE_TESTS=OFF ^
  -D CLANG_INCLUDE_DOCS=OFF ^
  -D CLANG_ENABLE_ARCMT=OFF ^
  -D CLANG_ENABLE_STATIC_ANALYZER=OFF

ninja -C llvm-project-%VERSION%.build install

set LLVM_PATH=%INSTALL_DIR:\=/%

cmake ^
  -G Ninja ^
  -S "llvm-project-%VERSION%.src\compiler-rt" ^
  -B "llvm-project-%VERSION%.compiler-rt.build" ^
  -D CMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
  -D CMAKE_BUILD_TYPE="Release" ^
  -D CMAKE_PREFIX_PATH="%INSTALL_DIR%" ^
  -D CMAKE_C_COMPILER="%LLVM_PATH%/bin/clang-cl.exe" ^
  -D CMAKE_CXX_COMPILER="%LLVM_PATH%/bin/clang-cl.exe" ^
  -D CMAKE_ASM_COMPILER="%LLVM_PATH%/bin/clang-cl.exe" ^
  -D CMAKE_LINKER="%LLVM_PATH%/bin/lld-link.exe" ^
  -D CMAKE_AR="%LLVM_PATH%/bin/llvm-lib.exe" ^
  -D CMAKE_LIPO="%LLVM_PATH%/bin/llvm-lipo.exe" ^
  -D CMAKE_RANLIB="%LLVM_PATH%/bin/llvm-ranlib.exe" ^
  -D CMAKE_NM="%LLVM_PATH%/bin/llvm-nm.exe" ^
  -D CMAKE_OBJDUMP="%LLVM_PATH%/bin/llvm-objdump.exe" ^
  -D CMAKE_OBJCOPY="%LLVM_PATH%/bin/llvm-objcopy.exe" ^
  -D CMAKE_STRIP="%LLVM_PATH%/bin/llvm-strip.exe" ^
  -D CMAKE_MT="mt.exe" ^
  -D LLVM_TARGETS_TO_BUILD="AArch64;ARM;WebAssembly;X86" ^
  -D LLVM_ENABLE_BACKTRACES=OFF ^
  -D LLVM_ENABLE_UNWIND_TABLES=OFF ^
  -D LLVM_ENABLE_CRASH_OVERRIDES=OFF ^
  -D LLVM_ENABLE_TERMINFO=OFF ^
  -D LLVM_ENABLE_LIBXML2=OFF ^
  -D LLVM_ENABLE_LIBEDIT=OFF ^
  -D LLVM_ENABLE_LIBPFM=OFF ^
  -D LLVM_ENABLE_ZLIB=OFF ^
  -D LLVM_ENABLE_Z3_SOLVER=OFF ^
  -D LLVM_ENABLE_WARNINGS=OFF ^
  -D LLVM_ENABLE_PEDANTIC=OFF ^
  -D LLVM_ENABLE_WERROR=OFF ^
  -D LLVM_ENABLE_ASSERTIONS=OFF ^
  -D LLVM_BUILD_EXAMPLES=OFF ^
  -D LLVM_INCLUDE_EXAMPLES=OFF ^
  -D LLVM_BUILD_TESTS=OFF ^
  -D LLVM_INCLUDE_TESTS=OFF ^
  -D LLVM_BUILD_BENCHMARKS=OFF ^
  -D LLVM_INCLUDE_BENCHMARKS=OFF ^
  -D LLVM_BUILD_DOCS=OFF ^
  -D LLVM_INCLUDE_DOCS=OFF ^
  -D LLVM_ENABLE_BINDINGS=OFF ^
  -D LLVM_OPTIMIZED_TABLEGEN=ON ^
  -D LLVM_ENABLE_PLUGINS=OFF ^
  -D LLVM_USE_CRT_RELEASE=MD ^
  -D LLVM_ENABLE_IDE=OFF ^
  -D CLANG_BUILD_EXAMPLES=OFF ^
  -D CLANG_INCLUDE_TESTS=OFF ^
  -D CLANG_INCLUDE_DOCS=OFF ^
  -D CLANG_ENABLE_ARCMT=OFF ^
  -D CLANG_ENABLE_STATIC_ANALYZER=OFF

ninja -C llvm-project-%VERSION%.compiler-rt.build install
