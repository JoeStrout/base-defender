// Load the unit and building sprite sheets.
unitSpritesheet = file.loadImage("pics/UnitSprites.png")

unitSpriteImage = function(column, row)
	return unitSpritesheet.getImage(column*64, row*64, 64, 64)
end function

playerSpriteImage = unitSpritesheet.getImage(64*3, 
  unitSpritesheet.height - 96, 96, 96)

buildingSpritesheet = file.loadImage("pics/BuildingSprites.png")

castleImage = buildingSpritesheet.getImage(0,64, 192,192)
towerImage = buildingSpritesheet.getImage(64*3, 64*2.5, 96,96)
turretImage = buildingSpritesheet.getImage(64*3, 64, 96,96)

projectileSpritesheet = file.loadImage("pics/Projectiles.png")
projectileImages = []
for i in range(1,8)
	projectileImages.push projectileSpritesheet.getImage(
	  0, 64 - i*8, 128, 8)
end for
