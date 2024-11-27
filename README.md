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
git_override(module_name="bazel_utilities", remote="https://github.com/0-Sacha/bazel_utilities.git", commit="fbb17685ac9ba78fef914a322e6c37839dc16d4f")
git_override(module_name="bazel_winlibs", remote="https://github.com/0-Sacha/bazel_winlibs.git", commit="455905e58465eeb6e7a4a63e3ba3c7e985a3fc53")

bazel_dep(name = "bazel_utilities", version = "0.0.1", dev_dependency = True)
bazel_dep(name = "bazel_winlibs", version = "0.0.1", dev_dependency = True)

winlibs_toolchain_extension = use_extension("@bazel_winlibs//:rules.bzl", "winlibs_toolchain_extension", dev_dependency = True)
inject_repo(winlibs_toolchain_extension, "platforms", "bazel_utilities")
winlibs_toolchain_extension.winlibs_toolchain(
    name = "winlibs",
    copts = [],
)
use_repo(winlibs_toolchain_extension, "winlibs")
register_toolchains("@winlibs//:gcc-toolchain")
# register_toolchains("@winlibs//:clang-toolchain")
```
It provide two toolchains `@<repo>//:gcc-toolchain` / `@<repo>//:clang-toolchain`.
You can use these toolchains to compile any cc_rules in your project.
