Puppet::Type.newtype(:windows_service) do
  include Puppet::Util


  @doc = <<-'EOT'
    Run a windows executable as a service or modify existing
    service properties using Non Sucking Service Manager (NSSM).
EOT

  newparam (:name) do
    desc "The name of this task.  Used for uniqueness and the service name"
    isnamevar
  end

end
