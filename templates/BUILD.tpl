""

load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(
    name = "cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",

    compiler_type = "gcc",

    toolchain_bins = {
        "%{compiler_package}:cpp": "cpp",
        "%{compiler_package}:cc": "cc",
        "%{compiler_package}:cxx": "cxx",
        "%{compiler_package}:as": "as",
        "%{compiler_package}:ar": "ar",
        "%{compiler_package}:ld": "ld",

        "%{compiler_package}:objcopy": "objcopy",
        "%{compiler_package}:strip": "strip",

        "%{compiler_package}:cov": "cov",

        "%{compiler_package}:size": "size",
        "%{compiler_package}:nm": "nm",
        "%{compiler_package}:objdump": "objdump",
        "%{compiler_package}:dwp": "dwp",
        "%{compiler_package}:dbg": "dbg",
    },

    cxx_builtin_include_directories = [
        "%{compiler_package_path}%{arm_toolchain_type}/include",
        "%{compiler_package_path}lib/gcc/%{arm_toolchain_type}/%{compiler_version}/include",
        "%{compiler_package_path}lib/gcc/%{arm_toolchain_type}/%{compiler_version}/include-fixed",
        "%{compiler_package_path}%{arm_toolchain_type}/include/c++/%{compiler_version}/",
        "%{compiler_package_path}%{arm_toolchain_type}/include/c++/%{compiler_version}/%{arm_toolchain_type}",
    ],

    copts = %{copts},
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = %{linkdirs} + ([
            "%{compiler_package_path}%{arm_toolchain_type}/lib",
            "%{compiler_package_path}lib/gcc/%{arm_toolchain_type}/%{compiler_version}",
        ] if "%{add_toolchain_linkdirs}" == "true" else []),
    toolchain_libs = %{toolchain_libs},
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_toolchain_config_%{toolchain_id}",
    
    # TODO: Current fix for Sandboxed build # "%{compiler_package}:all_files",
    all_files = ":toolchain_every_files",
    compiler_files = ":toolchain_every_files",
    linker_files = ":toolchain_every_files",
    ar_files = ":toolchain_every_files",
    as_files = ":toolchain_every_files",
    objcopy_files = ":toolchain_every_files",
    strip_files = ":toolchain_every_files",
    dwp_files = ":toolchain_every_files",
    coverage_files = ":toolchain_every_files",

    # dynamic_runtime_lib
    # static_runtime_lib
    # supports_param_files
)

toolchain(
    name = "toolchain_%{toolchain_id}",
    toolchain = ":cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    exec_compatible_with = %{exec_compatible_with},
    target_compatible_with = %{target_compatible_with},
)


filegroup(
    name = "toolchain_every_files",
    srcs = [
        ":toolchain_internal_every_files",
        "%{toolchain_extras_filegroup}",
    ]
)


filegroup(
    name = "cpp",
    srcs = ["bin/%{arm_toolchain_type}-cpp%{extention}"],
)
filegroup(
    name = "cc",
    srcs = ["bin/%{arm_toolchain_type}-gcc%{extention}"],
)
filegroup(
    name = "cxx",
    srcs = ["bin/%{arm_toolchain_type}-g++%{extention}"],
)
filegroup(
    name = "as",
    srcs = ["bin/%{arm_toolchain_type}-as%{extention}"],
)
filegroup(
    name = "ar",
    srcs = ["bin/%{arm_toolchain_type}-ar%{extention}"],
)
filegroup(
    name = "ld",
    srcs = ["bin/%{arm_toolchain_type}-ld%{extention}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/%{arm_toolchain_type}-objcopy%{extention}"],
)
filegroup(
    name = "strip",
    srcs = ["bin/%{arm_toolchain_type}-strip%{extention}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/%{arm_toolchain_type}-gcov%{extention}"],
)

filegroup(
    name = "size",
    srcs = ["bin/%{arm_toolchain_type}-size%{extention}"],
)
filegroup(
    name = "nm",
    srcs = ["bin/%{arm_toolchain_type}-nm%{extention}"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/%{arm_toolchain_type}-objdump%{extention}"],
)
filegroup(
    name = "dwp",
    srcs = ["bin/%{arm_toolchain_type}-dwp%{extention}"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/%{arm_toolchain_type}-gdb%{extention}"],
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
        "bin/*%{extention}",
        "arm-none-eabi/bin/*%{extention}",
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