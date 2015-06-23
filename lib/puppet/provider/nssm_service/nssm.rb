Puppet::Type.type(:nssm_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  confine :operatingsystem => :windows

  commands :nssm => 'nssm', :powershell => 'powershell'

  mk_resource_methods

  def self.get_instance_properties
    instance_properties = {}

    begin
      service_status = nssm('status',resource[:name])
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "#self.get_instance_properties had an error -> #{e.inspect}"
      return {}
    end

    instance_properties[:ensure]     = service_status != nil ? :present : :absent
    instance_properties[:command]    = nssm('get',service,'Application')
    instance_properties[:start_in]   = nssm('get',service,'AppDirectory')
    instance_properties[:parameters] = nssm('get',service,'AppParameters')
    Puppet.debug "Service properties: #{instance_properties.inspect}"
    instance_properties
  end


  def self.instances
    service_properties = get_instance_properties
    new(service_properties)
  end






  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    nssm('install',resource[:name],resource[:command],resource[:parameters])
  end

  def destroy
    nssm('remove',resource[:name])
  end 


end
