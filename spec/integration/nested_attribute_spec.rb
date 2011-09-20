require 'spec_helper'

describe "NestedAttribute behavior" do

  before do
    class Gar < ActiveFedora::Base
      belongs_to :car, :property=>:has_member
      has_metadata :type=>ActiveFedora::MetadataDatastream, :name=>"someData" do |m|
        m.field "uno", :string
        m.field "dos", :string
      end
      delegate :uno, :to=>'someData', :unique=>true
      delegate :dos, :to=>'someData', :unique=>true
    end
    class Car < ActiveFedora::Base
      has_many :gars, :property=>:has_member
      accepts_nested_attributes_for :gars#, :allow_destroy=>true
    end
    @car = Car.new
    @car.save
    @bar1 = Gar.new(:car=>@car)
    @bar1.save

    @bar2 = Gar.new(:car=>@car)
    @bar2.save

  end

  it "should update the child objects" do
    @car.attributes = {:gars_attributes=>[{:id=>@bar1.pid, :uno=>"bar1 uno"}, {:uno=>"newbar uno"}, {:id=>@bar2.pid, :_destroy=>'1', :uno=>'bar2 uno'}]}
    Gar.find(@bar1.pid).uno.should == 'bar1 uno'
    # pending the fix of nested_attributes_options
    #Gar.find(@bar2.pid).should be_nil

  end

    

end
