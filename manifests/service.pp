# artifactory::service
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::service
class artifactory::service (

    String  $service_name               = $artifactory::service_name,
    String  $service_systemd_template   = $artifactory::service_systemd_template,
    String  $service_config             = $artifactory::service_config,
    String  $service_config_template    = $artifactory::service_config_template,
    String  $service_setenv_template    = $artifactory::service_setenv_template,
    String  $artifactory_user           = $artifactory::artifactory_user,
    String  $artifactory_group          = $artifactory::artifactory_group,
    String  $artifactory_home           = $artifactory::params::artifactory_home,
    String  $artifactory_pid            = $artifactory::params::artifactory_pid,
    String  $tomcat_home                = $artifactory::params::tomcat_home,
    Optional[
        Enum['server', 'client']
    ]       $java_vm_flavor             = $artifactory::java_vm_flavor,
    Optional[Lsys::JavaSize]
            $java_xms                   = $artifactory::java_xms,
    Optional[Lsys::JavaSize]
            $java_xmx                   = $artifactory::java_xmx,
    Optional[Lsys::JavaSize]
            $java_xss                   = $artifactory::java_xss,
    Optional[Boolean]
            $java_use_g1gc              = $artifactory::java_use_g1gc,
    Optional[Boolean]
            $java_oom_exit              = $artifactory::java_oom_exit,
    Integer $catalina_mgmt_port         = $artifactory::catalina_mgmt_port,
    Optional[Lsys::RLimit]
            $nofile_rlimit              = $artifactory::nofile_rlimit,
    Optional[Lsys::RLimit]
            $nproc_rlimit               = $artifactory::nproc_rlimit,
    Lsys::RLimit
            $minnofilemax               = $artifactory::params::minnofilemax,
    Lsys::RLimit
            $minnbprocess               = $artifactory::params::minnbprocess,
) inherits artifactory::params
{
    include lsys::systemd

    File {
        owner   => root,
        group   => root,
        mode    => 'u=rw,go=r',
    }

    if $::is_init_systemd {
        # replace distributed with Artifactory setenv.sh file with custom
        # considering that Artifactory is managed by Puppet on systemd running
        # system
        file { 'setenv.sh':
            path    => "${tomcat_home}/bin/setenv.sh",
            content => template($service_setenv_template),
            owner   => $artifactory_user,
        }

        # environment file (or sysconfig file)
        file { $service_config:
            content => template($service_config_template),
        }

        # systemd unit
        file { "/usr/lib/systemd/system/${service_name}.service":
            content => template($service_systemd_template),
            require => [
                File[$service_config],
                File['setenv.sh']
            ],
            notify  => Exec['systemd-reload'],
        }

        file { "/etc/systemd/system/${service_name}.service.d":
            ensure                  => directory,
            mode                    => '0755',
            selinux_ignore_defaults => true,
        }

        file { "/etc/systemd/system/${service_name}.service.d/limits.conf":
            content => template('artifactory/systemd/limits.conf.erb'),
            notify  => Exec['systemd-reload'],
        }
    }
}
