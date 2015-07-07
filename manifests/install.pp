class nssm::install {

  class { 'archive': }

  file { $nssm::install_dir:
    ensure => directory,
  }->
  file { $nssm::config_dir:
    ensure => directory,
  }

  archive { "C:\\Windows\\Temp\\${nssm::archive_name}":
    ensure       => present,
    extract      => true,
    extract_path => $nssm::install_dir,
    source       => "${nssm::archive_url}/${nssm::archive_name}",
    creates      => "${nssm::install_dir}\\nssm.exe",
    require      => File[$nssm::install_dir]
  }

}