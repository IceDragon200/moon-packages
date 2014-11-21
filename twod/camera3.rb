class Camera3 < CameraBase
  include Movable3

  field :position, type: Moon::Vector3, default: proc{ |t| t.new }
  field :tilesize, type: Moon::Vector3, default: proc{ |t| t.new(32, 32, 32) }
  def view
    @position + @viewport.xyz
  end
end
