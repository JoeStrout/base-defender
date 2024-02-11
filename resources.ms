// Load the unit and building sprite sheets.
unitSpritesheet = file.loadImage("pics/UnitSprites.png")

unitSpriteImage = function(column, row)
	return unitSpritesheet.getImage(column*64, row*64, 64, 64)
end function

playerSpriteImage = unitSpritesheet.getImage(64*3, 
unitSpritesheet.height - 96, 96, 96)


buildingSpritesheet = file.loadImage("pics/BuildingSprites.png")

castleImage = buildingSpritesheet.getImage(0,64, 192,192)
