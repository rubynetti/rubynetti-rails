require 'net/http'
require 'nokogiri'
require 'onelogin/ruby-saml/idp_metadata_parser'
require 'ruby-saml'
require 'pp'

class SpidController < ApplicationController

    def index
      parser = OneLogin::RubySaml::IdpMetadataParser.new


      settings = parser.parse_remote("http://spidposte.test.poste.it/jod-fs/metadata/idp.xml")

      settings.assertion_consumer_service_url = "http://localhost:3000"
      settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"

      settings.issuer= metadata_url
      settings.authn_context = 'https://www.spid.gov.it/SpidL1'


      request = OneLogin::RubySaml::Authrequest.new
      output = request.create(settings)
      redirect_to output
    end


    # Metadata locale
    def metadata
      metadata = OneLogin::RubySaml::Metadata.new
      settings.assertion_consumer_service_url = "http://localhost:3000"
      settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"

      render xml: metadata.generate(saml_settings)
    end


end
