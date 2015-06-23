Puppet::Type.type(:nssm_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  #confine :operatingsystem => :windows

  commands :nssm => 'nssm'

  mk_resource_methods

  def self.get_service_properties(service)
    service_properties = {}
    service_name = service.service_name

    begin
      if service.binary_path_name.include? 'nssm'
        service_properties[:ensure]     = :present
        service_properties[:command]    = nssm('get',service_name,'Application').to_s.gsub("\x00",'').chomp
        service_properties[:start_in]   = nssm('get',service_name,'AppDirectory').to_s.gsub("\x00",'').chomp
        service_properties[:parameters] = nssm('get',service_name,'AppParameters').to_s.gsub("\x00",'').chomp.split(' ')
     end
   rescue Puppet::ExecutionFailure => e
     service_properties[:ensure] = :absent
   end

    service_properties[:provider] = :nssm
    service_properties[:name]     = service_name.downcase
    service_properties
  end

  def self.instances
    Win32::Service.services.collect do |service|
      service_properties = get_service_properties(service)
      new(service_properties)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def set_create_service
    if @property_flush[:ensure] == :absent
      Puppet.debug("#nssm destroy the resource #{resource[:name]}!")
      nssm('stop',resource[:name])
      nssm('remove',resource[:name],'confirm')
      return
    end

    if resource[:command].nil?
      raise Puppet::Error, "Service cannot start if it doesn't know which command to run"
    end

    # If it doesn't already exist
    Puppet.debug("#nssm installing #{@property_hash[:name]} with command #{@property_hash[:command]} and parameters #{@property_hash[:parameters]}.")
    if @property_flush[:ensure] == :present
      Puppet.debug("#nssm installing #{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
      nssm('install',resource[:name],resource[:command],resource[:parameters])
    else
      Puppet.debug("#nssm not able to update parameters yet")
      Puppet.debug("#{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_hash[:ensure] == :absent
  end

  def flush
    set_create_service

    # Collect the resources again once they've been changed (that way `puppet
    # resource` will show the correct values after changes have been made).
    @property_hash = self.class.get_proxy_properties(resource[:name])
  end


end
