
class SpidController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :print_response

  def index
    parser = OneLogin::RubySaml::IdpMetadataParser.new

    #settings = parser.parse_remote("http://spidposte.test.poste.it/jod-fs/metadata/idp.xml", true, {
    settings = parser.parse_remote("http://localhost:3000/metadata-idp-fake.xml", true, {
      sso_binding: ["urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"]
    })

    # Dati a cui IDP farà riferimento per rispondere
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
    # settings.assertion_consumer_service_url = "http://localhost:3000/print_response"

    settings.issuer        = metadata_url
    settings.authn_context = 'https://www.spid.gov.it/SpidL1'


    request = OneLogin::RubySaml::Authrequest.new
    output = request.create(settings)
    redirect_to output
  end

  def print_response
    render html: params.inspect
  end


  # Metadata locale
  def metadata
    metadata = OneLogin::RubySaml::Metadata.new
    settings = OneLogin::RubySaml::Settings.new
    settings.assertion_consumer_service_url = "http://localhost:3000/print_response"
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
    settings.issuer = metadata_url
    render xml: metadata.generate(settings)
  end

end
