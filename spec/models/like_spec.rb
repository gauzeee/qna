require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to(:likable) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:user_id).scoped_to(:likable_id, :likable_type) }
end
