Puppet::Type.type(:windows_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  confine :operatingsystem => :windows

  commands :nssm => 'nssm', :powershell => 'powershell'

  def exists?
    @property_hash[:ensure] == :present
=begin
    begin
      output = nssm('status',resource[:name])
    rescue Puppet::ExecutionFailure => e # Means a non zero exit code was returned
      Puppet.debug("#nssm exists has an error -> #{e.inspect}")
      return false
    end
    true
=end
  end

  def create
    Puppet.debug("#nssm installing #{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
    nssm('install',resource[:name],resource[:command],resource[:parameters])
  end

  def destroy
    Puppet.debug("#nssm destroy the resource #{resource[:name]}!")
    nssm(['remove',resource[:name]])
  end 

  def self.instances
    get_list_of_services.collect do |svc|
      service_properties = get_service_property(service)
      new(service_properties)
    end
  end

  def self.get_list_of_services
    services = powershell('Get-Service', '|select name|ConvertTo-Csv -NoTypeInformation').split('\n')
    services.shift
    services.sort
  end

  def self.get_service_properties(service)
    service_properties = {}
 
    begin
       status = nssm('status', service)
       parameters = nssm('get', service,'AppParameters')
       start_in = nssm('get', service,'AppDirectory')
       command = nssm('get', service,'Application')
       #output = powershell('Get-Service', '-Name', service,' |select status,name,displayName|ConvertTo-Csv -NoTypeInformation').split('\n')
       #services.shift
       #services.sort
    rescue Puppet::ExecutionFailure => e
      Puppet.debug("#nssm tried to run `nssm status` and the command returned non-zero. Assuming absent here...")
      service_properties[:ensure] = :absent
      #raise Puppet::Error, "#nssm tried to run `powershell Get-Service -Name #{service}|select status,name,displayName|ConvertTo-Csv -NoTypeInformation` and the command returned non-zero. Failing here..."
    end
 
    #service_properties[:ensure] = status == 'SERVICE_RUNNING' ? :present : :absent
    service_properties[:ensure] = :present
    service_properties[:start_in] = start_in
    service_properties[:command] = command
    service_properties[:parameters] = parameters

    service_properties[:provider] = :nssm
    service_properties[:name]     = service.downcase
    service_properties

  end
end

