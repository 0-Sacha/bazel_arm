[![bazel_arm/gcc/arm-none-eabi](https://github.com/0-Sacha/bazel_arm/actions/workflows/gcc_arm-none-eabi.yml/badge.svg)](https://github.com/0-Sacha/bazel_arm/actions/workflows/gcc_arm-none-eabi.yml)
[![bazel_arm/gcc/aarch64-none-eabi](https://github.com/0-Sacha/bazel_arm/actions/workflows/gcc_aarch64-none-elf.yml/badge.svg)](https://github.com/0-Sacha/bazel_arm/actions/workflows/gcc_aarch64-none-elf.yml)

[![bazel_arm/llvm/arm-none-eabi/picolibc](https://github.com/0-Sacha/bazel_arm/actions/workflows/llvm_arm-none-eabi_picolibc.yml/badge.svg)](https://github.com/0-Sacha/bazel_arm/actions/workflows/llvm_arm-none-eabi_picolibc.yml)
[![bazel_arm/llvm/arm-none-eabi/newlib](https://github.com/0-Sacha/bazel_arm/actions/workflows/llvm_arm-none-eabi_newlib.yml/badge.svg)](https://github.com/0-Sacha/bazel_arm/actions/workflows/llvm_arm-none-eabi_newlib.yml)

# bazel_arm

Bazel module for using an hermetic arm toolchain.

- `arm-none-eabi` and `arm-none-elf`: [arm-gnu-toolchain-downloads](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- `arm-llvm`:
    - before 19.1.5: [LLVM-embedded-toolchain-for-Arm](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm)
    - 20 and after: [arm-toolchain](https://github.com/arm/arm-toolchain)

You can checkout [bazel_stm32](https://github.com/0-Sacha/bazel_stm32) that use this toolchain to provide an STM32 toolchain.

## How to Use
MODULE.bazel
```python
bazel_dep(name = "rules_cc", version = "0.0.10")
bazel_dep(name = "platforms", version = "0.0.10")

# use the latest commit available
git_override(module_name="bazel_utilities", remote="https://github.com/0-Sacha/bazel_utilities.git", commit="230196b5427877a13e38a6e9d3b5a3b336ff2480")
git_override(module_name="bazel_arm", remote="https://github.com/0-Sacha/bazel_arm.git", commit="610ec5092932dd6387054a7843e80874db4b459a")

bazel_dep(name = "bazel_utilities", version = "0.0.1", dev_dependency = True)
bazel_dep(name = "bazel_arm", version = "0.0.1", dev_dependency = True)

arm_toolchain_extension = use_extension("@bazel_arm//:rules.bzl", "arm_toolchain_extension", dev_dependency = True)
inject_repo(arm_toolchain_extension, "platforms", "bazel_utilities")
arm_toolchain_extension.arm_toolchain(
    name = "my_repo_name",
    toolchain_type = "arm-none-eabi",
    linkopts = [
        "-specs=nosys.specs"
    ],
)
use_repo(arm_toolchain_extension, "my_repo_name")
register_toolchains("@my_repo_name//:toolchain")
```
