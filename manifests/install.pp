# artifactory::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::install
class artifactory::install {
    Artifactory::PackageName
            $package_name   = $artifactory::package_name,
    Artifactory::Version
            $version        = $artifactory::version,
    Boolean $manage_package = $artifactory::manage_package,
)
{
    if $manage_package {
        package { 'artifactory':
            ensure   => $version,
            name     => $package_name,
        }
    }
}
