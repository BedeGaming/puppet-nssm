Puppet::Type.type(:windows_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  confine :operatingsystem => :windows

  commands :nssm => 'nssm', :powershell => 'powershell'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end 

  def command=(value)
    @property_flush[:command] = value
  end

  def start_in=(value)
    @property_flush[:start_in] = value
  end

  def parameters=(value)
    @property_flush[:parameters] = value
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
      nssm('remove',resource[:name],'confirm')
      return
    end

    if resource[:command].nil?
      raise Puppet::Error, "Service cannot start if it doesn't know which command to run"
    end

    # If it doesn't already exist
    if @property_hash[:ensure] == :absent
      Puppet.debug("#nssm installing #{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
      nssm('install',resource[:name],resource[:command],resource[:parameters])
    else
      Puppet.debug("#nssm not able to update parameters yet")
      Puppet.debug("#{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
    end
  end

  def flush
    set_create_service

    # Collect the resources again once they've been changed (that way `puppet
    # resource` will show the correct values after changes have been made).
    @property_hash = self.class.get_service_properties_from_name(resource[:name])
  end

  # returns all providers for all existing services and startup state
  def self.instances
    Win32::Service.services.collect do |svc|
      service_properties = get_service_properties(svc)
      new(service_properties)
    end
  end

  def self.get_service_properties_from_name(name)
    services = Win32::Service.services
    Puppet.debug "Services type is #{services.class}"
    svc = services.find(&:service_name == name)
    get_service_properties(svc)
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
