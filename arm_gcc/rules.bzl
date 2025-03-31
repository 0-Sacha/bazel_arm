""

load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_utilities//toolchains:extras_filegroups.bzl", "filegroup_translate_to_starlark")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx", "split_host_name", "HOST_EXTENSION")
load("@bazel_utilities//toolchains:registry.bzl", "get_archive_from_registry")
load("//arm_gcc/registry:registry.bzl", "ARM_GCC_REGISTRY")

def _arm_compiler_archive_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)
    
    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, rctx.attr.toolchain_type, rctx.attr.toolchain_version)

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": "external/{}/".format(rctx.name),
        "%{extension}": HOST_EXTENSION[host_os],
        "%{host_name}": host_name,
        "%{toolchain_type}": rctx.attr.toolchain_type,
        "%{toolchain_version}": rctx.attr.toolchain_version,
        "%{compiler_version}": archive["details"]["compiler_version"],
    }
    rctx.template(
        "BUILD.bazel",
        Label("//arm_gcc/templates:BUILD.compiler.bazel.tpl"),
        substitutions
    )
    
    host_archive = archive["archives"][host_name]
    strip_prefix = ""
    if "strip_prefix" in host_archive:
        strip_prefix = host_archive["strip_prefix"]
    rctx.download_and_extract(
        url = host_archive["url"],
        sha256 = host_archive["sha256"],
        stripPrefix = strip_prefix,
    )

arm_compiler_archive = repository_rule(
    implementation = _arm_compiler_archive_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'toolchain_type': attr.string(mandatory = True),
        'toolchain_version': attr.string(default = "latest"),
        'registry_json': attr.string(mandatory = True),
    },
)

def _arm_toolchain_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)

    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, rctx.attr.toolchain_type, rctx.attr.toolchain_version)

    toolchain_id = "{}_{}".format(rctx.attr.toolchain_type, archive["details"]["compiler_version"])

    toolchain_path = "external/{}/".format(rctx.name)
    compiler_package = ""
    compiler_full_package = "@@{}//".format(rctx.name)
    compiler_package_path = toolchain_path
    if rctx.attr.compiler_archive_package != None and rctx.attr.compiler_archive_package != "":
        compiler_package = "@@{}//".format(rctx.attr.compiler_archive_package.repo_name)
        compiler_full_package = compiler_package
        compiler_package_path = rctx.attr.compiler_archive_package.workspace_root + "/"

    linkopts = rctx.attr.linkopts + [ "--specs={}.specs".format(spec) for spec in rctx.attr.specs ]

    substitutions = {
        "%{name}": rctx.name,
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": toolchain_path,
        "%{extension}": HOST_EXTENSION[host_os],
        "%{host_name}": host_name,
        "%{toolchain_id}": toolchain_id,
        "%{toolchain_type}": rctx.attr.toolchain_type,
        "%{toolchain_version}": rctx.attr.toolchain_version,
        "%{compiler_version}": archive["details"]["compiler_version"],
        "%{compiler_package}": compiler_package,
        "%{compiler_full_package}": compiler_full_package,
        "%{compiler_package_path}": compiler_package_path,

        "%{exec_compatible_with}": json.encode(rctx.attr.exec_compatible_with),
        "%{target_compatible_with}": json.encode(rctx.attr.target_compatible_with),

        "%{toolchain_builtin_includedirs_isystem}": json.encode(rctx.attr.toolchain_builtin_includedirs_isystem),
        "%{toolchain_builtin_includedirs}": json.encode(rctx.attr.toolchain_builtin_includedirs),

        "%{copts}": json.encode(rctx.attr.copts),
        "%{conlyopts}": json.encode(rctx.attr.conlyopts),
        "%{cxxopts}": json.encode(rctx.attr.cxxopts),
        "%{linkopts}": json.encode(linkopts),
        "%{defines}": json.encode(rctx.attr.defines),
        "%{includedirs}": json.encode(rctx.attr.includedirs),
        "%{linkdirs}": json.encode(rctx.attr.linkdirs),
        "%{linklibs}": json.encode(rctx.attr.linklibs),
        # dbg / opt
        "%{dbg_copts}": json.encode(rctx.attr.dbg_copts),
        "%{dbg_linkopts}": json.encode(rctx.attr.dbg_linkopts),
        "%{opt_copts}": json.encode(rctx.attr.opt_copts),
        "%{opt_linkopts}": json.encode(rctx.attr.opt_linkopts),

        "%{toolchain_extras_filegroups}": json.encode(filegroup_translate_to_starlark(rctx.attr.toolchain_extras_filegroups)),
    }
    rctx.template(
        "BUILD.bazel",
        Label("//arm_gcc/templates:BUILD.bazel.tpl"),
        substitutions
    )
    rctx.template(
        "rules.bzl",
        Label("//arm_gcc/templates:rules.bzl.tpl"),
        substitutions
    )
    rctx.template(
        "vscode.bzl",
        Label("//arm_gcc/templates:vscode.bzl.tpl"),
        substitutions
    )

    if rctx.attr.compiler_archive_package == None or rctx.attr.compiler_archive_package == "":
        host_archive = archive["archives"][host_name]
        strip_prefix = ""
        if "strip_prefix" in host_archive:
            strip_prefix = host_archive["strip_prefix"]
        rctx.download_and_extract(
            url = host_archive["url"],
            sha256 = host_archive["sha256"],
            stripPrefix = strip_prefix,
        )

