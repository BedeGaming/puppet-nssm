Puppet::Type.type(:nssm_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  confine :operatingsystem => :windows

  commands :nssm => 'nssm', :powershell => 'powershell'

  mk_resource_methods

  def get_service_status(service_name = resource[:name])
    begin
      output = nssm('status',service_name)
    rescue Puppet::ExecutionFailure => e
      Puppet.debug("#get_service_status returned an error -> #{e.inspect}")
      return nil
    end
    service_status = output.split("\n").sort
    return nil if service_status.first =~ /Can't open service!/
    service_status
  end

  def exists?
    get_service_status(resource[:name]) != nil
  end

  def create
    nssm('install',resource[:name],resource[:command],resource[:parameters])
  end

  def destroy
    nssm('remove',resource[:name])
  end

  def command
    nssm('get',resource[:name],'Application').to_s.gsub("\x00",'').chomp
  end

  def command=(value)
    nssm('set',resource[:name],'Application',resource[:command])
  end

  def start_in
    nssm('get',resource[:name],'AppDirectory').to_s.gsub("\x00",'').chomp
  end

  def start_in=(value)
    nssm('set',resource[:name],'AppDirectory',resource[:start_in])
  end

  def parameters
    nssm('get',resource[:name],'AppParameters').to_s.gsub("\x00",'').chomp
  end

  def parameters=(value)
    nssm('set',resource[:name],'AppParameters',resource[:parameters])
  end

  def dependencies
    nssm('set',resource[:name],'DependOnService').to_s.gsub("\x00",'').chomp
  end

  def dependencies=(value)
    nssm('set',resource[:name],'DependOnService',resource[:dependencies])
  end

  def startuptype
    nssm('set',resource[:name],'Start').to_s.gsub("\x00",'').chomp
  end

  def startuptype=(value)
    nssm('set',resource[:name],'Start',resource[:startuptype])
  end


end
