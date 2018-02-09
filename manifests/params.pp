class artifactory::params {

    # installation assets and settings
    $oracle_java_package = 'jdk1.8'
    $oracle_java_home    = '/usr/java/default'
    $repo_location       = 'https://jfrog.bintray.com/artifactory-rpms'
    $package_name        = 'jfrog-artifactory-oss'

    # hardcoded resource limits
    $minnofilemax        = 32000
    $minnbprocess        = 1024

    # installation and operational paths
    $jfrog_home          = '/opt/jfrog'
    $install_dir         = "${jfrog_home}/artifactory"
    $tomcat_home         = "${install_dir}/tomcat"
    $tomcat_webapps      = "${tomcat_home}/webapps"
    $etc_dir             = "/etc${install_dir}"
    $var_dir             = "/var${jfrog_home}"
    $run_dir             = "${var_dir}/run"
    $artifactory_home    = "${var_dir}/artifactory"
    $artifactory_pid     = "${run_dir}/artifactory.pid"
}