class nssm::install {

  include '::archive'

  archive { "C:\\Windows\\Temp\\${nssm::archive_name}":
    ensure       => present,
    extract      => true,
    extract_path => 'C:\\Windows\\Temp\\',
    source       => "${nssm::archive_url}/${nssm::archive_name}",
    creates      => 'C:\\Windows\\Temp\\nssm-2.24',
  }

  file { 'C:\\Windows\\nssm.exe':
    ensure  => present,
    source  => 'C:\\Windows\\Temp\\nssm-2.24\\win64\\nssm.exe',
    require => Archive["C:\\Windows\\Temp\\${nssm::archive_name}"],
  }

}
