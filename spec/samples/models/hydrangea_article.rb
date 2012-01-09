require "active-fedora"
require "lib/active_fedora/samples/hydra-mods_article_datastream"
require "lib/active_fedora/samples/hydra-rights_metadata_datastream"

# This Model is used to load & index the hydrangea:fixture_mods_article1 fixture for use in tests.
#
# See lib/samples/sample_thing.rb for a fuller, annotated example of an ActiveFedora Model
class HydrangeaArticle < ActiveFedora::Base
  
  has_metadata :name => "descMetadata", :type=> Hydra::ModsArticleDatastream  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadataDatastream

end
