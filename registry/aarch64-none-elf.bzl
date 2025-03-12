
ARM_NONE_ELF_ARCHIVES_14_2_REL1 = {
    "toolchain": "aarch64-none-elf",
    "version": "14.2.rel1",
    "version-short": "14.2",
    "latest": True,
    "details": {
        "compiler_version": "14.2.1",
        "build_file": "compiler.BUILD_arm"
    },
    "archives": {
        "windows_x86_64": {
            "url": "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-aarch64-none-elf.zip",
            "sha256": "8C395A36849877D2F005FB1AC8C3611206F2F7930F15ADFE95A21DD7969CA001",
        },
        "linux_x86_64": {
            "url": "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-elf.tar.xz",
            "sha256": "EB54C4727440D03199A6AF9A6D021E77F45410CAD39EFFCE4E5A1C10A88B7F04",
            "strip_prefix": "arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-elf",
        },
        "linux_aarch64": {
            "url": "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-aarch64-aarch64-none-elf.tar.xz",
            "sha256": "C4F0DAAB43F78E0D56EC2BDAD76B98A0223CE12CE7FC51A6CE82F9CC6C6DFBA0",
            "strip_prefix": "arm-gnu-toolchain-14.2.rel1-aarch64-aarch64-none-elf",
        },
        "darwin_x86_64": {
            "url": "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-darwin-x86_64-aarch64-none-elf.tar.xz",
            "sha256": "C02735606D69ED000CC8FAE2C1467E489E1325C14A7874F553C42F7EF193FC21",
            "strip_prefix": "arm-gnu-toolchain-14.2.rel1-darwin-x86_64-aarch64-none-elf",
        },
        "darwin_aarch64": {
            "url": "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-darwin-arm64-aarch64-none-elf.tar.xz",
            "sha256": "FC111BB4BB4871E521E3C8A89BD0AF51CDDFD00FE3F526F4FAA09398B7C613F5",
            "strip_prefix": "arm-gnu-toolchain-14.2.rel1-darwin-arm64-aarch64-none-elf",
        }
    }
}
