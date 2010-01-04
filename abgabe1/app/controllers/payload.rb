class Payload
  attr_accessor :id, :kind
  
  def initialize(params)
    @id = params[:id]
    @kind = params[:kind]
  end
end
