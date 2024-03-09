# cm
(Configuration management)

A central Ansible playbook for managing configuraion state on my homelab infrastructure, based around a virtualized Kubernetes cluster.

This playbook is designed to be run more than once on the same host and therefore has trouble integrating with certain Ansible projects that require discreet installation and uninstallation and manage state via destroying and rebuilding hosts from scratch.

## Using
1. Clone the repository
    ```
    git clone https://github.com/JosBritton/cm.git
    ```
2. Create a `secrets.yml` file for managing keys with the following content
    ```
    (umask 0077; echo "" >> ./inventory/secrets.yml)
    ```
    ```
    ./inventory/secrets.yml
    ```
    ```
    rndc_keys:
      zone_keys:
        - zone_fqdn: "fleet.private.swifthomelab.net"
          algorithm: "hmac-sha256"
          secret: "tsigxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx="
      reverse_zone_keys:
        - zone_fqdn: "10.in-addr.arpa"
          algorithm: "hmac-sha256"
          secret: "tsigxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx="
    ```

    You can generate your own TSIG keys using `tsig-keygen` from Bind9:
    ```
    (umask 0077; tsig-keygen >> ./inventory/tsig.key)
    ```
    ```
    ./inventory/tsig-key
    ```
    ```
    key "tsig-key" {
        algorithm hmac-sha256;
        secret "tsigxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=";
    };
    ```

    You can then copy the secret according to the above yaml format.

3. Run the playbook from the Makefile (not tested for compatibility outside of GnuMake)
    ```
    make all
    ```

    (Or, you could provision a certain group independently by role name)

    ```
    make <role name>
    ```

## Developing
- Make sure to install the pre-commit hook before committing changes to the repository.
    ```
    make install
    ```
