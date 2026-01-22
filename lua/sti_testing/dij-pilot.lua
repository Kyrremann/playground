local Dijkstra = {}

function Dijkstra:init(map)
    self.map = map
    self.width = #map[1]
    self.height = #map
    self.queue = {}
    self.visited = {}
    self.distances = {}
    self.previous = {}
end

function Dijkstra:calculate(start)
    for y = 1, self.height do
        self.distances[y] = {}
        self.previous[y] = {}
        for x = 1, self.width do
            self.distances[y][x] = math.huge
            self.previous[y][x] = nil
            table.insert(self.queue, { x = x, y = y })
        end
    end

    self.distances[start.y][start.x] = 0

    while #self.queue > 0 do
        table.sort(self.queue, function(a, b)
            return self.distances[a.y][a.x] < self.distances[b.y][b.x]
        end)

        local current = table.remove(self.queue, 1)

        if self.distances[current.y][current.x] == math.huge then
            break
        end

        for _, neighbor in ipairs(self:getNeighbors(current)) do
            local alt = self.distances[current.y][current.x] + self:getWeight(neighbor)
            if alt < self.distances[neighbor.y][neighbor.x] then
                self.distances[neighbor.y][neighbor.x] = alt
                self.previous[neighbor.y][neighbor.x] = current
            end
        end
    end
end

function Dijkstra:getPath(start, finish)
    local path = {}
    local current = finish

	Dijkstra:calculate(start)

    while current do
        table.insert(path, 1, current)
        current = self.previous[current.y][current.x]
    end

    return path
end

function Dijkstra:getNeighbors(node)
    local neighbors = {}

    for _, offset in ipairs({ { x = 0, y = -1 }, { x = 1, y = 0 }, { x = 0, y = 1 }, { x = -1, y = 0 } }) do
        local neighbor = { x = node.x + offset.x, y = node.y + offset.y }
        if self:isValid(neighbor) then
            table.insert(neighbors, neighbor)
        end
    end

    return neighbors
end

function Dijkstra:getWeight(node)
    return self.map[node.y][node.x].properties.weight
end

function Dijkstra:isValid(node)
    return node.x >= 1 and node.x <= self.width and node.y >= 1 and node.y <= self.height
end

return Dijkstra
