class BaseService

  def self.execute(*args, &block)
    new(*args, &block).execute
  end

end