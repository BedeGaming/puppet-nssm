Puppet::Type.type(:windows_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  confine :operatingsystem => :windows

  commands :nssm => 'nssm', :powershell => 'powershell'

  mk_resource_methods

  def exists?
    @property_hash[:ensure] == :present or @property_hash[:ensure] == 'present'
  end

  def create
    Puppet.debug("#nssm installing #{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
    nssm('install',resource[:name],resource[:command],resource[:parameters])
  end

  def destroy
    Puppet.debug("#nssm destroy the resource #{resource[:name]}!")
    nssm('remove',resource[:name],'confirm')
  end 

  # returns all providers for all existing services and startup state
  def self.instances
    Win32::Service.services.collect do |svc|
      service_properties = get_service_properties(svc)
      new(service_properties)
    end
  end

  def self.get_service_properties(service)
    service_properties = {}
    service_name = service.service_name

    begin
      status = service.current_state
      service_properties[:ensure] = :present
      if service.binary_path_name.include? 'nssm'
        parameters = nssm('get', service_name,'AppParameters').to_s.gsub("\x00",'').gsub("\n",'').gsub("\r",'')
        start_in = nssm('get', service_name,'AppDirectory').to_s.gsub("\x00",'').gsub("\n",'').gsub("\r",'')
        Puppet.debug("Got #{parameters.class} #{parameters.inspect} #{start_in}.")
        command = nssm('get', service_name,'Application').to_s.gsub("\x00",'').gsub("\n",'').gsub("\r",'')
      end
    rescue Puppet::ExecutionFailure => e
      service_properties[:ensure] = :absent
      #raise Puppet::Error, "#nssm tried to run `powershell Get-Service -Name #{service}|select status,name,displayName|ConvertTo-Csv -NoTypeInformation` and the command returned non-zero. Failing here..."
    end

    service_properties[:start_in] = start_in
    service_properties[:command] = command
    service_properties[:parameters] = parameters

    service_properties[:provider] = :nssm
    service_properties[:name]     = service_name.downcase
    service_properties
  end
end
