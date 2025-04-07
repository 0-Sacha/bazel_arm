""

load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config_bins")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config_bins(
    name = "cc_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",

    compiler_type = "clang",

    cpp_bin = "%{compiler_package}:cpp",
    cc_bin = "%{compiler_package}:cc",
    cxx_bin = "%{compiler_package}:cxx",
    ar_bin = "%{compiler_package}:as",
    as_bin = "%{compiler_package}:ar",
    ld_bin = "%{compiler_package}:ld",
    strip_bin = "%{compiler_package}:strip",
    cov_bin = "%{compiler_package}:cov",
    nm_bin = "%{compiler_package}:nm",
    objdump_bin = "%{compiler_package}:objdump",

    toolchain_builtin_includedirs_isystem = [
    ] + %{toolchain_builtin_includedirs_isystem},
    
    toolchain_builtin_includedirs = [
    ] + %{toolchain_builtin_includedirs},

    copts = %{copts},
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = %{linkdirs},
    linklibs = %{linklibs},
    dbg_copts = %{dbg_copts},
    dbg_linkopts = %{dbg_linkopts},
    opt_copts = %{opt_copts},
    opt_linkopts = %{opt_linkopts},
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_config_%{toolchain_id}",
    
    # TODO: Current fix for sandboxed build, should check the minimal set for every rules
    all_files = ":toolchain_every_files",
    compiler_files = ":toolchain_every_files",
    linker_files = ":toolchain_every_files",
    ar_files = ":toolchain_every_files",
    as_files = ":toolchain_every_files",
    objcopy_files = ":toolchain_every_files",
    strip_files = ":toolchain_every_files",
    dwp_files = ":toolchain_every_files",
    coverage_files = ":toolchain_every_files",
)

toolchain(
    name = "toolchain",
    toolchain = ":cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    exec_compatible_with = %{exec_compatible_with},
    target_compatible_with = %{target_compatible_with},
)


filegroup(
    name = "toolchain_every_files",
    srcs = [
        "%{compiler_package}:toolchain_internal_every_files",
    ] + %{toolchain_extras_filegroups}
)
filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
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


filegroup(
    name = "toolchain_includes",
    srcs = glob([ "lib/clang-runtimes/%{toolchain_type}/%{toolchain_mulilib}/include/**/*" ], allow_empty = True),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([ "lib/clang-runtimes/%{toolchain_type}/%{toolchain_mulilib}/lib/*" ], allow_empty = True),
)


filegroup(
    name = "all_files",
    srcs = [
        "%{compiler_package}:toolchain_includes",
        "%{compiler_package}:toolchain_libs",
        "%{compiler_package}:toolchain_bins",
    ],
)

filegroup(
    name = "compiler_files",
    srcs = [
        "%{compiler_package}:toolchain_includes",
        "%{compiler_package}:cpp",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        "%{compiler_package}:toolchain_libs",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
        "%{compiler_package}:ld",
        "%{compiler_package}:ar",
    ],
)

filegroup(
    name = "coverage_files",
    srcs = [
        "%{compiler_package}:toolchain_includes",
        "%{compiler_package}:toolchain_libs",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
        "%{compiler_package}:ld",
        "%{compiler_package}:cov",
    ],
)

filegroup(
    name = "compiler_components",
    srcs = [
        "%{compiler_package}:cpp",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
        "%{compiler_package}:ar",
        "%{compiler_package}:ld",

        "%{compiler_package}:objcopy",
        "%{compiler_package}:strip",

        "%{compiler_package}:cov",

        "%{compiler_package}:nm",
        "%{compiler_package}:objdump",
        "%{compiler_package}:as",
        "%{compiler_package}:size",
        "%{compiler_package}:readelf",
        "%{compiler_package}:readobj",
        "%{compiler_package}:strings",
        
        "%{compiler_package}:dbg",
    ],
)
