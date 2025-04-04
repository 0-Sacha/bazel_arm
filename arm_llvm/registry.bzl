load("@bazel_utilities//toolchains:registry.bzl", "gen_archives_registry")

ARM_LLVM_ARCHIVES_19_1_5 = {
    "toolchain": "arm-llvm",
    "version": "19.1.5",
    "version-short": "19.1",
    "latest": True,
    "details": {
        "compiler_version": "14.2.1",

        "newlib_overlay_url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-newlib-overlay-19.1.5.zip",
        "newlib_overlay_sha256": "EFBE91D95CBC9521EBB212FD97CD4E5AB31222BA8C526EA8727E28EFAD45608F",
    },
    "archives": {
        "windows_x86_64": {
            "url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-19.1.5-Windows-x86_64.zip",
            "sha256": "F4B26357071A5BAE0C1DFE5E0D5061595A8CC1F5D921B6595CC3B269021384EB",
            "strip_prefix": "LLVM-ET-Arm-19.1.5-Windows-x86_64",
        },
        "linux_x86_64": {
            "url": "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.5/LLVM-ET-Arm-19.1.5-Linux-x86_64.tar.xz.sha256",
            "sha256": "34EE877AADC78C5E9F067E603A1BC9745ED93CA7AE5DBFC9B4406508DC153920",
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
