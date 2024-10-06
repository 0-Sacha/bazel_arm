""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "cpp",
    srcs = ["bin/%{arm_toolchain_type}-cpp%{extension}"],
)
filegroup(
    name = "cc",
    srcs = ["bin/%{arm_toolchain_type}-gcc%{extension}"],
)
filegroup(
    name = "cxx",
    srcs = ["bin/%{arm_toolchain_type}-g++%{extension}"],
)
filegroup(
    name = "as",
    srcs = ["bin/%{arm_toolchain_type}-as%{extension}"],
)
filegroup(
    name = "ar",
    srcs = ["bin/%{arm_toolchain_type}-ar%{extension}"],
)
filegroup(
    name = "ld",
    srcs = ["bin/%{arm_toolchain_type}-ld%{extension}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/%{arm_toolchain_type}-objcopy%{extension}"],
)
filegroup(
    name = "strip",
    srcs = ["bin/%{arm_toolchain_type}-strip%{extension}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/%{arm_toolchain_type}-gcov%{extension}"],
)

filegroup(
    name = "size",
    srcs = ["bin/%{arm_toolchain_type}-size%{extension}"],
)
filegroup(
    name = "nm",
    srcs = ["bin/%{arm_toolchain_type}-nm%{extension}"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/%{arm_toolchain_type}-objdump%{extension}"],
)
filegroup(
    name = "dwp",
    srcs = ["bin/%{arm_toolchain_type}-dwp%{extension}"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/%{arm_toolchain_type}-gdb%{extension}"],
)


filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
)

filegroup(
    name = "toolchain_includes",
    srcs = glob([
        "lib/gcc/arm-none-eabi/%{compiler_version}/include/**",
        "lib/gcc/arm-none-eabi/%{compiler_version}/include-fixed/**",
        "arm-none-eabi/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([
        "lib/gcc/arm-none-eabi/%{compiler_version}/*",
        "arm-none-eabi/lib/*",
        "lib/*",
    ]),
)

filegroup(
    name = "toolchain_bins",
    srcs = glob([
        "bin/*%{extension}",
        "arm-none-eabi/bin/*%{extension}",
    ]),
)

filegroup(
    name = "all_files",
    srcs = [
        ":toolchain_includes",
        ":toolchain_libs",
        ":toolchain_bins",
    ],
)

filegroup(
    name = "compiler_files",
    srcs = [
        ":toolchain_includes",
        ":cpp",
        ":cc",
        ":cxx",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        ":toolchain_libs",
        ":cc",
        ":cxx",
        ":ld",
        ":ar",
    ],
)

filegroup(
    name = "coverage_files",
    srcs = [
        ":toolchain_includes",
        ":toolchain_libs",
        ":cc",
        ":cxx",
        ":ld",
        ":cov",
    ],
)

filegroup(
    name = "compiler_components",
    srcs = [
        ":cpp",
        ":cc",
        ":cxx",
        ":ar",
        ":ld",

        ":objcopy",
        ":strip",

        ":cov",

        ":nm",
        ":objdump",
        ":as",
        ":size",
        ":dwp",
        
        ":dbg",
    ],
)
