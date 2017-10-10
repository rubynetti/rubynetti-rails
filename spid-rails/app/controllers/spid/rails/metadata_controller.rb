require_dependency "spid/rails/application_controller"

# Metadata for Service Provider
class Spid::Rails::MetadataController < ApplicationController
  def show
    settings = OneLogin::RubySaml::Settings.new
    # Indirizzo che l'identity provider chiama una volta che l'utente ha effettuato l'accesso.
    settings.assertion_consumer_service_url     = "http://localhost:3000/spid/session"
    # Tipologia di chiamata che l'identity provider dovrà utilizzare per rispondere al service provider.
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    # Indirizzo del metadata del service provider: /spid/metadata.
    settings.issuer = metadata_url

    # Prepare and generate xml
    metadata = OneLogin::RubySaml::Metadata.new
    xml = metadata.generate(settings)

    render xml: xml
  end
end
