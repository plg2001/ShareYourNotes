# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Seed the RottenPotatoes DB with some movies.
more_notes = [
    {:id_n => '1', :user => 'Gianpiero',:rating => 'A',:text => 'La melodia triste del pianoforte riempì la stanza.',
      :release_date => '25-Nov-1992',},
    
    {:id_n => '2', :user => 'Pierluca',:rating => 'F',:text => 'Il gatto nero attraversò la strada senza guardare.',
      :release_date => '25-Oct-2001'},

    {:id_n => '84', :user => 'Francesco',:rating => 'C',:text => 'Il gatto nero attraversò la strada senza guardare.',
        :release_date => '5-Oct-1990'},

    {:id_n => '4', :user => 'Damiano',:rating => 'B',:text => 'Il gatto nero attraversò la strada senza guardare.',
        :release_date => '25-Oct-2001'},
  
  ]
  
  more_notes.each do |note|
    Note.create(note)
  end
