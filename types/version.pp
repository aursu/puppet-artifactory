type Artifactory::Version = Variant[
    Enum['present', 'installed', 'absent'],
    Pattern[/^4\.[0-9]\./, /^4\.1[0-6]\./, /^5\.[0-8]\./],  # jfrog-artifactory-oss
    Pattern[/^2\.6\.[0-7]/, /^3\.[0-9]\./]                  # artifactory
]