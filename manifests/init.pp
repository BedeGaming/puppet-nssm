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
  $ensure       = $nssm::params::ensure,
  $archive_name = $nssm::params::archive_name,
  $archive_url  = $nssm::params::archive_url,
  $install_dir  = $nssm::params::install_dir,
) inherits nssm::params {

  if $::osfamily != 'windows' {
    fail("${::osfamily} not supported")
  }

  contain '::nssm::install'

}
