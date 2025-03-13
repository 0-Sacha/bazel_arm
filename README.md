[![bazel_arm/arm-none-eabi](https://github.com/0-Sacha/bazel_arm/actions/workflows/arm-none-eabi.yml/badge.svg)](https://github.com/0-Sacha/bazel_arm/actions/workflows/arm-none-eabi.yml)

# bazel_arm

Bazel module for using an hermetic arm toolchain.
Currently only `arm-none-eabi` is supported with latest version is 13.2.1

You can checkout [bazel_stm32](https://github.com/0-Sacha/bazel_stm32) that use this toolchain to provide a STM32 toolchain.

## How to Use
MODULE.bazel
```python
bazel_dep(name = "rules_cc", version = "0.0.10")
bazel_dep(name = "platforms", version = "0.0.10")

# use the latest commit avaible
git_override(module_name="bazel_utilities", remote="https://github.com/0-Sacha/bazel_utilities.git", commit="1c3c6c01dcccc6c922c4955c92aa7c3c015a9d1c")
git_override(module_name="bazel_arm", remote="https://github.com/0-Sacha/bazel_arm.git", commit="32db016c62be695f42cebc9be21f6cf6e3994a0d")

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
