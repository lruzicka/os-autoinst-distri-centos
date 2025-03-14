use base "installedtest";
use strict;
use testapi;
use utils;


# This test checks that no errors are reported through automated tools after installation.
# Currently, this checks for anything in system notifications, coredumpctl, and abrt-cli.
# The test fails if anything is reported by these tools.
#

sub clear {
    type_very_safely("clear\n");
    sleep(2);
}

sub run {
    my $self = shift;
    my $desktop = get_var("DESKTOP", "gnome");

    check_errors_notifications($desktop);
    
    check_errors_cli($desktop);
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
