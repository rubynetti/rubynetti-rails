class Spid::SessionController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    parser = OneLogin::RubySaml::IdpMetadataParser.new

    #settings = parser.parse_remote("http://spidposte.test.poste.it/jod-fs/metadata/idp.xml", true, {
    settings = parser.parse_remote("http://localhost:3000/metadata-idp-fake-gov.xml", true, {
      sso_binding: ["urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"]
    })

    settings.issuer        = spid_metadata_url # /metadata.xml
    settings.authn_context = 'https://www.spid.gov.it/SpidL1'

    request = OneLogin::RubySaml::Authrequest.new
    output = request.create(settings)
    redirect_to output
  end

  def create
    render html: params.inspect
  end

end
