class SshKey < ApplicationRecord
  belongs_to :user

  after_create :sync_to_starhub_server

  validates_presence_of :name, :ssh_key
  validates_uniqueness_of :name, :ssh_key

  def starhub_synced!
    self.starhub_synced = true
    self.save
  end

  def starhub_synced?
    starhub_synced == true
  end

  def sync_to_starhub_server
    res = Starhub.api.create_ssh_key(user.name, name, ssh_key)
    starhub_synced! if res.status >= 200 && res.status <= 299
  end
end
