class Spid::Rails::SessionController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    parser = OneLogin::RubySaml::IdpMetadataParser.new

    #settings = parser.parse_remote("http://spidposte.test.poste.it/jod-fs/metadata/idp.xml", true, {
    settings = parser.parse_remote("http://localhost:3000/metadata-idp-fake-gov.xml", true, {
      sso_binding: ["urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"]
    })

    settings.issuer        = metadata_url # /metadata.xml
    settings.authn_context = 'https://www.spid.gov.it/SpidL1'

    request = OneLogin::RubySaml::Authrequest.new
    output = request.create(settings)
    redirect_to output
  end

  def create
    settings = OneLogin::RubySaml::Settings.new()
    settings.idp_cert = <<-CERT.chomp
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

    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], skip_subject_confirmation: true)
    response.settings = settings

    if response.is_valid?
      redirect_to main_app.root_path, notice: 'Utente correttamente loggato'
    else
      render plain: response.inspect
    end

  end

end
