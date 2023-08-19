#Test sulla scrittura dei commenti

require 'rails_helper'

RSpec.feature 'Comments', type: :feature do
    let(:user) { User.create(
        username: 'test',
        email: 'test@example.com', 
        password: 'password'
        )
    }
    scenario 'A user comments a note' do
        
    end
end