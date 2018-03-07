# artifactory::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::install
class artifactory::install (
    Artifactory::PackageName
            $package_name           = $artifactory::params::package_name,
    Artifactory::Version
            $version                = $artifactory::version,
    Boolean $manage_package         = $artifactory::manage_package,
    Boolean $java_manage            = $artifactory::java_manage,
    Boolean $oracle_java            = $artifactory::oracle_java,
    Lsys::Java8Major
            $java_version_major     = $artifactory::java_version_major,
    Lsys::Java8Minor
            $java_version_minor     = $artifactory::java_version_minor,
    String  $java_url_hash          = $artifactory::java_url_hash,
    Array[String]
            $prerequired_packages   = $artifactory::prerequired_packages,
) inherits artifactory::params
{
    if $manage_package {
        # Java
        if $java_manage {
            if $oracle_java {
                class { 'java':
                    package   => $artifactory::params::oracle_java_package,
                    java_home => $artifactory::params::oracle_java_home,
                }
                java::oracle { 'jdk-1.8':
                    version_major => $java_version_major,
                    version_minor => $java_version_minor,
                    url_hash      => $java_url_hash,
                }
                # by including class java we expect Package[java] resource but
                # actually it managed by Java::Oracle resource
                Java::Oracle['jdk-1.8'] -> Package <| title == 'java' |>
            }
            else {
                class { 'java': }
            }
        }

        $prerequired_packages.each |String $reqp| {
            package { $reqp:
                ensure => installed,
            }
        }

        package { 'artifactory':
            ensure   => $version,
            name     => $package_name,
        }
    }
}
