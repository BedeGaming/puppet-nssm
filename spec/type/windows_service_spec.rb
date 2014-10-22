require 'spec_helper'
#require 'pry'

windows_service = Puppet::Type.type(:windows_service)

describe windows_service do

=begin
  describe "when windows_service is present" do
    it "should have a default provider inheriting from Puppet::Provider" do
      windows_service.defaultprovider.ancestors.should be_include(Puppet::Provider)
    end
    it "should have a valid provider" do
      windows_service.new(:name => "foo").provider.class.ancestors.should be_include(Puppet::Provider)
    end
  end

  before :each do
    @provider_class = described_class.provide(:simple) do
      # has_features :feature1 :feature2
      mk_resource_methods
      def create; end
      def delete; end
      def exists?; get(:ensure) != :absent; end
      def flush; end
      def self.instances; []; end
    end
    described_class.stub(:defaultprovider).and_return @provider_class
  end


  it "should be able to create an instance" do
    described_class.new(:name => 'config0').should_not be_nil
  end
=end

  describe "basic structure" do
    it "should be able to create an instance" do
      provider_class = Puppet::Type::Windows_service.provider(Puppet::Type::Windows_service.providers[0])
      Puppet::Type::Windows_service.expects(:defaultprovider).returns provider_class
      windows_service.new(:name => "bar").should_not be_nil
    end
  end
end
