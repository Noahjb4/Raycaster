function love.load ()
sensitivity = 400
mouseVisible = not love.mouse.setVisible(false)
  map = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
    {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
    {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
  };

posX = 22
posY = 12

dirX = -1
dirY = 0

planeX = 0
planeY = 0.66


  love.window.setMode (800, 600, {resizable=true, minwidth=400, minheight=300})


drawScreenLineStart = {}
drawScreenLineEnd = {}
drawScreenLineColor = {}
end

function love.update (dt)
  w, h = love.graphics.getDimensions()

  for x = 0, w, 1 do
    local cameraX = 2 * x / w - 1
    local rayPosX = posX
    local rayPosY = posY
    local rayDirX = dirX + planeX * cameraX
    local rayDirY = dirY + planeY * cameraX

    local mapX = math.floor(rayPosX)
    local mapY = math.floor(rayPosY)

    local sideDistX
    local sideDistY

    local deltaDistX = math.sqrt(1 + (rayDirY ^ 2) / (rayDirX ^ 2))
		local deltaDistY = math.sqrt(1 + (rayDirX ^ 2) / (rayDirY ^ 2))
    local perWallDist

    local stepX
    local stepY

    local hit = 0
    local side = 0

    if (rayDirX < 0) then
			stepX = -1
			sideDistX = (rayPosX - mapX) * deltaDistX
		else
			stepX = 1
			sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX
		end

		if (rayDirY < 0) then
			stepY = -1
			sideDistY = (rayPosY - mapY) * deltaDistY
		else
			stepY = 1
			sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY
		end

    while (hit == 0) do
			if (sideDistX < sideDistY) then
				sideDistX = sideDistX + deltaDistX
				mapX = mapX + stepX
				side = 0
			else
				sideDistY = sideDistY + deltaDistY
				mapY = mapY + stepY
				side = 1
			end

      if (map[mapX][mapY] > 0) then
        hit = 1
      end
    end

    if (side == 0) then
      perpWallDist = math.abs ((mapX - rayPosX + (1 - stepX) / 2) / rayDirX)
    else
      perpWallDist = math.abs ((mapY - rayPosY + (1 - stepY) / 2) / rayDirY)
    end

    lineHeight = math.abs(math.floor(h / perpWallDist))

    drawStart = -lineHeight / 2 + h / 2
    drawEnd = lineHeight / 2 + h / 2

    if (drawStart < 0) then
      drawStart = 0
    end
    if (drawEnd >= h) then
      drawEnd = h - 1
    end

    if (map[mapX][mapY] == 1) then
				if (side == 1) then
					drawScreenLineColor[x] = {127,0,0,255}
				else
					drawScreenLineColor[x] = {255,0,0,255}
				end
			elseif (map[mapX][mapY] == 2) then
				if (side == 1) then
					drawScreenLineColor[x] = {0,127,0,255}
				else
					drawScreenLineColor[x] = {0,255,0,255}
				end
			elseif (map[mapX][mapY] == 3) then
				if (side == 1) then
					drawScreenLineColor[x] = {0,0,127,255}
				else
					drawScreenLineColor[x] = {0,0,255,255}
				end
			elseif (map[mapX][mapY] == 4) then
				if (side == 1) then
					drawScreenLineColor[x] = {127,127,127,255}
				else
					drawScreenLineColor[x] = {255,255,255,255}
				end
			else
				if (side == 1) then
					drawScreenLineColor[x] = {127,127,0,255}
				else
					drawScreenLineColor[x] = {255,255,0,255}
				end
			end

    drawScreenLineStart[x] = drawStart
    drawScreenLineEnd[x] = drawEnd
  end

    moveSpeed = dt * 5.0
		rotationSpeed = dt * 3.0
		strafeSpeed = dt * 5.0

    if love.keyboard.isDown("w") then
      if (map[math.floor(posX + dirX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX + dirX * moveSpeed
			end
      if (map[math.floor(posX)][math.floor(posY + dirY * moveSpeed)] == 0) then
				posY = posY + dirY * moveSpeed
			end
    end

    if love.keyboard.isDown("s") then
			if (map[math.floor(posX - dirX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX - dirX * moveSpeed
			end
			if (map[math.floor(posX)][math.floor(posY - dirY * moveSpeed)] == 0) then
				posY = posY - dirY * moveSpeed
			end
		end

		if love.keyboard.isDown("d") then
			if (map[math.floor(posX + planeX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX + planeX * strafeSpeed
			end
			if (map[math.floor(posX)][math.floor(posY + planeY * moveSpeed)] == 0) then
				posY = posY + planeY * strafeSpeed
			end
		end

		if love.keyboard.isDown("a") then
			if (map[math.floor(posX - planeX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX - planeX * strafeSpeed
			end
			if (map[math.floor(posX)][math.floor(posY - planeY * moveSpeed)] == 0) then
				posY = posY - planeY * strafeSpeed
			end
		end

    mX, mY = love.mouse.getPosition()
    rotationSpeed = (w / 2 - mX) / sensitivity

    oldDirX = dirX
    dirX = dirX * math.cos(rotationSpeed) - dirY * math.sin(rotationSpeed)
    dirY = oldDirX * math.sin(rotationSpeed) + dirY * math.cos(rotationSpeed)
    oldPlaneX = planeX
    planeX = planeX * math.cos(rotationSpeed) - planeY * math.sin(rotationSpeed)
    planeY = oldPlaneX * math.sin(rotationSpeed) + planeY * math.cos(rotationSpeed)

    if love.keyboard.isDown("escape") == false then
      love.mouse.setPosition(w / 2, h / 2)
    end
end

    function love.draw()
      for x = 0, w, 1 do
      		love.graphics.setColor(drawScreenLineColor[x])
      		love.graphics.line(x, drawScreenLineStart[x], x, drawScreenLineEnd[x])
      	end
      end
