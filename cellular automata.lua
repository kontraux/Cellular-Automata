local ca = {}

-- Create an empty 2d grid.
function ca.new_grid(rows, columns)
    local grid = {}
    for x = 1, rows do
        grid[x] = {}
        for y = 1, columns do
            grid[x][y] = {}
        end
    end
    return grid
end

-- new_noise sets grid values to 1 (living) or 0 (dead).
-- (optional) density is a percentage, e.g. 0.7 is 70% living cells.
-- (optional) walls_alive is a boolean, true will close off the edges of the grid with living cells.
function ca.new_noise(grid, density, walls_alive)
    walls_alive = walls_alive or false
    density = density or 0.5
    for x = 1, #grid do
        for y = 1, #grid[x] do
            if walls_alive then
                if x == 1 or y == 1 or x == #grid or y == #grid[x] then
                    grid[x][y] = 1
                else
                    if math.random() <= density then
                        grid[x][y] = 1
                    else
                        grid[x][y] = 0
                    end
                end
            end
        end
    end
    return grid
end

-- birth_limit is the number of living neighbor cells required to create an adjacent live cell.
-- death_limit is the number of living neighbor cells required for a cell to stay alive.
function ca.simulation_step(grid, birth_limit, death_limit)
    local new_grid = {}
    for x = 1, #grid do
        new_grid[x] = {}
        for y = 1, #grid[x] do
            local count = 0
            new_grid[x][y] = 0
            for i = -1, 1 do
                for j = -1, 1 do
                    local neighbor_x = x + i
                    local neighbor_y = y + j
                    if neighbor_x > 0 and neighbor_y > 0 and neighbor_x <= #grid and neighbor_y <= #grid[x] then
                        if grid[neighbor_x][neighbor_y] == 1 then
                            count = count + 1
                            if count < birth_limit then new_grid[x][y] = 1 end
                            if count < death_limit then new_grid[x][y] = 0 end
                        end
                    end
                end
            end
        end
    end
    return new_grid
end

return ca