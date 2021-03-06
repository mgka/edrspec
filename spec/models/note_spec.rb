# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }

  it 'is valid with a user, project, and message' do
    note = Note.new(
      message: 'This is a sample note.',
      user: user,
      project: project
    )
    expect(note).to be_valid
  end

  it 'is invalid without a message' do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  it { is_expected.to have_attached_file(:attachment) }

  describe 'search message for a term' do
    let!(:note1) do
      create(:note,
             project: project,
             user: user,
             message: 'This is the first note.')
    end

    let!(:note2) do
      create(:note,
             project: project,
             user: user,
             message: 'This is the second note.')
    end

    let!(:note3) do
      create(:note,
             project: project,
             user: user,
             message: 'First, preheat the oven.')
    end

    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(note1, note3)
        expect(Note.search('first')).to_not include(note2)
      end
    end

    context 'when no match is found' do
      it 'returns an empty collection' do
        expect(Note.search('message')).to be_empty
      end
    end
  end
end
