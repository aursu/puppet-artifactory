# artifactory::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include artifactory::config
class artifactory::config (
    Boolean $manage_users   = $artifactory::manage_os_users,
    Docker::UserList
            $artifactory_user   = $artifactory::artifactory_user,
    String  $group          = $artifactory::artifactory_group,
)
{
    if $manage_users {
        user{ $artifactory_user:
            ensure     => 'present',
            groups     => [ $group ],
            membership => 'minimum',
        }
    }
}

