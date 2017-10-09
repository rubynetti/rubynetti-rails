# Metadata for Service Provider

class Spid::MetadataController < ApplicationController

  def show
    settings = OneLogin::RubySaml::Settings.new
    # Indirizzo del metadata del service provider: /spid/metadata.
    settings.issuer = spid_metadata_url
    # Indirizzo che l'identity provider chiama una volta che l'utente ha effettuato l'accesso (default-binding: POST).
    settings.assertion_consumer_service_url = spid_sso_url
    # Indirizzo a cui l'dentity provider chiama una volta che l'utente ha effettuato il logout (default-binding: Redirect).
    settings.single_logout_service_url = spid_slo_url
    # Richiedi firma all'IDP
    # TODO: La firma non viene controllata
    settings.security[:want_assertions_signed] = true

    metadata = OneLogin::RubySaml::Metadata.new
    xml = metadata.generate(settings)

    render xml: xml
  end

end
