# Metadata for Service Provider

class Spid::MetadataController < ApplicationController

  def show
    settings = OneLogin::RubySaml::Settings.new
    # Indirizzo che l'identity provider chiama una volta che l'utente ha effettuato l'accesso.
    settings.assertion_consumer_service_url     = "http://localhost:3000/spid/session"
    # Tipologia di chiamata che l'identity provider dovrà utilizzare per rispondere al service provider.
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    # Indirizzo del metadata del service provider: /spid/metadata.
    settings.issuer = spid_metadata_url

    # Generate xml
    metadata = OneLogin::RubySaml::Metadata.new
    xml = metadata.generate(settings)

    render xml: metadata.generate(xml)
  end

end
