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
    String  $repo_location,
    Array[String]
            $prerequired_packages,
    Boolean $manage_os_users,
    String  $artifactory_user,
    String  $artifactory_group,
    Boolean $manage_service,
    Artifactory::Ensure
            $service_ensure,
    String  $service_name,
    Boolean $service_hasstatus,
    Boolean $service_hasrestart,
    Optional[String]
            $service_ovverides_config,
    Optional[String]
            $service_overrides_template,
    Optional[String]
            $service_config,
    Optional[String]
            $service_config_template,
    Optional[String]
            $storage_config,
    Optional[String]
            $storage_config_template,
    String  $artifactory_home,
    String  $artifactory_pid,
    String  $tomcat_home,
    Optional[String]
            $java_vm_flavor,
    Optional[Artifactory::JavaSize]
            $java_xms,
    Optional[Artifactory::JavaSize]
            $java_xmx,
    Optional[Artifactory::JavaSize]
            $java_xss,
    Optional[Boolean]
            $java_use_g1gc,
    Optional[Boolean]
            $java_oom_exit,
    Integer $catalina_mgmt_port,
)
{
  contain 'artifactory::repos'
  contain 'artifactory::install'
  contain 'artifactory::config'
  contain 'artifactory::service'

  Class['artifactory::repos'] -> Class['artifactory::install'] -> Class['artifactory::config'] ~> Class['artifactory::service']
}