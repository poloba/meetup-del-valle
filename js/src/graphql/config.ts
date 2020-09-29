import gql from "graphql-tag";

export const CONFIG = gql`
  query {
    config {
      name
      description
      registrationsOpen
      registrationsAllowlist
      demoMode
      countryCode
      anonymous {
        participation {
          allowed
          validation {
            email {
              enabled
              confirmationRequired
            }
            captcha {
              enabled
            }
          }
        }
        eventCreation {
          allowed
          validation {
            email {
              enabled
              confirmationRequired
            }
            captcha {
              enabled
            }
          }
        }
        reports {
          allowed
        }
        actorId
      }
      location {
        latitude
        longitude
        # accuracyRadius
      }
      maps {
        tiles {
          endpoint
          attribution
        }
      }
      geocoding {
        provider
        autocomplete
      }
      resourceProviders {
        type
        endpoint
        software
      }
      features {
        groups
        eventCreation
      }
      auth {
        ldap
        oauthProviders {
          id
          label
        }
      }
    }
  }
`;

export const TERMS = gql`
  query Terms($locale: String) {
    config {
      terms(locale: $locale) {
        type
        url
        bodyHtml
      }
    }
  }
`;

export const ABOUT = gql`
  query About {
    config {
      name
      description
      longDescription
      contact
      registrationsOpen
      registrationsAllowlist
      anonymous {
        participation {
          allowed
        }
      }
      version
      federating
    }
  }
`;

export const RULES = gql`
  query Rules {
    config {
      rules
    }
  }
`;

export const PRIVACY = gql`
  query Privacy($locale: String) {
    config {
      privacy(locale: $locale) {
        type
        url
        bodyHtml
      }
    }
  }
`;

export const TIMEZONES = gql`
  query {
    config {
      timezones
    }
  }
`;
