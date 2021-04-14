consul-setup
============

Role for installing and configuring consul agent and/or server

This role was developed by [Soluciones Orion](https://www.solucionesorion.com)

<a href="https://www.solucionesorion.com/" target="_blank"><img src="https://www.solucionesorion.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Orion - Impulsa tu evolucion digital" width="250" /></a>


Variables
---------

* consul_user - (Default: consul) Consul run as user
* consul_group - (Default: consul) Consul run as group
* consul_config_filename - (Default: consul.json) Name of JSON config file. 
* consul_config_dir - (Default: /etc/consul) Path that holds the consul config file
* consul_runtime_dir - (Default: /var/run/consul) Runtime directory path
* consul_data_dir - (Default: /var/consul/data) Consul data directory
* consul_bin_dir - (Default: /usr/local/bin) Consul binary directory
* consul_role - (Default: agent) Consul role to deploy. Valid values are *agent* and *server*
* consul_dc - (Default: consul_dc) Consul Data Center name
* consul_syslog_facility - (Default: DEBUG) Syslog facility where consul logs should be delivered to
* consul_syslog_enabled - (Default: yes) Enable consul logging to syslog
* consul_ui_enabled - (Default: yes) Enable Consul UI
* consul_version - (Default: 1.7.3) Consul version to deploy
* consul_home_dir - (Default: /var/consul) Home directory of consul user
* consul_shell - (Default: /usr/sbin/nologin) Shell of consul user
* consul_url - (Default: https://releases.hashicorp.com/consul/{{ consul_version }}/consul_{{ consul_version }}_linux_amd64.zip) Where to download consul from
* consul_join_group - (Default: consul) Name of a group in inventory to which consul should attempt to join
* deploy_action - (Default: install) Deployment action. Valid values are *install*, *reinstall* or *uninstall*



Inventory setup
---------------
Hosts must be defined in an inventory file like this:

```ìni
[consul]
consul1 ansible_host=IP1
consul2 ansible_host=IP2
consul3 ansible_host=IP3
```

The name of the group should be the same ([consul]). Also, consul node names should be registered as the example shown above.


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- hosts: consul
  tasks:
    - name: Install consul agent
      include_role:
        name: consul-setup
      vars:
        consul_role: agent
        consul_version: 1.7.1
```
