class Spid::SingleLogoutOperationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    logout_request = OneLogin::RubySaml::Logoutrequest.new()
    session[:transaction_id] = logout_request.uuid
    redirect_to logout_request.create(settings)
  end

  def create
    redirect_to welcome_path, notice: 'Utente correttamente sloggato'
  end

  private

  def settings
    parser = OneLogin::RubySaml::IdpMetadataParser.new

    settings = parser.parse_remote idp_xml(:test),
                                   true,
                                   sso_binding: [binding(:redirect)]

    settings.issuer        = spid_metadata_url # /metadata.xml
    settings.authn_context = authn_level 1

    settings.idp_cert = certificate :gov

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

  def authn_level level
    "https://www.spid.gov.it/SpidL#{level}"
  end

  def idp_xml idp
    case idp
    when :gov
      root_url + 'metadata-idp-gov.xml'
    when :poste
      'http://spidposte.test.poste.it/jod-fs/metadata/idp.xml'
    when :test
      root_url + 'metadata-idp-test-local.xml'
    end
  end

  def certificate idp
    case idp
    when :gov
      <<-CERT.chomp
-----BEGIN CERTIFICATE-----
MIICNTCCAZ6gAwIBAgIES343gjANBgkqhkiG9w0BAQUFADBVMQswCQYDVQQGEwJVUzELMAkGA1UE
CAwCQ0ExFjAUBgNVBAcMDU1vdW50YWluIFZpZXcxDTALBgNVBAoMBFdTTzIxEjAQBgNVBAMMCWxv
Y2FsaG9zdDAeFw0xMDAyMTkwNzAyMjZaFw0zNTAyMTMwNzAyMjZaMFUxCzAJBgNVBAYTAlVTMQsw
CQYDVQQIDAJDQTEWMBQGA1UEBwwNTW91bnRhaW4gVmlldzENMAsGA1UECgwEV1NPMjESMBAGA1UE
AwwJbG9jYWxob3N0MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCUp/oV1vWc8/TkQSiAvTou
sMzOM4asB2iltr2QKozni5aVFu818MpOLZIr8LMnTzWllJvvaA5RAAdpbECb+48FjbBe0hseUdN5
HpwvnH/DW8ZccGvk53I6Orq7hLCv1ZHtuOCokghz/ATrhyPq+QktMfXnRS4HrKGJTzxaCcU7OQID
AQABoxIwEDAOBgNVHQ8BAf8EBAMCBPAwDQYJKoZIhvcNAQEFBQADgYEAW5wPR7cr1LAdq+IrR44i
QlRG5ITCZXY9hI0PygLP2rHANh+PYfTmxbuOnykNGyhM6FjFLbW2uZHQTY1jMrPprjOrmyK5sjJR
O4d1DeGHT/YnIjs9JogRKv4XHECwLtIVdAbIdWHEtVZJyMSktcyysFcvuhPQK8Qc/E/Wq8uHSCo=
-----END CERTIFICATE-----
    CERT
    end
  end

end
