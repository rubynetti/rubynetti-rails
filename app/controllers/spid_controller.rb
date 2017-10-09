class SpidController < ApplicationController

  private

  def saml_settings
    parser = OneLogin::RubySaml::IdpMetadataParser.new

    settings = parser.parse_remote idp_xml(:gov),
                                   true,
                                   sso_binding: [binding(:redirect)]

    settings.issuer        = spid_metadata_url
    settings.authn_context = authn_context(params[:spid_level])

    settings.sessionindex = session[:index]

    settings
  end

  def binding request_type
    formatted_type = case request_type
    when :post;     'POST'
    when :redirect; 'Redirect'
    end
    "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-#{formatted_type}"
  end

  def authn_context spid_level = 1
    "https://www.spid.gov.it/SpidL#{spid_level}"
  end

  def idp_xml idp = :test
    case idp
    when :gov
      root_url + 'metadata-idp-gov.xml'
    when :poste
      'http://spidposte.test.poste.it/jod-fs/metadata/idp.xml'
    when :test
      root_url + 'metadata-idp-test-local.xml'
    end
  end

end
