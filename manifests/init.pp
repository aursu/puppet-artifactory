# artifactory
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory
class artifactory (
    Artifactory::Version
            $version,
    Boolean $manage_package,
    Array[String]
            $prerequired_packages,
    Boolean $manage_os_users,
    String  $artifactory_user,
    String  $artifactory_group,
    Boolean $manage_service,
    Lsys::SrvEnsure
            $service_ensure,
    Boolean $service_enable,
    String  $service_name,
    String  $service_systemd_template,
    String  $service_config,
    String  $service_config_template,
    String  $service_setenv_template,
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
    Lsys::Java8Minor
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
