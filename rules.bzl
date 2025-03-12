""

load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_utilities//toolchains:extras_filegroups.bzl", "filegroup_translate_to_starlark")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx", "split_host_name", "HOST_EXTENSION")
load("@bazel_utilities//toolchains:registry.bzl", "get_archive_from_registry")
load("//registry:registry.bzl", "ARM_REGISTRY")

def _arm_compiler_archive_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)
    
    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, rctx.attr.toolchain_type, rctx.attr.toolchain_version)

    # Theses should be deleted
    thumb_abi_version_folder_path = rctx.attr.thumb_abi_version_folder_path
    if thumb_abi_version_folder_path.startswith("/") == False:
        thumb_abi_version_folder_path = "/" + thumb_abi_version_folder_path
    use_ilp32_folder = ""
    if rctx.attr.use_ilp32_folder == True:
        use_ilp32_folder = "/ilp32"

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": "external/{}/".format(rctx.name),
        "%{extension}": HOST_EXTENSION[host_os],
        "%{host_name}": host_name,
        "%{toolchain_type}": rctx.attr.toolchain_type,
        "%{toolchain_version}": rctx.attr.toolchain_version,
        "%{compiler_version}": archive["details"]["compiler_version"],

        # Theses should be deleted
        "%{thumb_abi_version_folder_path}": thumb_abi_version_folder_path,
        "%{use_ilp32_folder}": use_ilp32_folder,
    }
    rctx.template(
        "BUILD.bazel",
        Label("//templates/{toolchain_type}:BUILD.compiler.bazel.tpl".format(toolchain_type = rctx.attr.toolchain_type)),
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

        # Theses should be deleted
        'thumb_abi_version_folder_path': attr.string(default = ""),
        'use_ilp32_folder': attr.bool(default = False),
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

    # Theses should be deleted
    thumb_abi_version_folder_path = rctx.attr.thumb_abi_version_folder_path
    if thumb_abi_version_folder_path.startswith("/") == False:
        thumb_abi_version_folder_path = "/" + thumb_abi_version_folder_path
    use_ilp32_folder = ""
    if rctx.attr.use_ilp32_folder == True:
        use_ilp32_folder = "/ilp32"

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

        # Theses should be deleted
        "%{add_toolchain_linkdirs}": json.encode(rctx.attr.add_toolchain_linkdirs),
        "%{thumb_abi_version_folder_path}": thumb_abi_version_folder_path,
        "%{use_ilp32_folder}": use_ilp32_folder,

        "%{exec_compatible_with}": json.encode(rctx.attr.exec_compatible_with),
        "%{target_compatible_with}": json.encode(rctx.attr.target_compatible_with),

        "%{copts}": json.encode(rctx.attr.copts),
        "%{conlyopts}": json.encode(rctx.attr.conlyopts),
        "%{cxxopts}": json.encode(rctx.attr.cxxopts),
        "%{linkopts}": json.encode(rctx.attr.linkopts),
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
        Label("//templates/{toolchain_type}:BUILD.bazel.tpl".format(toolchain_type = rctx.attr.toolchain_type)),
        substitutions
    )
    rctx.template(
        "rules.bzl",
        Label("//templates/{toolchain_type}:rules.bzl.tpl".format(toolchain_type = rctx.attr.toolchain_type)),
        substitutions
    )
    rctx.template(
        "vscode.bzl",
        Label("//templates/{toolchain_type}:vscode.bzl.tpl".format(toolchain_type = rctx.attr.toolchain_type)),
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

_arm_toolchain = repository_rule(
    implementation = _arm_toolchain_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'toolchain_type': attr.string(mandatory = True),
        'toolchain_version': attr.string(default = "latest"),

        'registry_json': attr.string(mandatory = True),

        # Theses should be deleted
        'add_toolchain_linkdirs': attr.bool(default = False),
        'thumb_abi_version_folder_path': attr.string(default = ""),
        'use_ilp32_folder': attr.bool(default = False),

        'exec_compatible_with': attr.string_list(default = []),
        'target_compatible_with': attr.string_list(default = []),

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

        'toolchain_extras_filegroups': attr.label_list(default = []),

        'compiler_archive_package': attr.label(default = None),
    },
)

