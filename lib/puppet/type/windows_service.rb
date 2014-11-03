include Puppet::Util

Puppet::Type.newtype(:windows_service) do
  ensurable


  @doc = <<-'EOT'
    Run a windows executable as a service or modify existing
    service properties using Non Sucking Service Manager (NSSM).
EOT

  newparam(:name) do
    desc "The name of this task.  Used for uniqueness and the service name"
    isnamevar
  end

  newproperty(:command) do
    desc "Command to execute for the service"
  end

  newproperty(:start_in) do
    desc "Which directory the service should start in"
  end

  newproperty(:parameters, :array_matching => :all) do
    desc "Parameters to run the command with"
    def insync?(is)
      is == should
    end
  end
end
