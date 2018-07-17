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
    Array[String]
            $prerequired_packages   = $artifactory::prerequired_packages,
) inherits artifactory::params
{
    if $manage_package {
        # Java
        if $java_manage {
            if $oracle_java {
                include javalocal
                include javalocal::java8
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

        package { $package_name:
            ensure => $version,
            alias  => 'artifactory',
        }
    }
}
