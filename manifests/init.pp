# artifactory
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory
class artifactory (
    Artifactory::PackageName
            $package_name,
    Artifactory::Version
            $version,
    Boolean $manage_package,
    Array[String]
            $prerequired_packages,
    Boolean $manage_os_users,
    String  $artifactory_user,
    String  $artifactory_group,
    Boolean $manage_service,
    Artifactory::Ensure
            $service_ensure,
    String  $service_name,
    String  $service_systemd_template,
    Optional[String]
            $service_config,
    Optional[String]
            $service_config_template,
    Optional[String]
            $java_vm_flavor,
    Optional[Lsys::JavaSize]
            $java_xms,
    Optional[LSys::JavaSize]
            $java_xmx,
    Optional[Lsys::JavaSize]
            $java_xss,
    Optional[Boolean]
            $java_use_g1gc,
    Optional[Boolean]
            $java_oom_exit,
    Integer $catalina_mgmt_port,
    Boolean $java_manage,
    Boolean $oracle_java,
    Lsys::Java8Major
            $java_version_major,
    Lsys::JavaMinor
            $java_version_minor,
    String  $java_url_hash,
    Optional[Lsys::RLimit]
            $nofile_rlimit,
    Optional[Lsys::RLimit]
            $nproc_rlimit,
)
{
  contain 'artifactory::repos'
  contain 'artifactory::install'
  contain 'artifactory::config'
  contain 'artifactory::service'

  Class['artifactory::repos'] -> Class['artifactory::install'] -> Class['artifactory::config'] ~> Class['artifactory::service']
}
