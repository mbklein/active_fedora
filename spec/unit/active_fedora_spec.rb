require File.join( File.dirname(__FILE__), "../spec_helper" )

# For testing Module-level methods like ActiveFedora.init

describe ActiveFedora do
  
  describe ".push_models_to_fedora" do
    it "should push the model definition for each of the ActiveFedora models into Fedora CModel objects" do
      pending
      # find all of the models 
      # create a cmodel for each model with the appropriate pid
      # push the model definition into the cmodel's datastream (ie. dsname: oral_history.rb vs dsname: ruby)
    end
  end

  describe ".init" do

    describe "outside of rails" do
      it "should load the default packaged config/fedora.yml file if no explicit config path is passed" do
        ActiveFedora.init()
        ActiveFedora.fedora.fedora_url.to_s.should == "http://fedoraAdmin:fedoraAdmin@127.0.0.1:8983/fedora"
      end
      it "should load the passed config if explicit config passed in" do
        ActiveFedora.init('./spec/fixtures/rails_root/config/fedora.yml')
        ActiveFedora.fedora.fedora_url.to_s.should == "http://fedoraAdmin:fedoraAdmin@testhost.com:8983/fedora"
      end
    end

    describe "within rails" do

      before(:all) do
        Object.const_set("Rails",String)
      end

      after(:all) do
        if Rails == String
          Object.send(:remove_const,:Rails)
        end
      end

      describe "versions prior to 3.0" do
        describe "with explicit config path passed in" do
          it "should load the specified config path" do
            File.expects(:exist?).with("../../config/fedora.yml")
            File.expects(:exist?).with('./spec/unit/../../lib/../config/predicate_mappings.yml').returns(true)
            ActiveFedora.init("../../config/fedora.yml")
            ActiveFedora.solr.class.should == ActiveFedora::SolrService
            ActiveFedora.fedora.class.should == Fedora::Repository
          end
        end

        describe "with no explicit config path" do
          it "should look for the file in the path defined at Rails.root" do
            Rails.expects(:root).returns(File.join(File.dirname(__FILE__),"../fixtures/rails_root"))
            ActiveFedora.init()
            ActiveFedora.solr.class.should == ActiveFedora::SolrService
            ActiveFedora.fedora.class.should == Fedora::Repository
            ActiveFedora.fedora.fedora_url.to_s.should == "http://fedoraAdmin:fedoraAdmin@testhost.com:8983/fedora"
          end
          it "should load the default file if no config is found at Rails.root" do
            Rails.expects(:root).returns(File.join(File.dirname(__FILE__),"../fixtures/bad/path/to/rails_root"))
            ActiveFedora.init()
            ActiveFedora.solr.class.should == ActiveFedora::SolrService
            ActiveFedora.fedora.class.should == Fedora::Repository
            ActiveFedora.fedora.fedora_url.to_s.should == "http://fedoraAdmin:fedoraAdmin@127.0.0.1:8983/fedora"
          end
        end
      end
    end
  end

end
