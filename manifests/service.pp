# artifactory::service
#
# Class artifactory::service manages Systemd settings for jFrog Artifactory
# and enable/start it.
#
# Artifactory JVM parameters located in file /etc/sysconfig/artifactory
# JAVA_HOME variable located in /etc/environment (managed by javalocal or java
# classes)
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::service
class artifactory::service (
    Enum['absent', 'present']
            $artifactory_ensure         = $artifactory::ensure,
    String  $service_name               = $artifactory::service_name,
    Lsys::SrvEnsure
            $service_ensure             = $artifactory::service_ensure,
    Boolean $service_enable             = $artifactory::service_enable,
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
    require artifactory

    include lsys::systemd
    include artifactory::install
    include artifactory::config

    File {
        owner   => root,
        group   => root,
        mode    => 'u=rw,go=r',
    }

    if $::is_init_systemd {
        $setenv_script = "${tomcat_home}/bin/setenv.sh"
        $service_unit = "/usr/lib/systemd/system/${service_name}.service"
        $service_directory = "/etc/systemd/system/${service_name}.service.d"
        if $artifactory_ensure == 'present' {
            # replace distributed with Artifactory setenv.sh file with custom
            # considering that Artifactory is managed by Puppet on systemd running
            # system
            file { 'setenv.sh':
                path    => $setenv_script,
                content => template($service_setenv_template),
                owner   => $artifactory_user,
            }
            # environment file (or sysconfig file)
            file { $service_config:
                content => template($service_config_template),
                notify  => Service['artifactory'],
            }
            # systemd unit
            file { $service_unit:
                content => template($service_systemd_template),
                require => [
                    File[$service_config],
                    File['setenv.sh'],
                ],
                notify  => Exec['systemd-reload'],
                before  => Service['artifactory'],
            }

            file { $service_directory:
                ensure                  => directory,
                mode                    => '0755',
                selinux_ignore_defaults => true,
            }

            file { "${service_directory}/limits.conf":
                content => template('artifactory/systemd/limits.conf.erb'),
                notify  => Exec['systemd-reload'],
                before  => Service['artifactory'],
            }
        }
        else {
            $cleanup_resources = [
                $setenv_script,
                $service_config,
                $service_unit,
                $service_directory
            ]
            file { $cleanup_resources:
                ensure  => 'absent',
                require => Service['artifactory'],
            }
        }
    }

    if $artifactory_ensure == 'present' {
        service { $service_name:
            ensure     => $service_ensure,
            hasstatus  => true,
            hasrestart => true,
            enable     => $service_enable,
            alias      => 'artifactory',
            require    => Package['artifactory'],
        }

        # all Artifactory configuration should be set before service start
        File <| tag == 'artifactory::config' |> -> Service['artifactory']
    }
    else {
        service { $service_name:
            ensure => 'stopped',
            enable => false,
            alias  => 'artifactory',
            before => Package['artifactory'],
        }
    }
}
