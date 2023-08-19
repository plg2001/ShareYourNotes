#Test su il caricamento degli appunti

require 'rails_helper'

RSpec.feature ' New Note', type: :feature do
  let(:user) { User.create(
        username: 'test',
        email: 'test@example.com', 
        password: 'password'
        )
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

  scenario 'A valid user uploads a valid note' do
    tag1
    topic1
    faculty1
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

    expect(find('#tag'+tag1.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag1.id.to_s).click

    expect(find("#tag"+tag1.id.to_s)).to be_checked

    expect(find('#topic'+topic1.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic1.id.to_s).click

    expect(find("#topic"+topic1.id.to_s)).to be_checked
    
    expect(page).to have_select('note_faculty_id')

    select('Ingegneria Informatica', from: 'note_faculty_id')

    expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

    click_button 'Carica'
    
    expect(current_path).to eq "/notes/1"
  end

  scenario 'A valid user uploads an invalid note because miss the name' do
    tag1
    topic1
    faculty1
    user 
    user.confirm
    visit signin_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page.find('#messaggio_login')).to have_text('Benvenuto ' + user.username + ' su ShareYourNotes')
    visit new_note_path
    fill_in 'Description', with: 'note description'

    attach_file('file', Rails.root + 'spec/support/files/test_file.docx')

    expect(find('#tag'+tag1.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag1.id.to_s).click

    expect(find("#tag"+tag1.id.to_s)).to be_checked

    expect(find('#topic'+topic1.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic1.id.to_s).click

    expect(find("#topic"+topic1.id.to_s)).to be_checked
    
    expect(page).to have_select('note_faculty_id')

    select('Ingegneria Informatica', from: 'note_faculty_id')

    expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

    click_button 'Carica'
    
    expect(current_path).to eq "/notes"
  end

  scenario 'A valid user uploads an invalid note because miss the description' do
    tag1
    topic1
    faculty1
    user 
    user.confirm
    visit signin_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page.find('#messaggio_login')).to have_text('Benvenuto ' + user.username + ' su ShareYourNotes')
    visit new_note_path
    fill_in 'Name', with: 'note test'

    attach_file('file', Rails.root + 'spec/support/files/test_file.docx')

    expect(find('#tag'+tag1.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag1.id.to_s).click

    expect(find("#tag"+tag1.id.to_s)).to be_checked

    expect(find('#topic'+topic1.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic1.id.to_s).click

    expect(find("#topic"+topic1.id.to_s)).to be_checked
    
    expect(page).to have_select('note_faculty_id')

    select('Ingegneria Informatica', from: 'note_faculty_id')

    expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

    click_button 'Carica'
    
    expect(current_path).to eq "/notes"
  end

  scenario 'A valid user uploads an invalid note because miss the file' do
    tag1
    topic1
    faculty1
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

    expect(find('#tag'+tag1.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag1.id.to_s).click

    expect(find("#tag"+tag1.id.to_s)).to be_checked

    expect(find('#topic'+topic1.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic1.id.to_s).click

    expect(find("#topic"+topic1.id.to_s)).to be_checked
    
    expect(page).to have_select('note_faculty_id')

    select('Ingegneria Informatica', from: 'note_faculty_id')

    expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

    click_button 'Carica'
    
    expect(current_path).to eq "/notes"
  end

  scenario 'A valid user uploads an invalid note because miss the tags' do
    tag1
    topic1
    faculty1
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

    expect(find('#topic'+topic1.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic1.id.to_s).click

    expect(find("#topic"+topic1.id.to_s)).to be_checked
    
    expect(page).to have_select('note_faculty_id')

    select('Ingegneria Informatica', from: 'note_faculty_id')

    expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

    click_button 'Carica'
    
    expect(current_path).to eq "/notes"
  end

  scenario 'A valid user uploads an invalid note because miss the topics' do
    tag1
    topic1
    faculty1
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

    expect(find('#tag'+tag1.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag1.id.to_s).click

    expect(find("#tag"+tag1.id.to_s)).to be_checked
    
    expect(page).to have_select('note_faculty_id')

    select('Ingegneria Informatica', from: 'note_faculty_id')

    expect(page).to have_select('note_faculty_id', selected: 'Ingegneria Informatica')

    click_button 'Carica'
    
    expect(current_path).to eq "/notes"
  end

  scenario 'A valid user uploads an invalid note because miss the faculty' do
    tag1
    topic1
    faculty1
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

    expect(find('#tag'+tag1.id.to_s)).not_to be_checked
    find('input', id: 'tag'+tag1.id.to_s).click

    expect(find("#tag"+tag1.id.to_s)).to be_checked

    expect(find('#topic'+topic1.id.to_s)).not_to be_checked
    find('input', id: 'topic'+topic1.id.to_s).click

    expect(find("#topic"+topic1.id.to_s)).to be_checked

    click_button 'Carica'
    
    expect(current_path).to eq "/notes"
  end
end