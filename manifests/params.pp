# == Class nssm::params
class nssm::params {
  $ensure       = 'present'
  $archive_name = 'nssm-2.24.zip'
  $archive_url  = 'http://nssm.cc/release'
  $install_dir  = 'C:\\Program Files\\nssm'
}
