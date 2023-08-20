#Test sulla scrittura dei commenti

require 'rails_helper'

RSpec.feature 'Comments', type: :feature do
    let!(:user) { 
      User.create(username: 'test', email: 'test@example.com', password: 'password')
    }

    let!(:tag1) {
      Tag.create(name: 'Limiti Analisi')
    }

    let!(:tag2) {
      Tag.create(name: 'Serie di Fourier')
    }

    let!(:tag3) {
      Tag.create(name: 'Regressione Lineare')
    }
    
    let!(:topic1) {
      Topic.create(name: 'Analisi 1')
    }

    let!(:topic2) {
      Topic.create(name: 'Analisi 2')
    }

    let!(:topic3) {
      Topic.create(name: 'Fondamenti di IA')
    }

    let!(:faculty1) {
      Faculty.create(name: 'Ingegneria Informatica')
    }

    let!(:faculty2) {
      Faculty.create(name: 'Ingegneria Meccanica')
    }

    let!(:faculty3) {
      Faculty.create(name: 'Chimica')
    }

    background do
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

      expect(find('#tag'+tag1.id.to_s)).not_to be_checked
      find('input', id: 'tag'+tag1.id.to_s).click
      expect(find("#tag"+tag1.id.to_s)).to be_checked
      
      expect(find('#tag'+tag2.id.to_s)).not_to be_checked
      find('input', id: 'tag'+tag2.id.to_s).click
      expect(find("#tag"+tag2.id.to_s)).to be_checked

      expect(find('#topic'+topic1.id.to_s)).not_to be_checked
      find('input', id: 'topic'+topic1.id.to_s).click
      expect(find("#topic"+topic1.id.to_s)).to be_checked

      expect(find('#topic'+topic2.id.to_s)).not_to be_checked
      find('input', id: 'topic'+topic2.id.to_s).click
      expect(find("#topic"+topic2.id.to_s)).to be_checked
      
      expect(page).to have_select('note_faculty_id')

      select('Ingegneria Informatica', from: 'note_faculty_id')

      expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

      click_button 'Carica'
      
      expect(current_path).to eq "/notes/1"
    end

  scenario 'A valid user comments a valid note with an valid comment' do
    
    fill_in 'Commento', with: 'Questa è un test del commento'

    click_button 'Add comment'

    expect(current_path).to eq "/notes/1"

    expect(page.find('.commento')).to have_text(user.username + ':')

    expect(page.find('.comment-content')).to have_text('Questa è un test del commento')
    
  end

  scenario 'A valid user comments a valid note with an invalid comment' do
    
    fill_in 'Commento', with: ' '

    click_button 'Add comment'

    expect(current_path).to eq "/notes/1"

    expect(page).not_to have_selector('.commento')
    
    expect(page).not_to have_selector('.comment-content')
    
  end

end