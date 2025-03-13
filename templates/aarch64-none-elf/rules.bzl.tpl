""

load("@rules_cc//cc:defs.bzl", "cc_binary")

def _arm_all_files_impl(ctx):
    ctx.actions.run_shell(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.elf ],
        command = "cp {dep} {elf}".format(
            dep = ctx.file.dep.path,
            elf = ctx.outputs.elf.path,
        ),
    )
    ctx.actions.run(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.bin ],
        executable = ctx.file.objcopy,
        arguments = [
            "-O",
            "binary",
            # TODO: check for --strip: "-S",
            ctx.file.dep.path,
            ctx.outputs.bin.path
        ],
    )
    ctx.actions.run(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.hex ],
        executable = ctx.file.objcopy,
        arguments = [
            "-O",
            "ihex",
            ctx.file.dep.path,
            ctx.outputs.hex.path
        ],
    )
    ctx.actions.run_shell(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.dmp ],
        tools = [ ctx.file.objdump ],
        command = "{objdump} {flags} {deps} > {out}".format(
            objdump = ctx.file.objdump.path,
            flags = "-x --syms",
            deps = ctx.file.dep.path,
            out = ctx.outputs.dmp.path,
        ),
    )
    ctx.actions.run_shell(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.asm ],
        tools = [ ctx.file.objdump ],
        command = "{objdump} {flags} {deps} > {out}".format(
            objdump = ctx.file.objdump.path,
            flags = "-d",
            deps = ctx.file.dep.path,
            out = ctx.outputs.asm.path,
        ),
    )
    
    return [
        DebugPackageInfo(
            target_label = ctx.attr.dep.label,
            unstripped_file = ctx.outputs.elf,
        ),
        OutputGroupInfo(
            elf = depset([ctx.outputs.elf]),
            bin = depset([ctx.outputs.bin]),
            hex = depset([ctx.outputs.hex]),
            dmp = depset([ctx.outputs.dmp]),
            asm = depset([ctx.outputs.asm]),
        )
    ]

arm_all_files = rule(
    implementation = _arm_all_files_impl,
    attrs = {
        'objcopy': attr.label(allow_single_file = True),
        'objdump': attr.label(allow_single_file = True),
        "dep": attr.label(allow_single_file = True),
        "elf": attr.output(),
        "bin": attr.output(),
        "hex": attr.output(),
        "dmp": attr.output(),
        "asm": attr.output(),
    },
    provides = [DebugPackageInfo, OutputGroupInfo],
)

def arm_binary(
        name,
        arm_file_elf = None,
        arm_file_bin = None,
        arm_file_hex = None,
        arm_file_dmp = None,
        arm_file_asm = None,
        **kwargs
    ):
    """arm_binary macro

    Args:
        name: The dep name
        arm_file_elf: The output elf file name
        arm_file_bin: The output bin file name
        arm_file_hex: The output hex file name
        arm_file_dmp: The output hex file name
        arm_file_asm: The output hex file name
        **kwargs: All others cc_binary attributes
    """
    binary_rule_name = "{}_raw_binary".format(name)
    cc_binary(name = binary_rule_name, **kwargs)
    arm_all_files(
        name = name,
        objcopy = "%{compiler_full_package}:objcopy",
        objdump = "%{compiler_full_package}:objdump",
        dep = ":{}".format(binary_rule_name),
        elf = "{}.elf".format(name) if arm_file_elf == None else arm_file_elf,
        bin = "{}.bin".format(name) if arm_file_bin == None else arm_file_bin,
        hex = "{}.hex".format(name) if arm_file_hex == None else arm_file_hex,
        dmp = "{}.dmp".format(name) if arm_file_dmp == None else arm_file_dmp,
        asm = "{}.asm".format(name) if arm_file_asm == None else arm_file_asm,
    )
