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
)
{
  contain 'artifactory::repos'
  contain 'artifactory::install'
  contain 'artifactory::config'
  contain 'artifactory::service'

  Class['artifactory::repos'] -> Class['artifactory::install'] -> Class['artifactory::config'] ~> Class['artifactory::service']
}