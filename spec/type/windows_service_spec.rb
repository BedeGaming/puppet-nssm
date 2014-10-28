require 'spec_helper'

windows_service = Puppet::Type.type(:windows_service)

describe windows_service do

  describe "when running on windows platform"  do

    let :facts do {
      :operatingsystem => 'windows',
      #:kernel => 'Linux'
    } end

    it "should have a default provider inheriting from Puppet::Provider" do
      windows_service.defaultprovider.ancestors.should be_include(Puppet::Provider)
    end
    it "should have a valid provider" do
      windows_service.new(:name => "foo").provider.class.ancestors.should be_include(Puppet::Provider)
    end
  end
  describe "when NOT running on windows platform"  do
    let :facts do {
      :operatingsystem => 'CentOS',
      :kernel => 'Linux'
    } end

    it "should NOT have a valid provider" do
      windows_service.new(:name => "foo").provider.class.ancestors.should_not be_include(Puppet::Provider)
    end
  end

  describe "basic structure" do
    it "should be able to create an instance" do
      expect { windows_service.new(:name => "bar").should_not be_nil }
    end

    it "should have a command property" do
      expect { described_class.attrclass(:command).ancestors.should be_include(Puppet::Property) }
    end

    it "should have documentation for its command property" do
      expect { described_class.attrclass(:command).doc.strip.should_not == "" }
    end

    it "should have a start_in property" do
      expect { described_class.attrclass(:start_in).ancestors.should be_include(Puppet::Property) }
    end

    it "should have documentation for its start_in property" do
      expect { described_class.attrclass(:start_in).doc.strip.should_not == "" }
    end

    it "should have a parameters property" do
      expect { described_class.attrclass(:parameters).ancestors.should be_include(Puppet::Property) }
    end

    it "should have documentation for its parameters property" do
      expect { described_class.attrclass(:parameters).doc.strip.should_not == "" }
    end

  end
end
