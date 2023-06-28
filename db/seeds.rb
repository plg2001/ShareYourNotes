# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Note.create(name: 'Nota 1', description: 'Descrizione della Nota 1')
# Note.create(name: 'Nota 2', description: 'Descrizione della Nota 2')
# Note.create(name: 'Nota 3', description: 'Descrizione della Nota 3')
# Note.create(name: 'Nota 4', description: 'Descrizione della Nota 4')

note = Note.create!(
  name: "Appunti Analisi 1",
  description: "Questi sono appunti di Analisi 1 di Ingegenria Informatica e Automatica"
)

topic = Topic.find_by(name: "Ingegneria Informatica e Automatica")

tag = Tag.find_by(name: "Analisi 1")

if topic.nil?
  topic = Topic.create!(name: "Ingegneria Informatica e Automatica")
end

if tag.nil?
    tag = Tag.create!(name: "Analisi 1")
end

note_tag = NoteTag.create!(
  note: note,
  tag: tag
)

note_topic = NoteTopic.create!(
  note: note,
  topic: topic
)
