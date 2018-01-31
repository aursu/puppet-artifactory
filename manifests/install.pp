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
            $package_name       = $artifactory::package_name,
    Artifactory::Version
            $version            = $artifactory::version,
    Boolean $manage_package     = $artifactory::manage_package,
    Boolean $java_manage        = $artifactory::java_manage,
    Boolean $oracle_java        = $artifactory::oracle_java,
    Artifactory::JavaMajor
            $java_version_major = $artifactory::java_version_major,
    Artifactory::JavaMinor
            $java_version_minor = $artifactory::java_version_minor,
    String  $java_url_hash      = $artifactory::java_url_hash,
)
{
    if $manage_package {
        # Java
        if $java_manage {
            if $oracle_java {
                class { 'java':
                    package => 'jdk1.8',
                    java_home => '/usr/java/default'
                }
                java::oracle { 'jdk-1.8':
                    version_major => $java_version_major,
                    version_minor => $java_version_minor,
                    url_hash      => $java_url_hash,
                }
                # by including class java we expect Package[java] resource but
                # actually it managed by Java::Oracle resource
                Java::Oracle['jdk-1.8'] -> Package <| name == 'java' |>
            }
            else {
                class { 'java': }
            }
        }

        package { 'artifactory':
            ensure   => $version,
            name     => $package_name,
        }
    }
}