arm_toolchain = repository_rule(
    implementation = _arm_toolchain_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'toolchain_type': attr.string(mandatory = True),
        'toolchain_version': attr.string(default = "latest"),

        'registry_json': attr.string(default = json.encode(ARM_GCC_REGISTRY)),

        'exec_compatible_with': attr.string_list(default = []),
        'target_compatible_with': attr.string_list(default = []),

        'toolchain_builtin_includedirs_isystem': attr.string_list(default = []),
        'toolchain_builtin_includedirs': attr.string_list(default = []),

        'copts': attr.string_list(default = []),
        'conlyopts': attr.string_list(default = []),
        'cxxopts': attr.string_list(default = []),
        'linkopts': attr.string_list(default = []),
        'defines': attr.string_list(default = []),
        'includedirs': attr.string_list(default = []),
        'linkdirs': attr.string_list(default = []),
        'linklibs': attr.string_list(default = []),
        'specs': attr.string_list(default = []),
        # dbg / opt
        'dbg_copts': attr.string_list(default = []),
        'dbg_linkopts': attr.string_list(default = []),
        'opt_copts': attr.string_list(default = []),
        'opt_linkopts': attr.string_list(default = []),

        'toolchain_extras_filegroups': attr.label_list(default = []),

        'compiler_archive_package': attr.label(default = None),
    },
)

def _arm_toolchain_extension_impl(module_ctx):
    toolchain_versions_list = [
        (toolchain.override_host_name, toolchain.toolchain_type, toolchain.toolchain_version)
        for mod in module_ctx.modules 
        for toolchain in mod.tags.arm_toolchain
    ]
    if len(toolchain_versions_list) == 0:
        print("Should not end here ! You probably forgotten to put a mandatory argument to the arm_toolchain rule <maybe toolchain_type>")
    toolchain_versions_list = sets.to_list(sets.make(toolchain_versions_list))

    for toolchain_version in toolchain_versions_list:
        arm_compiler_archive(
            name = "archive_arm-{}-{}-{}".format(toolchain_version[0], toolchain_version[1], toolchain_version[2]),
            toolchain_type = toolchain_version[1],
            toolchain_version = toolchain_version[2],
            registry_json = json.encode(ARM_GCC_REGISTRY),
            override_host_name = toolchain_version[0],

            # thmub and ilp32 folder are not handled here...
            # should not be an issue since they are handled using -I and -L
        )
    
    for mod in module_ctx.modules:
        for toolchain in mod.tags.arm_toolchain:
            arm_toolchain(
                name = toolchain.name,
                toolchain_type = toolchain.toolchain_type,
                toolchain_version = toolchain.toolchain_version,

                exec_compatible_with = toolchain.exec_compatible_with,
                target_compatible_with = toolchain.target_compatible_with,

                toolchain_builtin_includedirs_isystem = toolchain.toolchain_builtin_includedirs_isystem,
                toolchain_builtin_includedirs = toolchain.toolchain_builtin_includedirs,

                copts = toolchain.copts,
                conlyopts = toolchain.conlyopts,
                cxxopts = toolchain.cxxopts,
                linkopts = toolchain.linkopts,
                defines = toolchain.defines,
                includedirs = toolchain.includedirs,
                linkdirs = toolchain.linkdirs,
                linklibs = toolchain.linklibs,

                specs = toolchain.specs,

                toolchain_extras_filegroups = toolchain.toolchain_extras_filegroups,

                compiler_archive_package = "@archive_arm-{}-{}-{}".format(toolchain.override_host_name, toolchain.toolchain_type, toolchain.toolchain_version),

                override_host_name = toolchain.override_host_name,
            )
    
arm_toolchain_extension = module_extension(
    implementation = _arm_toolchain_extension_impl,
    tag_classes = {
        "arm_toolchain": tag_class(attrs = {
            'override_host_name': attr.string(default = "local"),

            'name': attr.string(mandatory = True),
            
            'toolchain_type': attr.string(mandatory = True),
            'toolchain_version': attr.string(default = "latest"),

            'compiler_archive_package': attr.label(default = None),

            'exec_compatible_with': attr.string_list(default = []),
            'target_compatible_with': attr.string_list(default = []),

            'toolchain_builtin_includedirs_isystem': attr.string_list(default = []),
            'toolchain_builtin_includedirs': attr.string_list(default = []),

            'copts': attr.string_list(default = []),
            'conlyopts': attr.string_list(default = []),
            'cxxopts': attr.string_list(default = []),
            'linkopts': attr.string_list(default = []),
            'defines': attr.string_list(default = []),
            'includedirs': attr.string_list(default = []),
            'linkdirs': attr.string_list(default = []),
            'linklibs': attr.string_list(default = []),
            # dbg / opt
            'dbg_copts': attr.string_list(default = []),
            'dbg_linkopts': attr.string_list(default = []),
            'opt_copts': attr.string_list(default = []),
            'opt_linkopts': attr.string_list(default = []),

            'specs': attr.string_list(default = []),

            'toolchain_extras_filegroups': attr.label_list(default = []),
        }),
    },
)
