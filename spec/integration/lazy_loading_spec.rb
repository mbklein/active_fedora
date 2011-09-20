require File.join( File.dirname(__FILE__), "../spec_helper" )

class MockLazyObject < ActiveFedora::Base
  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    m.field "holder", :string
    m.field "location", :string
  end
end

describe ActiveFedora::Base do
  before(:each) do
    @test_object = MockLazyObject.new
    @test_object.properties.update_attributes(:holder => 'Hiya', :location=>'Ipswitch')
    @test_object.save
  end

  it "should load first from solr" do
    obj = MockLazyObject.find(@test_object.pid)
    obj.should_not be_nil

    ### This shouldn't cause a fedora load
    obj.holder_t.should == ['Hiya'] 

    ### This should trigger a fedora load
    obj.properties.holder_values.should == ['Hiya']

    ### This should not trigger a fedora load since it's already loaded
    obj.properties.location_values.should == ['Ipswitch']
    
  end
  
  after(:each) do
    @test_object.delete
  end
end


