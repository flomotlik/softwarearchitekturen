class Payload
  attr_accessor :id, :type
  
  def initialize(params)
    @id = params[:id]
    @type = params[:type]
  end
end
