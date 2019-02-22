# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions do
  describe '.create_role' do
    it 'creates role' do
      user_role = described_class.create_role(name: 'user')

      expect(user_role.name).to eq 'user'
    end

    it 'invalid with empty name' do
      user_role = described_class.create_role(name: '')

      expect(user_role).to be_invalid
      expect(user_role.errors.messages).to eq(name: ["can't be blank"])
    end

    it 'invalid with taken name' do
      _user_role = described_class.create_role(name: 'user')
      new_role = described_class.create_role(name: 'user')

      expect(new_role).to be_invalid
      expect(new_role.errors.messages).to eq(name: ['has already been taken'])
    end
  end

  describe '.get_role' do
    it 'finds role by name' do
      user_role = described_class.create_role(name: 'user')
      role = described_class.get_role(:user)

      expect(role.id).to eq user_role.id
    end

    it 'returns nil in case of not existing role' do
      expect(described_class.get_role(:none)).to eq nil
    end
  end

  describe '.get_role!' do
    it 'finds role by name' do
      user_role = described_class.create_role(name: 'user')
      role = described_class.get_role!(:user)

      expect(role.id).to eq user_role.id
    end

    it 'raise exception for non existing role' do
      expect { described_class.get_role!(:none) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.update_role' do
    it 'updates role name' do
      user_role = described_class.create_role(name: 'user')
      described_class.update_role(:user, name: 'super_user')

      user_role.reload

      expect(user_role.name).to eq 'super_user'
    end

    it 'raise exception for non existing role' do
      expect { described_class.update_role(:none, name: 'super_user') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.delete_role' do
    it 'removes role' do
      user_role = described_class.create_role(name: 'user')
      described_class.delete_role(:user)

      expect { user_role.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raise exception for non existing role' do
      expect { described_class.delete_role(:none) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
