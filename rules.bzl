""

load("@bazel_arm//:registry.bzl", "ARM_REGISTRY")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx", "HOST_EXTENTION")
load("@bazel_utilities//toolchains:registry.bzl", "get_archive_from_registry")

def _arm_compiler_archive_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    
    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": "external/{}/".format(rctx.name),
        "%{extention}": HOST_EXTENTION[host_os],
        "%{host_name}": host_name,
        "%{arm_toolchain_type}": rctx.attr.arm_toolchain_type,
        "%{arm_toolchain_version}": rctx.attr.arm_toolchain_version,
        "%{compiler_version}": rctx.attr.compiler_version,
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD.compiler.tpl"),
        substitutions
    )

    archives = json.decode(rctx.attr.archives)
    archive = archives[host_name]

    rctx.download_and_extract(
        url = archive["url"],
        sha256 = archive["sha256"],
        stripPrefix = archive["strip_prefix"],
    )

arm_compiler_archive = repository_rule(
    implementation = _arm_compiler_archive_impl,
    attrs = {
        'arm_toolchain_type': attr.string(mandatory = True),
        'arm_toolchain_version': attr.string(default = "latest"),
        'compiler_version': attr.string(mandatory = True),
        'archives': attr.string(mandatory = True),
    },
    local = False,
)


def _arm_toolchain_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)

    toolchain_id = "{}_{}".format(rctx.attr.arm_toolchain_type, rctx.attr.compiler_version)

    toolchain_path = "external/{}/".format(rctx.name)
    compiler_package = ""
    compiler_package_path = toolchain_path
    if rctx.attr.local_download == False:
        compiler_package = "@{}//".format(rctx.attr.compiler_package_name)
        compiler_package_path = "external/{}/".format(rctx.attr.compiler_package_name)

    toolchain_extras_filegroup = "@{}//{}:{}".format(
        rctx.attr.toolchain_extras_filegroup.repo_name,
        rctx.attr.toolchain_extras_filegroup.package,
        rctx.attr.toolchain_extras_filegroup.name,
    )

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": toolchain_path,
        "%{extention}": HOST_EXTENTION[host_os],
        "%{host_name}": host_name,
        "%{toolchain_id}": toolchain_id,
        "%{arm_toolchain_type}": rctx.attr.arm_toolchain_type,
        "%{arm_toolchain_version}": rctx.attr.arm_toolchain_version,
        "%{compiler_version}": rctx.attr.compiler_version,
        "%{compiler_package}": compiler_package,
        "%{compiler_package_path}": compiler_package_path,

        "%{add_toolchain_linkdirs}": json.encode(rctx.attr.add_toolchain_linkdirs),

        "%{exec_compatible_with}": json.encode(rctx.attr.exec_compatible_with),
        "%{target_compatible_with}": json.encode(rctx.attr.target_compatible_with),

        "%{copts}": json.encode(rctx.attr.copts),
        "%{conlyopts}": json.encode(rctx.attr.conlyopts),
        "%{cxxopts}": json.encode(rctx.attr.cxxopts),
        "%{linkopts}": json.encode(rctx.attr.linkopts),
        "%{defines}": json.encode(rctx.attr.defines),
        "%{includedirs}": json.encode(rctx.attr.includedirs),
        "%{linkdirs}": json.encode(rctx.attr.linkdirs),
        "%{toolchain_libs}": json.encode(rctx.attr.toolchain_libs),

        "%{toolchain_extras_filegroup}": toolchain_extras_filegroup,
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD.tpl"),
        substitutions
    )
    rctx.template(
        "rules.bzl",
        Label("//templates:rules.bzl.tpl"),
        substitutions
    )
    rctx.template(
        "vscode.bzl",
        Label("//templates:vscode.bzl.tpl"),
        substitutions
    )

    archives = json.decode(rctx.attr.archives)
    archive = archives[host_name]

    if rctx.attr.local_download:
        rctx.download_and_extract(
            url = archive["url"],
            sha256 = archive["sha256"],
            stripPrefix = archive["strip_prefix"],
        )

