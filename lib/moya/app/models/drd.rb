class Drd < ActiveRecord::Base
  include ActiveUUID::UUID
  include Crichton::Representor::State
  represents :drd
  state_method :status

  scope :status, -> (status) { where status: status }

  validates :name, :status, presence: true
  validates :name, length: { maximum: 50 }
  validates :status, inclusion: { in: %w(activated deactivated) }

  def activate!
    self.status = 'activated'
    save!
  end

  def deactivate!
    self.status = 'deactivated'
    save!
  end
end
