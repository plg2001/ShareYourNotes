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
  description: "Questi sono appunti di Analisi 2 di Ingegneria Meccanica dell'anno 2010/2011",
  uploaded_at: DateTime.strptime("20-04-2020", "%d-%m-%Y")
)

topic = Topic.find_by(name: "Ingegneria Meccanica")
tag = Tag.find_by(name: "Analisi 2")

if topic.nil?
  topic = Topic.create!(name: "Ingegneria Meccanica")
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


note = Note.find_by(name: "Appunti Analisi 1")
note.update(description: "Questi sono appunti di Analisi 1 di Ingegneria Informatica e Automatica dell'anno 2008/2009", uploaded_at: Date.parse("12-07-2010"))

note = Note.find_by(name: "Appunti Analisi 2")
note.update(description: "Questi sono appunti di Analisi 2 di Ingegneria Informatica e Automatica dell'anno 2012/2013", uploaded_at: Date.parse("20-03-2014"))

note = Note.find_by(name: "Sistemi di Calcolo")
note.update(description: "Questi sono appunti di Sistemi di Calcolo di Ingegneria Informatica e Automatica dell'anno 2015/2016", uploaded_at: Date.parse("10-12-2017"))

note = Note.find_by(name: "Sistemi di Calcolo 2")
note.update(description: "Questi sono appunti di Sistemi di Calcolo 2 di Ingegneria Informatica e Automatica dell'anno 2013/2014", uploaded_at: Date.parse("13-10-2015"))

note = Note.find_by(name: "Fondamenti di IA")
note.update(description: "Questi sono appunti di Fondamenti di IA di Ingegneria Informatica e Automatica dell'anno 2018/2019", uploaded_at: Date.parse("13-11-2020"))
=end

# note = Note.find_by(name: "Nota 1", description: "Descrizione della Nota 1")
# note.destroy if note

Note.all.update_all(views: 0, downloads: 0)
