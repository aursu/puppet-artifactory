# artifactory::repos
#
# This class setup jFrog Artifactory repository into system.
#
# @summary jFrog Artifactory repository installation
#
# @example
#   include artifactory::repos
class artifactory::repos (
    Enum['absent', 'present']
            $artifactory_ensure     = $artifactory::ensure,
    Boolean $manage_package         = $artifactory::manage_package,
    String  $location               = $artifactory::params::repo_location,
) inherits artifactory::params
{
    if $manage_package {
        yumrepo { 'artifactory':
            ensure        => $artifactory_ensure,
            descr         => 'jFrog Artifactory repository',
            baseurl       => $location,
            gpgcheck      => false,
            repo_gpgcheck => false,
            enabled       => true,
        }
    }
}
