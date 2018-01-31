# artifactory::service
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::service
class artifactory::service (
    String  $artifactory_home    = $artifactory::artifactory_home,
    String  $artifactory_user    = $artifactory::artifactory_user,
    String  $artifactory_pid     = $artifactory::artifactory_pid,
    String  $tomcat_home         = $artifactory::tomcat_home,
    Optional[
        Enum['server', 'client']
    ]       $java_vm_flavor      = $artifactory::java_vm_flavor,
    Optional[Artifactory::JavaSize]
            $java_xms            = $artifactory::java_xms,
    Optional[Artifactory::JavaSize]
            $java_xmx            = $artifactory::java_xmx,
    Optional[Artifactory::JavaSize]
            $java_xss            = $artifactory::java_xss,
    Optional[Boolean]
            $java_use_g1gc       = $artifactory::java_use_g1gc,
    Optional[Boolean]
            $java_oom_exit       = $artifactory::java_oom_exit,
    Integer $catalina_mgmt_port  = $artifactory::catalina_mgmt_port,

){
    # check Artifactory home directory
    file { $artifactory_home:
        ensure => directory,
    }

    # check Tomcat home directory
    file { $tomcat_home:
        ensure => directory,
    }

    # Java
    java::oracle { 'java-1.8':
        version_major => '8u161',
        version_minor => 'b12',
        url_hash      => '2f38c3b165be4555a1fa6e98c45e0808',
    }

    $catalina_pid_folder = dirname($artifactory_pid)
    $catalina_lock_file = "${catalina_pid_folder}/lock"
}
