load("@bazel_utilities//toolchains:registry.bzl", "gen_archives_registry")


load(":arm-none-eabi.bzl",
    "ARM_NONE_EABI_ARCHIVES_14_2_REL1",
    "ARM_NONE_EABI_ARCHIVES_13_3_REL1",
    "ARM_NONE_EABI_ARCHIVES_13_2_REL1",
    "ARM_NONE_EABI_ARCHIVES_12_3_REL1",
    "ARM_NONE_EABI_ARCHIVES_11_3_REL1",
)

load(":aarch64-none-elf.bzl",
    "ARM_NONE_ELF_ARCHIVES_14_2_REL1",
)


ARM_REGISTRY = gen_archives_registry([
    ARM_NONE_ELF_ARCHIVES_14_2_REL1,

    ARM_NONE_EABI_ARCHIVES_14_2_REL1,
    ARM_NONE_EABI_ARCHIVES_13_3_REL1,
    ARM_NONE_EABI_ARCHIVES_13_2_REL1,
    ARM_NONE_EABI_ARCHIVES_12_3_REL1,
    ARM_NONE_EABI_ARCHIVES_11_3_REL1
])
