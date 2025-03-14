use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    my $user = get_var("USER_LOGIN", "test");
    my $password = get_var("USER_PASSWORD", "weakpassword");

    #boot_to_login_screen(timeout => 300);
    $self->root_console(tty => 3);
    # Make necessary settings for the RDP server.
    # Set SElinux to permissive to workaround a Fedora issue
    assert_script_run("setenforce 0");
    # Check that SElinux is in permissive mode
    validate_script_output("getenforce", sub { m/Permissive/ });

    # In Workstation, the RDP port should be opened per se, 
    # but let's open it explicitely, to make sure it is open.
    assert_script_run("firewall-cmd --add-port=3389/tcp");

    # Change to Desktop
    desktop_vt();

    # Open Settings and navigate to Remote Login
    menu_launch_type("Settings");
    send_key("ctrl-f");
    sleep(2);
    type_very_safely("system");
    assert_and_click("settings_system");
    assert_and_click("settings_remote_desktop");
    assert_and_click("settings_remote_login");
    assert_and_click("gnome_button_unlock");
    if (check_screen("auth_required_password", timeout => 60)) {
        type_very_safely("$password\n");
    }
    else {
        die("Authentication dialogue is not visible but was expected.");
    }

    # Set up remote login in Gnome Settings.
    assert_and_click("settings_switch_remote");
    wait_still_screen(3);
    assert_and_click("settings_remote_username");
    type_very_safely("remotee");
    assert_and_click("settings_remote_password");
    type_very_safely("opensesame");
    assert_and_click("gnome_reveil_password");
    wait_still_screen(3);
    send_key("alt-f4");

    # Check that the service is running.
    $self->root_console(tty => 3);
    assert_script_run("ps aux | grep rdp", timeout => 10);

}

sub test_flags {
    return {fatal => 1};
}
1;
# vim: set sw=4 et:
