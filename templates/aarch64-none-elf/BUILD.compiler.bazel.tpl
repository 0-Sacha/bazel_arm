""

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"], allow_empty = True),
)


filegroup(
    name = "cpp",
    srcs = ["bin/%{toolchain_type}-cpp%{extension}"],
)
filegroup(
    name = "cc",
    srcs = ["bin/%{toolchain_type}-gcc%{extension}"],
)
filegroup(
    name = "cxx",
    srcs = ["bin/%{toolchain_type}-g++%{extension}"],
)
filegroup(
    name = "as",
    srcs = ["bin/%{toolchain_type}-as%{extension}"],
)
filegroup(
    name = "ar",
    srcs = ["bin/%{toolchain_type}-ar%{extension}"],
)
filegroup(
    name = "ld",
    srcs = ["bin/%{toolchain_type}-ld%{extension}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/%{toolchain_type}-objcopy%{extension}"],
)
filegroup(
    name = "strip",
    srcs = ["bin/%{toolchain_type}-strip%{extension}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/%{toolchain_type}-gcov%{extension}"],
)

filegroup(
    name = "size",
    srcs = ["bin/%{toolchain_type}-size%{extension}"],
)
filegroup(
    name = "nm",
    srcs = ["bin/%{toolchain_type}-nm%{extension}"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/%{toolchain_type}-objdump%{extension}"],
)
filegroup(
    name = "dwp",
    srcs = ["bin/%{toolchain_type}-dwp%{extension}"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/%{toolchain_type}-gdb%{extension}"],
)


filegroup(
    name = "toolchain_includes",
    srcs = glob([
        "lib/gcc/%{toolchain_type}/%{compiler_version}/include/*",
        "lib/gcc/%{toolchain_type}/%{compiler_version}/include-fixed/*",
        "%{toolchain_type}/include/*",
    ], allow_empty = True),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([
        "lib/gcc/%{toolchain_type}/%{compiler_version}/*",
        "%{toolchain_type}/lib/*",
    ], allow_empty = True),
)

filegroup(
    name = "toolchain_bins",
    srcs = glob([
        "%{toolchain_type}/bin/*%{extension}",
        # "bin/*%{extension}",
    ], allow_empty = True),
)
