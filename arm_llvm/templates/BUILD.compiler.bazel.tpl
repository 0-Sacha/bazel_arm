""

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"], allow_empty = True),
)

filegroup(
    name = "cpp",
    srcs = ["bin/clang-cpp%{extension}"],
)
filegroup(
    name = "cc",
    srcs = ["bin/clang%{extension}"],
)
filegroup(
    name = "cxx",
    srcs = ["bin/clang++%{extension}"],
)
filegroup(
    name = "as",
    srcs = ["bin/clang++%{extension}"],
)
filegroup(
    name = "ar",
    srcs = ["bin/llvm-ar%{extension}"],
)
filegroup(
    name = "ld",
    srcs = ["bin/lld%{extension}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/llvm-objcopy%{extension}"],
)
filegroup(
    name = "strip",
    srcs = ["bin/llvm-strip%{extension}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/llvm-cov%{extension}"],
)

filegroup(
    name = "size",
    srcs = ["bin/llvm-size%{extension}"],
)
filegroup(
    name = "nm",
    srcs = ["bin/llvm-nm%{extension}"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/llvm-objdump%{extension}"],
)
filegroup(
    name = "readelf",
    srcs = ["bin/llvm-readelf%{extension}"],
)
filegroup(
    name = "readobj",
    srcs = ["bin/llvm-readobj%{extension}"],
)
filegroup(
    name = "strings",
    srcs = ["bin/llvm-strings%{extension}"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/%{toolchain_type}-gdb%{extension}"],
)


filegroup(
    name = "toolchain_bins",
    srcs = glob([ "bin/*%{extension}" ], allow_empty = True),
)


# This groups need to be checked, this archives doesn't know about the target, type, and multilib 

filegroup(
    name = "toolchain_includes",
    srcs = glob([ "lib/clang-runtimes/**/*" ], allow_empty = True),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([ "lib/clang-runtimes/*" ], allow_empty = True),
)
