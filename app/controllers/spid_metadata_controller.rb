
class SpidMetadataController < ApplicationController

  def show
    metadata = OneLogin::RubySaml::Metadata.new
    settings = OneLogin::RubySaml::Settings.new
    settings.assertion_consumer_service_url = "http://localhost:3000/spid/create"
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    settings.issuer = spid_metadata_url
    render xml: metadata.generate(settings)
  end

end
