# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::Permission do
  context 'schema' do
    before do
      subject.resource = 'users'
      subject.action = 'read'
      subject.scoped_id = 1
      subject.scoped_type = 'Project'
      subject.save!
    end

    it 'has resource' do
      expect(subject.resource).to eq 'users'
    end

    it 'has action' do
      expect(subject.action).to eq 'read'
    end

    it 'has scope_id' do
      expect(subject.scoped_id).to eq 1
    end

    it 'has scope_type' do
      expect(subject.scoped_type).to eq 'Project'
    end
  end

  context 'validations' do
    it 'validates name presence' do
      subject.save
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to eq(action: ["can't be blank"], resource: ["can't be blank"])
    end
  end
end
