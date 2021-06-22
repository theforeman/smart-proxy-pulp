# Foreman Pulp Plugin

Foreman project plugin for Pulp allowing Katello hosts to interact with Pulp application services for content management
While this plugin is part of the Foreman project, it can only be used with Katello as Foreman is not content aware without the Katello plugin.

## Getting Started

The Foreman project provides documentation on this specific plugin installation from multiple methods, distribution specific RPM, distribution specific DEB and direct manual build from source.
The plugin can also be installed as part of the foreman-installer puppet class with the "--[no-]enable-foreman-proxy-plugin-pulp" option.
Documentation can be found here for how to install a stand alone smart proxy https://theforeman.org/manuals/latest/index.html#4.3.1SmartProxyInstallation

### Prerequisites

* Working Katello instance (note not Foreman - must be Katello)
* Pulp 3 installation
* Smart Proxy 2.3 or newer

### Installing

Assuming prerequisites are met, the Pulp plugin must be enabled in the Foreman Proxy directory with `pulpcore.yaml`.
The following parameters should be set:

```yaml
---
:enabled: true
#:pulp_url: https://localhost/
#:content_app_url: https://localhost:24816/
#:mirror: false
```

### Settings

#### client_authentication

The setting client_authentication is an array of authentication types supported by the Pulp installation. The valid values are:

 * password: username and password authentication
 * client_certificate: This indicates whether the service handling authentication for Pulp allows matching the client certificates presented common name to some paired string, often hostname, and setting the remote user header.
 * client_certificate_admin_only: This indicates the service handling authentication for Pulp allows matching only client certificates where the common name is set to 'admin'.

## Running the tests

Run all tests

```
bundle exec rake test
```

Run an individual test

```
bundle exec rake test TEST=test/pulpcore_plugin_integration_test.rb
```

## Authors

* **The Foreman Project** - *Initial Draft* - https://theforeman.org/

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Foreman IRC user areyus who prompted the need for this README
