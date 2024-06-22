# wp-vagrant

This repo provides a convenient Wordpress development environment. It's based on Ubuntu 22.04 with Apache as the web server, PHP 8.1 (with XDebug), MariaDB and PHPMyAdmin. Wordpress files are exposed to the public_html folder and won't be overwritten if you trash and rebuild the environment.


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

    This will download the Ubuntu box, create a headless virtual machine, and run the `provision.sh` script to set up the development environment.

    Wordpress will be available at `public_html/`. Logs for Apache and Maria are mapped to `log/`.


3. **Access the new Wordpress instance:**

    Add `127.0.0.1 wordpress.local` to your `/etc/hosts` or windows equivilent hosts file.

    Then you should be able to access it on the host at the address: `http://wordpress.local`.


4. **Access PHPMyAdmin:**

    Navigate to `http://wordpress.local/phpmyadmin` in your web browser.

    The login credentials can be found in provision.sh. Don't use these in production!


5. **Using Xdebug:**

    Ensure your IDE is configured to listen for Xdebug connections on port 9003. If you need to change the port, update the `xdebug.client_port` directive in the `provision.sh` script.


6. **Cleanup:**

    If you need to destroy the box, then run `vagrant destroy`. This will destroy the VM and database, but not the Wordpress file structure. You'll need to delete that manually.

    The provisioning script will keep Wordpress's file structure if detected.


## File Structure

- `Vagrantfile`: Defines the virtual machine config.
- `provision.sh`: Bash script which handles VM provisioning.
- `public_html/`: Folder that contains the Wordpress file heirachy and is accessible from the host.
- `log/`: Folder where Apache2 and MariaDB logs from the VM are mapped.


## Access

- **SSH:**
  - If you encounter any issues during provisioning, you can SSH into the VM with `vagrant ssh` poke around. I'd recommend using `mysqldump` from within the VM to dump the database later.

- **Xdebug configuration:**
  - Ensure your IDE is configured correctly to listen on port 9003.
  - Verify the Xdebug config in `/etc/php/8.1/mods-available/xdebug.ini` inside the VM.
