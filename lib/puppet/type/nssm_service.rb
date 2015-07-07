include Puppet::Util

Puppet::Type.newtype(:nssm_service) do
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

  newproperty(:parameters) do
    desc "Parameters to run the command with"
  end
end
