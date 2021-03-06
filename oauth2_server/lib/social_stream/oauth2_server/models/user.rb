module SocialStream
  module Oauth2Server
    module Models
      module User
        extend ActiveSupport::Concern

        included do
          has_many :oauth2_tokens,
                   dependent: :destroy

          has_many :authorization_codes,
                   class_name: 'Oauth2Token::AuthorizationCode'

          has_many :access_tokens,
                   class_name: 'Oauth2Token::AccessToken'

          has_many :refresh_tokens,
                   class_name: 'Oauth2Token::RefreshToken'
        end

        # Is {#client} authorized by this {User}
        def client_authorized?(client)
          contact_to!(client).relation_ids.include? Relation::Auth.instance.id
        end

        # Create a new tie to {Site::Client}
        def client_authorize!(client)
          unless contact_to!(client).relation_ids.include?(Relation::Auth.instance.id)
            contact_to!(client).relation_ids += [ Relation::Auth.instance.id ]
          end
        end
      end
    end
  end
end
