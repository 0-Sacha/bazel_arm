""

load("@rules_cc//cc:defs.bzl", "cc_binary")

def _arm_all_files_impl(ctx):
    # print("Copy '{}' to '{}'".format(ctx.file.dep, ctx.outputs.elf)) # buildifier: disable=print
    ctx.actions.run(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.elf ],
        executable = "cp",
        arguments = [
            ctx.file.dep.path,
            ctx.outputs.elf.path
        ],
    )

    # print("Create bin file '{}' from '{}'".format(ctx.outputs.bin, ctx.file.dep)) # buildifier: disable=print
    ctx.actions.run(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.bin ],
        tools = [ ctx.file.objcopy ],
        executable = ctx.file.objcopy.path,
        arguments = [
            "-O",
            "binary",
            "-S",
            ctx.file.dep.path,
            ctx.outputs.bin.path
        ],
    )

    # print("Create hex file '{}' from '{}'".format(ctx.outputs.hex, ctx.file.dep)) # buildifier: disable=print
    ctx.actions.run(
        inputs = [ ctx.file.dep ],
        outputs = [ ctx.outputs.hex ],
        tools = [ ctx.file.objcopy ],
        executable = ctx.file.objcopy.path,
        arguments = [
            "-O",
            "ihex",
            ctx.file.dep.path,
            ctx.outputs.hex.path
        ],
    )
    
    return [
        DebugPackageInfo(
            target_label = ctx.attr.dep.label,
            unstripped_file = ctx.outputs.elf,
        ),
        OutputGroupInfo(
            binary = depset([ctx.outputs.elf]),
            bin = depset([ctx.outputs.bin]),
            hex = depset([ctx.outputs.hex]),
        )
    ]

arm_all_files = rule(
    implementation = _arm_all_files_impl,
    attrs = {
        'objcopy': attr.label(allow_single_file = True),
        "dep": attr.label(allow_single_file = True),
        "elf": attr.output(),
        "bin": attr.output(),
        "hex": attr.output(),
    },
    provides = [DebugPackageInfo, OutputGroupInfo],
)

def arm_binary(name, arm_file_elf = None, arm_file_bin = None, arm_file_hex = None, **kwargs):
    """arm_binary macro

    Args:
        name: The dep name
        arm_file_elf: The output elf file name
        arm_file_bin: The output bin file name
        arm_file_hex: The output hex file name
        **kwargs: All others cc_binary attributes
    """
    binary_rule_name = "{}_raw_binary".format(name)
    cc_binary(name = binary_rule_name, **kwargs)
    arm_all_files(
        name = name,
        objcopy = "@%{rctx_name}//:objcopy",
        dep = ":{}".format(binary_rule_name),
        elf = "{}.elf".format(name) if arm_file_elf == None else arm_file_elf,
        bin = "{}.bin".format(name) if arm_file_bin == None else arm_file_bin,
        hex = "{}.hex".format(name) if arm_file_hex == None else arm_file_hex
    )
