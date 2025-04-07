load("@bazel_utilities//toolchains:registry.bzl", "gen_archives_registry")

ARM_LLVM_ARCHIVES_19_1_5 = {
    "toolchain": "arm-llvm",
    "version": "19.1.5",
    "version-short": "19.1",
    "latest": True,
    "details": {
        "compiler_version": "19",

        "newlib_overlay_url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-newlib-overlay-19.1.5.zip",
        "newlib_overlay_sha256": "efbe91d95cbc9521ebb212fd97cd4e5ab31222ba8c526ea8727e28efad45608f",
    },
    "archives": {
        "windows_x86_64": {
            "url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-19.1.5-Windows-x86_64.zip",
            "sha256": "f4b26357071a5bae0c1dfe5e0d5061595a8cc1f5d921b6595cc3b269021384eb",
            "strip_prefix": "LLVM-ET-Arm-19.1.5-Windows-x86_64",
        },
        "linux_x86_64": {
            "url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-19.1.5-Linux-x86_64.tar.xz.sha256",
            "sha256": "ed24b2ea7aec2cd09127b2948f92b73e69166b42184b8b8b32956e0e4f2f0143 ",
            "strip_prefix": "LLVM-ET-Arm-19.1.5-Linux-x86_64",
        },
        "linux_aarch64": {
            "url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-19.1.5-Linux-AArch64.tar.xz",
            "sha256": "5E2F6B8C77464371AE2D7445114B4BDC19F56138E8AA864495181B52F57D0B85",
            "strip_prefix": "LLVM-ET-Arm-19.1.5-Linux-AArch64",
        },
    }
}

ARM_LLVM_REGISTRY = gen_archives_registry([
    ARM_LLVM_ARCHIVES_19_1_5
])
