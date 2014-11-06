# == Class: nssm
#
# Module to install NSSM (the Non-Sucking Service Manager)
#
# === Parameters
#
# [*ensure*]
# Valid values are present (also called installed), absent, purged, held, latest. Values can match /./.
#
# === Examples
#
# Install with defaults:
#
#  include nssm
#
#
class nssm (
  $ensure      = $nssm::params::ensure
) inherits nssm::params {

  if $::osfamily != 'windows' {
    fail("${::osfamily} not supported")
  }

  package { 'nssm':
    ensure   => $ensure,
    provider => 'chocolatey'
  }

}
