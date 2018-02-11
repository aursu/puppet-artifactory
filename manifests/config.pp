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
        ]
        User[$artifactory_user] -> File <| title == $run_dir or title == $etc_dir |>
    }

    # Permissions control
    File {
        ensure  => directory,
        recurse => true,
        owner   => $artifactory_user,
        # do not replace symlink - manage target directory
        links   => follow,
    }

    # Artifactory home directory
    file { $artifactory_home:
        # there are some dead links inside - disable resolution
        links => manage,
    }

    # Artifactory runtime directory
    unless $run_dir in ['/var/run', '/run'] {
        file { $run_dir: }
    }

    # Artifactory configuration directory
    unless $etc_dir == '/etc' {
        file { $etc_dir: }
    }

    # runtime data and tomcat home directory
    $norecurse = [
        $tomcat_home,
        "${artifactory_home}/logs",
        "${artifactory_home}/logs/catalina",
        "${artifactory_home}/temp",
        "${artifactory_home}/work",
    ]
    file { $norecurse:
        recurse => false,
    }

    # Tomcat webapps directory
    file { "${tomcat_webapps}": }
}

