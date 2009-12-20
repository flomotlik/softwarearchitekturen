class Payload
  attr_accessor :id, :type
  
  def initialize(params)
    @id = [:id]
    @type = [:type]
  end
end