# artifactory::repos
#
# This class setup jFrog Artifactory repository into system.
#
# @summary jFrog Artifactory repository installation
#
# @example
#   include artifactory::repos
class artifactory::repos (
    Boolean $manage_package         = $artifactory::manage_package,
    String  $location               = $artifactory::params::repo_location,
) inherits artifactory::params
{
    if $manage_package {
        yumrepo { 'artifactory':
            descr         => 'jFrog Artifactory repository',
            baseurl       => $location,
            gpgcheck      => false,
            repo_gpgcheck => false,
            enabled       => true,
        }
    }
}
