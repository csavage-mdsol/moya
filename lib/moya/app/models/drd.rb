require 'activeuuid'

class Drd < ActiveRecord::Base
  include ActiveUUID::UUID
  include Crichton::Representor::State
  represents :drd
  state_method :status

  before_validation(on: :create) do
    self.old_status ||= 'deactivated'
  end

  scope :status, -> (status) { where status: status }

  validates :name, :status, presence: true
  validates :name, length: { maximum: 50 }
  validates :status, :old_status, inclusion: { in: %w(activated deactivated renegade) }

  def activate!
    self.old_status = self.status
    self.status = 'activated'
    save!
  end

  def deactivate!
    self.old_status = self.status
    self.status = 'deactivated'
    save!
  end
end