def arm_toolchain(
        name,
        toolchain_type,
        toolchain_version = "latest",

        # Theses should be deleted
        add_toolchain_linkdirs = False,
        thumb_abi_version_folder_path = "",
        use_ilp32_folder = False,

        exec_compatible_with = [],
        target_compatible_with = [],

        copts = [],
        conlyopts = [],
        cxxopts = [],
        linkopts = [],
        defines = [],
        includedirs = [],
        linkdirs = [],
        linklibs = [],
        # dbg / opt
        dbg_copts = [],
        dbg_linkopts = [],
        opt_copts = [],
        opt_linkopts = [],

        specs = [],

        toolchain_extras_filegroups = [],
        
        registry = ARM_REGISTRY,

        compiler_archive_package = None,

        override_host_name = "local",
    ):
    """arm Toolchain

    This macro create a repository containing all files needded to get an hermetic toolchain

    Args:
        name: Name of the repo that will be created
        toolchain_type: The arm type to use, avaible: [ arm-none-eabi ]
        toolchain_version: The arm archive version

        # Theses should be deleted
        add_toolchain_linkdirs: If the toolchain linkdirs are added to the compile command (aka: -L...). This shown some issue: when this is enable stm32 won't boot (TODO)
        thumb_abi_version_folder_path: (arm-none-eabi only) The thumb folder to use for using the right arm version / float abi. It has to contain the full path from the gcc version to the libs/includes folders
            examples:
                - thumb/nofp
                - thumb/v7e-m+dp/hard
                - thumb/v7e-m+dp/softfp
                - ...
        use_ilp32_folder: (aarch64-none-elf only) Force the use of the ilp32 libs/includes folder

        exec_compatible_with: The target_compatible_with list for the toolchain
        target_compatible_with: The target_compatible_with list for the toolchain

        copts: copts
        conlyopts: conlyopts
        cxxopts: cxxopts
        linkopts: linkopts
        defines: defines
        includedirs: includedirs
        linkdirs: linkdirs
        # dbg / opt
        linklibs: linklibs
        dbg_copts: dbg_copts
        dbg_linkopts: dbg_linkopts
        opt_copts: opt_copts
        opt_linkopts: opt_linkopts

        specs: specs for the compiler (nano, nosys, ...)
        
        toolchain_extras_filegroups: filegroup added to the cc_toolchain rule to get access to thoses files when sandboxed

        registry: The arm registry to use, to allow close environement to provide their own mirroir/url

        compiler_archive_package: The arm archive to use. If none are provided, one will be defined automatically

        override_host_name: override_host_name
    """
    if registry == None:
        registry = ARM_REGISTRY

    linkopts = linkopts + [ "--specs={}.specs".format(spec) for spec in specs ]

    _arm_toolchain(
        name = name,
        toolchain_type = toolchain_type,
        toolchain_version = toolchain_version,

        registry_json = json.encode(registry),

        # Theses should be deleted
        add_toolchain_linkdirs = add_toolchain_linkdirs,
        thumb_abi_version_folder_path = thumb_abi_version_folder_path,
        use_ilp32_folder = use_ilp32_folder,

        exec_compatible_with = exec_compatible_with,
        target_compatible_with = target_compatible_with,

        copts = copts,
        conlyopts = conlyopts,
        cxxopts = cxxopts,
        linkopts = linkopts,
        defines = defines,
        includedirs = includedirs,
        linkdirs = linkdirs,
        linklibs = linklibs,
        # dbg / opt
        dbg_copts = dbg_copts,
        dbg_linkopts = dbg_linkopts,
        opt_copts = opt_copts,
        opt_linkopts = opt_linkopts,

        toolchain_extras_filegroups = toolchain_extras_filegroups,

        compiler_archive_package = compiler_archive_package,

        override_host_name = override_host_name,
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
            registry_json = json.encode(ARM_REGISTRY),
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

                # Theses should be deleted
                add_toolchain_linkdirs = toolchain.add_toolchain_linkdirs,
                thumb_abi_version_folder_path = toolchain.thumb_abi_version_folder_path,
                use_ilp32_folder = toolchain.use_ilp32_folder,

                exec_compatible_with = toolchain.exec_compatible_with,
                target_compatible_with = toolchain.target_compatible_with,

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

            # Theses should be deleted
            'add_toolchain_linkdirs': attr.bool(default = False),
            'thumb_abi_version_folder_path': attr.string(default = ""),
            'use_ilp32_folder': attr.bool(default = False),

            'exec_compatible_with': attr.string_list(default = []),
            'target_compatible_with': attr.string_list(default = []),

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
