
require_relative "map_node"
require_relative "libraries/rotator"

class Map
  attr_accessor :polygon, :nodes

  def initialize(polygon)
    self.polygon = polygon
    self.nodes   = []
  end

  def base_angle
    Rotator.new(360.0/polygon)
  end

  def fill(position, radius)
    node = MapNode.new(self, position, radius)
    nodes << node

    node
  end

  def new_node(old_node, angle, radius)
    p = old_node.position + angle.to_vector * radius * 2

    node = MapNode.new(self, p, radius)
    nodes << node

    edge = Edge.new()
    node.new_connection(angle.flip, edge)
    old_node.new_connection(angle, edge)

    node
  end

  def collides?(position, radius)
    # loop over all nodes and return true if any are too near
    nodes.any? do |node|
      node.distance(position) < node.radius + radius
    end
  end
end
