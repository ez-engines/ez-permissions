# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::Role do
  context 'schema' do
    it 'has name' do
      subject.name = 'admin'
      subject.save!
      expect(subject.name).to eq 'admin'
    end
  end

  context 'validations' do
    it 'validates name presence' do
      subject.save
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to eq(name: ["can't be blank"])
    end
  end

  context 'associations' do
    it 'has_and_belongs_to_many permissions' do
      expect(subject.permissions).to eq([])
    end
  end
end