_arm_toolchain = repository_rule(
    implementation = _arm_toolchain_impl,
    attrs = {
        'arm_toolchain_type': attr.string(mandatory = True),
        'arm_toolchain_version': attr.string(default = "latest"),
        'compiler_version': attr.string(mandatory = True),

        'local_download': attr.bool(default = True),
        'archives': attr.string(mandatory = True),
        'compiler_package_name': attr.string(default = "//"),

        'add_toolchain_linkdirs': attr.bool(default = True),

        'exec_compatible_with': attr.string_list(default = []),
        'target_compatible_with': attr.string_list(default = []),

        'copts': attr.string_list(default = []),
        'conlyopts': attr.string_list(default = []),
        'cxxopts': attr.string_list(default = []),
        'linkopts': attr.string_list(default = []),
        'defines': attr.string_list(default = []),
        'includedirs': attr.string_list(default = []),
        'linkdirs': attr.string_list(default = []),
        'toolchain_libs': attr.string_list(default = []),

        'toolchain_extras_filegroup': attr.label(),
    },
    local = False,
)

def arm_toolchain(
        name,
        arm_toolchain_type,
        arm_toolchain_version = "latest",

        exec_compatible_with = [],
        target_compatible_with = [],

        copts = [],
        conlyopts = [],
        cxxopts = [],
        linkopts = [],
        defines = [],
        includedirs = [],
        linkdirs = [],
        toolchain_libs = [],

        toolchain_extras_filegroup = "@bazel_utilities//:empty",
        
        local_download = True,
        registry = ARM_REGISTRY,

        auto_register_toolchain = True,

        add_toolchain_linkdirs = True
    ):
    """arm Toolchain

    This macro create a repository containing all files needded to get an hermetic toolchain

    Args:
        name: Name of the repo that will be created
        arm_toolchain_type: The arm type to use, avaible: [ arm-none-eabi ]
        arm_toolchain_version: The arm archive version

        exec_compatible_with: The target_compatible_with list for the toolchain
        target_compatible_with: The target_compatible_with list for the toolchain

        copts: copts
        conlyopts: conlyopts
        cxxopts: cxxopts
        linkopts: linkopts
        defines: defines
        includedirs: includedirs
        linkdirs: linkdirs
        toolchain_libs: toolchain_libs

        toolchain_extras_filegroup: filegroup added to the cc_toolchain rule to get access to thoses files when sandboxed

        local_download: wether the archive should be downloaded in the same repository (True) or in its own repo
        registry: The arm registry to use, to allow close environement to provide their own mirroir/url

        auto_register_toolchain: If the toolchain is registered to bazel using `register_toolchains

        add_toolchain_linkdirs: If the toolchain linkdirs are added to the compile command (aka: -L...). This shown some issue: when this is enable stm32 won't boot (TODO)
    """
    compiler_package_name = ""

    archive = get_archive_from_registry(registry, arm_toolchain_type, arm_toolchain_version)

    if local_download == False:
        compiler_package_name = "archive_{}_{}".format(arm_toolchain_type, arm_toolchain_version)
        arm_compiler_archive(
            name = compiler_package_name,
            arm_toolchain_type = arm_toolchain_type,
            arm_toolchain_version = arm_toolchain_version,
            compiler_version = archive["details"]["compiler_version"],
            archives = json.encode(archive["archives"]),
        )

    _arm_toolchain(
        name = name,
        arm_toolchain_type = arm_toolchain_type,
        arm_toolchain_version = arm_toolchain_version,
        compiler_version = archive["details"]["compiler_version"],

        local_download = local_download,
        archives = json.encode(archive["archives"]),
        compiler_package_name = compiler_package_name,

        add_toolchain_linkdirs = add_toolchain_linkdirs,

        exec_compatible_with = exec_compatible_with,
        target_compatible_with = target_compatible_with,

        copts = copts,
        conlyopts = conlyopts,
        cxxopts = cxxopts,
        linkopts = linkopts,
        defines = defines,
        includedirs = includedirs,
        linkdirs = linkdirs,
        toolchain_libs = toolchain_libs,

        toolchain_extras_filegroup = toolchain_extras_filegroup,
    )

    if auto_register_toolchain:
        native.register_toolchains("@{}//:toolchain_{}_{}".format(name, arm_toolchain_type, archive["details"]["compiler_version"]))
