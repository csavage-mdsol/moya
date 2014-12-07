class Drd < ActiveRecord::Base
  include UUIDPrimaryKey
  #include Crichton::Representor::State
  #represents :drd
  #state_method :status

  validates :name, :status, presence: true

  def activate
    self.status = 'activated'
    save
  end

  def deactivate
    self.status = 'deactivated'
    save
  end
end
