# wp-vagrant

This repo provides a Wordpress development environment on Vagrant. It's based on Ubuntu 22.04 with Apache as the web server, PHP 8.1 (with XDebug), MariaDB and PHPMyAdmin. Wordpress files are exposed to the `public_html/` folder and won't be overwritten if you trash and rebuild the environment.


## Prerequisites

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads)


## Setup Instructions

1. **Clone the repo:**

    ```bash
    git clone https://github.com/stephenpearce/wp-vagrant.git
    cd wp-vagrant
    ```

2. **Start and provision the VM:**

    ```bash
    vagrant up
    ```

    This will download Ubuntu, create a headless virtual machine instance, and run the `provision.sh` script on it to set up the development environment.

    Wordpress's files will then be available at `public_html/`.

    Logs for Apache and MariaDB are mapped to `log/`.


3. **Access the new Wordpress instance:**

    Add `127.0.0.1 wordpress.local` to your `/etc/hosts` file (macOS | Linux) or `C:\Windows\System32\drivers\etc\hosts` file (Windows).

    Then you should be able to access it on the host at the address: `http://wordpress.local`.


4. **Access PHPMyAdmin:**

    Navigate to `http://wordpress.local/phpmyadmin` in your web browser.

    Login credentials can be found in provision.sh.

    Don't use these credentials or the default table prefixes in production!


5. **Using Xdebug:**

    Ensure your IDE is configured to listen for Xdebug connections on port 9003. If you need to change the port, update the `xdebug.client_port` directive in the `provision.sh` script.


6. **Cleanup:**

    If you need to destroy the box, then run `vagrant destroy`. This will destroy the VM and database, but not the Wordpress file structure. You'll need to delete that manually.

    The provisioning script will skip over the Wordpress download if an old `wp-config.php` is found.


## File Structure

- `Vagrantfile`: Defines the virtual machine config.
- `provision.sh`: Bash script which handles VM provisioning.
- `public_html/`: Folder that contains the Wordpress file hierarchy and is accessible from the host.
- `log/`: Folder where Apache2 and MariaDB logs from the VM are mapped.


## Access Notes

  - If you encounter any issues, you can SSH into the VM with `vagrant ssh`.
  - Use `mysqldump` from within the VM to dump the database.
