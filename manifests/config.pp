# artifactory::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::config
class artifactory::config (
    Boolean $manage_users     = $artifactory::manage_os_users,
    String  $artifactory_user = $artifactory::artifactory_user,
    String  $group            = $artifactory::artifactory_group,
    String  $artifactory_home = $artifactory::params::artifactory_home,
    String  $tomcat_home      = $artifactory::params::tomcat_home,
    String  $tomcat_webapps   = $artifactory::params::tomcat_webapps,
    String  $etc_dir          = $artifactory::params::etc_dir,
    String  $run_dir          = $artifactory::params::run_dir,
) inherits artifactory::params
{
    if $manage_users {
        group { $group:
            ensure => 'present',
            before => User[$artifactory_user]
        }

        user { $artifactory_user:
            ensure     => 'present',
            groups     => [ $group ],
            membership => 'minimum',
        }

        User[$artifactory_user] -> [
            File[$artifactory_home],
            File[$tomcat_home],
            File[$tomcat_webapps]
        ]
        User[$artifactory_user] -> File <| title == $run_dir or title == $etc_dir |>
    }

    # Permissions control
    File {
        ensure  => directory,
        recurse => remote,
        owner   => $artifactory_user,
    }

    # Artifactory home directory
    file { $artifactory_home: }

    # Artifactory runtime directory
    unless $run_dir in ['/var/run', '/run'] {
        file { $run_dir: }
    }

    # Artifactory configuration directory
    unless $etc_dir == '/etc' {
        file { $etc_dir: }
    }

    # Tomcat home directory
    file { $tomcat_home:
        recurse => false,
    }

    # Tomcat webapps directory
    file { "${tomcat_webapps}": }
}

