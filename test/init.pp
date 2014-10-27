#class a_windows_service {
  windows_service {
    "logstash-forwarder-test":
      ensure     => present,
      command    => 'C:\Program Files (x86)\logstash-forwarder',
      parameters => ['-config','C:\Program Files (x86)\logstash-forwarder\temp.conf']
      #start_in
  }
#}
