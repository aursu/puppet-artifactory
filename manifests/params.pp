# module hardcoded parameters
class artifactory::params {

    # installation assets and settings
    $oracle_java_home    = '/usr/java/default'
    $repo_location       = 'https://jfrog.bintray.com/artifactory-rpms'
    $package_name        = 'jfrog-artifactory-oss'

    # hardcoded resource limits
    $minnofilemax        = 32000
    $minnbprocess        = 1024

    # installation and operational paths
    # https://www.jfrog.com/confluence/display/RTF/Installing+on+Linux+Solaris+or+Mac+OS#InstallingonLinuxSolarisorMacOS-ManagedFilesandFolders
    $jfrog_home          = '/opt/jfrog'
    $install_dir         = "${jfrog_home}/artifactory"

    # Tomcat home: /opt/jfrog/artifactory/tomcat
    $tomcat_home         = "${install_dir}/tomcat"

    $tomcat_webapps      = "${tomcat_home}/webapps"

    # Artifactory etc: /etc/opt/jfrog/artifactory
    $etc_dir             = "/etc${install_dir}"

    $var_dir             = "/var${jfrog_home}"
    $run_dir             = "${var_dir}/run"

    # Artifactory home: /var/opt/jfrog/artifactory
    $artifactory_home    = "${var_dir}/artifactory"

    # Artifactory logs: /var/opt/jfrog/artifactory/logs
    $log_dir             = "${artifactory_home}/logs"

    $artifactory_pid     = "${run_dir}/artifactory.pid"
}
