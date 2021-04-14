vault-setup
============

Role for installing and configuring a vault cluster

This role was developed by [Soluciones Orion](https://www.solucionesorion.com)

<a href="https://www.solucionesorion.com/" target="_blank"><img src="https://www.solucionesorion.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Orion - Impulsa tu evolucion digital" width="250" /></a>


Variables
---------

* vault_user - (Default: vault) Vault run as user
* vault_group - (Default: vault) Vault run as group
* vault_config_filename - (Default: config.hcl) Name of JSON config file. 
* vault_config_dir - (Default: /etc/vault) Path that holds the vault config file
* vault_runtime_dir - (Default: /var/run/vault) Runtime directory path
* vault_data_dir - (Default: /var/vault/data) Vault data directory
* vault_audit_dir - (Default: /var/vault/log) Vault audit directory
* vault_bin_dir - (Default: /usr/local/bin) Vault binary directory
* vault_dc - (Default: vault_dc) Vault Data Center name
* vault_syslog_facility - (Default: DEBUG) Syslog facility where vault logs should be delivered to
* vault_syslog_enabled - (Default: yes) Enable vault logging to syslog
* vault_ui_enabled - (Default: yes) Enable Vault UI
* vault_version - (Default: 1.4.2) Vault version to deploy
* vault_home_dir - (Default: /var/vault) Home directory of Vault user
* vault_shell - (Default: /usr/sbin/nologin) Shell of Vault user
* vault_url - (Default: https://releases.hashicorp.com/vault/{{ vault_version }}/vault_{{ vault_version }}_linux_amd64.zip) Where to download vault from
* vault_hostname - (Default: localhost) Hostname to set in VAULT_ADDR environment variable
* vault_storage - (Default: consul) Type of storage backend to use. Valid values are *"consul"* and *"raft"*
* vault_tls_disable - (Default: 1) Whether to disable (value 1) or enable (value 0) TLS in Vault server
* vault_key_shares - (Default: 5) Number of Shamir keys to create on initialization
* vault_key_threshold - (Default: 5) Number of Shamir keys required to unseal Vault
* deploy_action - (Default: install) Deployment action. Valid values are *install*, *reinstall* or *uninstall*
* ca_cert_file - (Default: not set) Path to a CA PEM certificate file to use when TLS is enabled
* server_cert_file - (Default: not set) Path to a server PEM certificate file to use when TLS is enabled
* server_key_file - (Default: not set) Path to a server PEM private key file to use when TLS is enabled
* aws_region - (Default: not set) When auto-unseal with KMS is enabled, this is the region name where KMS key resides
* aws_access_key - (Default: not set) When auto-unseal with KMS is enabled, this is the AWS Access Key ID for getting access to KMS key
* aws_secret_key - (Default: not set) When auto-unseal with KMS is enabled, this is the AWS Secret Access Key for getting access to KMS key
* aws_kms_key_id - (Default: not set) When auto-unseal with KMS is enabled, this is the KMS Key ID

Inventory setup
---------------
Hosts must be defined in an inventory file like this:

```ìni
[vault]
vault1 ansible_host=IP1
vault2 ansible_host=IP2
vault3 ansible_host=IP3
```

The name of the group should be the same ([vault]). Also, vault node names should be registered as the example shown above.

Enabling Auto-Unseal with AWS KMS
---------------------------------
It's just needed to define these 4 variables with valid values. Example:

```yaml
aws_region: us-east-1
aws_access_key: YOUR_ACCESS_KEY_ID_HERE
aws_secret_key: YOUR_SECRET_ACCESS_KEY_HERE
aws_kms_key_id: YOUR_KMS_KEY_ID_HERE
```

Enabling TLS
------------
It's just needed to define these 4 variables with valid values. Example:

```yaml
vault_tls_disable: 0
ca_cert_file: /etc/vault/ca-cert.pem
server_cert_file: /etc/vault/myserver-cert.pem
server_key_file: /etc/vault/myserver-key.pem
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- hosts: vault
  tasks:
    - name: Install vault cluster
      include_role:
        name: vault-setup
      vars:
        vault_version: 1.4.2
        vault_tls_disable: 1
```
