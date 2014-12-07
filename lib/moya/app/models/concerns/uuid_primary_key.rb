#require 'secure_random'

# This module sets a before create hook to generate a uuid for use as a primary key
module UUIDPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :set_uuid
    before_save :set_uuid
  end

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

end
