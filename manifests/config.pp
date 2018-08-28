# artifactory::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::config
class artifactory::config (
    Enum['absent', 'present']
            $artifactory_ensure = $artifactory::ensure,
    Boolean $manage_users       = $artifactory::manage_os_users,
    String  $artifactory_user   = $artifactory::artifactory_user,
    String  $group              = $artifactory::artifactory_group,
    String  $artifactory_home   = $artifactory::params::artifactory_home,
    String  $tomcat_home        = $artifactory::params::tomcat_home,
    String  $tomcat_webapps     = $artifactory::params::tomcat_webapps,
    String  $etc_dir            = $artifactory::params::etc_dir,
    String  $run_dir            = $artifactory::params::run_dir,
    String  $log_dir            = $artifactory::params::log_dir,
) inherits artifactory::params
{
    include artifactory::install

    if $manage_users {
        group { $group:
            ensure => $artifactory_ensure,
        }

        user { $artifactory_user:
            ensure     => $artifactory_ensure,
            groups     => [ $group ],
            membership => 'minimum',
        }

        if $artifactory_ensure == 'present' {
            Group[$group] -> User[$artifactory_user]
            User[$artifactory_user] -> [
                File[$artifactory_home],
                File[$tomcat_home],
            ]
            User[$artifactory_user] -> File <| title == $run_dir or title == $etc_dir |>
        }
        else {
            User[$artifactory_user] -> Group[$group]
        }
    }

    # Permissions control
    if $artifactory_ensure == 'present' {
        File {
            ensure  => directory,
            recurse => true,
            owner   => $artifactory_user,
            # do not replace symlink - manage target directory
            links   => follow,
            require => Package['artifactory'],
        }
    }

    # Artifactory home directory
    file { $artifactory_home:
        # there are some dead links inside - disable resolution
        links => manage,
    }

    # Artifactory runtime directory
    unless $run_dir in ['/var/run', '/run'] {
        file { $run_dir: }
        if $artifactory_ensure == 'absent' {
            File[$run_dir] { ensure => 'absent', }
        }
    }

    # Artifactory configuration directory
    unless $etc_dir == '/etc' {
        file { $etc_dir: }
        if $artifactory_ensure == 'absent' {
            File[$etc_dir] { ensure => 'absent', }
        }
    }

    # runtime data and tomcat home directory
    $norecurse = [
        $tomcat_home,
        "${log_dir}",
        "${log_dir}/catalina",
        "${artifactory_home}/temp",
        "${artifactory_home}/work",
        "${artifactory_home}/etc",
    ]
    file { $norecurse:
        recurse => false,
    }

    # Tomcat webapps directory
    file { $tomcat_webapps: }

    if $artifactory_ensure == 'absent' {
        $cleanup_resources = $norecurse + [
            $artifactory_home,
            $tomcat_webapps
        ]
        $cleanup_resources.each |String $path| {
            File[$path] { ensure => 'absent', }
        }
    }
}
