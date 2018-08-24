# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::config::database
class artifactory::config::database (
    String  $artifactory_user  = $artifactory::artifactory_user,
    Boolean $use_postgres      = $artifactory::use_postgres,
    String  $database_host     = $artifactory::database_host,
    Lsys::Numerical
            $database_port     = $artifactory::database_port,
    String  $database_name     = $artifactory::database_database,
    String  $database_username = $artifactory::database_username,
    String  $database_password = $artifactory::database_password,
    String  $artifactory_home  = $artifactory::params::artifactory_home,
) inherits artifactory::params
{
    include artifactory::config

    if $use_postgres {
        file { "${artifactory_home}/etc/db.properties":
            owner => $artifactory_user,
            content => template('artifactory/postgresql.properties.erb'),
        }
    }
}
