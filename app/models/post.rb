require 'obscenity/active_model'

class Post < ApplicationRecord
    validates :user_id, format: { with: /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/ }
    validates :insights, obscenity: { 
        sanitize: true, 
        replacement: "[censored]" 
    }, 
    :length => { 
        :maximum => 1000, 
        :message => "The review must not exceed 1000 characters" 
    }
end