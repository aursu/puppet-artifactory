# artifactory::repos
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::repos
class artifactory::repos (
    Boolean $manage_package         = $artifactory::manage_package,
    String  $location               = $artifactory::repo_location,
    Array[String]
            $prerequired_packages   = $artifactory::prerequired_packages,
)
{
    $prerequired_packages.each |String $reqp| {
        package { $reqp:
            ensure => installed,
        }
    }

    if ($manage_package) {
        yumrepo { 'artifactory':
            descr    => 'jFrog Artifactory repository',
            baseurl  => $location,
            gpgcheck => false,
            repo_gpgcheck => false,
            enabled  => true,
        }
        Yumrepo['artifactory'] -> Package <| name == 'artifactory' |>
    }
}

