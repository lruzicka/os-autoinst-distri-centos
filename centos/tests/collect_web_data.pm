use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;

    # Let's get the $target release version. 
    my $target = get_release_number();
    # The $current release version is the last stable release
    # around that we want to compare.
    my $current = get_var('CURRREL');
        
    # Go to the home directory, create a new directory there
    # and collect the data
    assert_script_run('cd');
    assert_script_run('mkdir version_data');
    assert_script_run('cd version_data');

    # We will fetch the version data from various locations.
    # Download data from Bodhi for
    assert_script_run("curl -o bodhi-$target.json https://bodhi.fedoraproject.org/releases/F$target");
    # Download data from Fedora Schedule
    assert_script_run("curl -o schedule-$target.json https://fedorapeople.org/groups/schedule/f-$target/f-$target-key.json");
    # Install jq to modify the downloaded jsons and make sure, they will be correctly formed.
    assert_script_run("dnf install -y jq", timeout => 60);
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}
1;
# vim: set sw=4 et:
