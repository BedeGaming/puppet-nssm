Puppet::Type.type(:windows_service).provide(:nssm) do
  desc "The non sucking windows service experience. Hopefully."

  confine :operatingsystem => :windows

  commands :nssm => 'nssm'

  def exists?
    begin
      output = nssm(['status',resource[:name]])
    rescue Puppet::ExecutionFailure => e # Means a non zero exit code was returned
      Puppet.debug("#nssm exists has an error -> #{e.inspect}")
      return false
    end
    return true
  end

  def create
    Puppet.debug("#nssm installing #{resource[:name]} with command #{resource[:command]} and parameters #{resource[:parameters]}.")
    nssm('install',resource[:name],"#{resource[:command]}",resource[:parameters])
  end

  def destroy
    Puppet.debug("#nssm destroy the resource #{resource[:name]}!")
    nssm(['remove',resource[:name]])
  end 
end

