# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

=begin
note = Note.create!(
  name: "Appunti Analisi 2",
  description: "Questi sono appunti di Analisi 2 di Ingegneria Informatica e Automatica",
  uploaded_at: DateTime.new(2020,02,24)
)

topic = Topic.find_by(name: "Ingegneria Informatica e Automatica")

tag = Tag.find_by(name: "Analisi 2")

if topic.nil?
  topic = Topic.create!(name: "Ingegneria Informatica e Automatica")
end

if tag.nil?
  tag = Tag.create!(name: "Analisi 2")
end

note_tag = NoteTag.create!(
  note: note,
  tag: tag
)

note_topic = NoteTopic.create!(
  note: note,
  topic: topic
)
=end

note = Note.find_by(name: "Appunti Analisi 1")
note.update(description: "Questi sono appunti di Analisi 1 di Ingegneria Informatica e Automatica dell'anno 2008/2009", uploaded_at: DateTime.new(2010,07,12))

note = Note.find_by(name: "Appunti Analisi 2")
note.update(description: "Questi sono appunti di Analisi 2 di Ingegneria Informatica e Automatica dell'anno 2012/2013", uploaded_at: DateTime.new(2014,03,20))

note = Note.find_by(name: "Sistemi di Calcolo")
note.update(description: "Questi sono appunti di Sistemi di Calcolo di Ingegneria Informatica e Automatica dell'anno 2015/2016", uploaded_at: DateTime.new(2017,12,10))

note = Note.find_by(name: "Sistemi di Calcolo 2")
note.update(description: "Questi sono appunti di Sistemi di Calcolo 2 di Ingegneria Informatica e Automatica dell'anno 2013/2014", uploaded_at: DateTime.new(2015,10,13))

note = Note.find_by(name: "Fondamenti di IA")
note.update(description: "Questi sono appunti di Fondamenti di IA di Ingegneria Informatica e Automatica dell'anno 2018/2019", uploaded_at: DateTime.new(2020,11,13))

# note = Note.find_by(name: "Nota 1", description: "Descrizione della Nota 1")
# note.destroy if note
