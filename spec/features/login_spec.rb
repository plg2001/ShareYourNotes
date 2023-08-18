require 'rails_helper'

RSpec.feature 'CaricaAppunto', type: :feature do
  let(:user) { User.create(
        username: 'test',
        email: 'test@example.com', 
        password: 'password'
        )
    }
    let(:tag) { Tag.create(
        name: 'Limiti Analisi'
        )
    }
    let(:topic) { Topic.create(
            name: 'Analisi 1'
        )
    }
    let(:faculty) { Faculty.create(
        name: 'Ingegneria Informatica'
        )
    }

  scenario 'a valid user uploads a valid note' do
    tag
    topic
    faculty
    user 
    user.confirm
    visit signin_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page.find('#messaggio_login')).to have_text('Benvenuto ' + user.username + ' su ShareYourNotes')
    visit new_note_path
    fill_in 'Name', with: 'note test'
    fill_in 'Description', with: 'note description'
    attach_file('file', Rails.root + 'spec/support/files/test_file.docx')

    expect(find('#tag'+tag.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag.id.to_s).click

    expect(find("#tag"+tag.id.to_s)).to be_checked

    expect(find('#topic'+topic.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic.id.to_s).click

    expect(find("#topic"+topic.id.to_s)).to be_checked
    
    expect(page).to have_select('Faculty')

    select('Option 2', from: 'Faculty')

    expect(page).to have_select('Faculty', selected: 'Option 2')


  end

  scenario 'a user provides invalid credentials' do

    visit signin_path
    fill_in 'Email', with: 'invalid@example.com'
    fill_in 'Password', with: 'wrong_password'
    click_button 'Log in'

    expect(current_path).to eq "/users/sign_in"
  end
end