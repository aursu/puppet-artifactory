# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::config::database
class artifactory::config::database (
    Enum['absent', 'present']
            $artifactory_ensure = $artifactory::ensure,
    String  $artifactory_user   = $artifactory::artifactory_user,
    Boolean $use_postgres       = $artifactory::use_postgres,
    String  $database_host      = $artifactory::database_host,
    Lsys::Numerical
            $database_port      = $artifactory::database_port,
    String  $database_name      = $artifactory::database_database,
    String  $database_username  = $artifactory::database_username,
    String  $database_password  = $artifactory::database_password,
    Boolean $manage_jdbc_driver = $artifactory::manage_jdbc_driver,
    String  $artifactory_home   = $artifactory::params::artifactory_home,
) inherits artifactory::params
{
    include artifactory::config

    if $use_postgres {
        file { "${artifactory_home}/etc/db.properties":
            ensure  => $artifactory_ensure,
            owner   => $artifactory_user,
            content => template('artifactory/postgresql.properties.erb'),
        }
        if $manage_jdbc_driver {
            class { 'postgresql::lib::java':
                package_ensure => $artifactory_ensure,
                package_name   => 'postgresql-jdbc',
            }
            if $artifactory_ensure == 'present' {
                Class['postgresql::lib::java'] -> File['artifactory-jdbc']
            }
        }
        if $artifactory_ensure == 'present' {
            file { "${artifactory_home}/tomcat/lib/postgresql-jdbc.jar":
                ensure => 'link',
                target => '/usr/share/java/postgresql-jdbc.jar',
                alias  => 'artifactory-jdbc',
            }
        }
    }
}
