import "importUtil"
ensureImport "mathUtil"
ensureImport "qa"
ensureImport "enemies"
ensureImport "resources"
ensureImport "constants"
ensureImport "player"

clear
spriteDisp = display(4)


// Utility functions

moveTowardsAngle = function(fromAng, toAng, maxChange)
	fromAng = fromAng % 360; if fromAng < 0 then fromAng += 360
	toAng = toAng % 360; if toAng < 0 then toAng += 360
	dang = fromAng - toAng
	if abs(dang) <= 180 then
		return mathUtil.moveTowards(fromAng, toAng, maxChange)
	end if
	dang -= 180
	return fromAng + mathUtil.moveTowards(0, dang, maxChange)
end function

// Sprite extensions
Sprite.moveForward = function(speed=10)
	radians = self.rotation * pi/180
	self.x += speed * cos(radians)
	self.y += speed * sin(radians)
end function

Sprite.isFacing = function(target, angleLimit = 60)
	angleToTarget = atan(target.y - self.y, target.x - self.x) * 180/pi
	angleDiff = abs(angleToTarget - self.rotation)
	if angleDiff > 180 then angleDiff = abs(angleDiff - 360)
	return angleDiff < angleLimit
end function

Sprite.flashColor = color.red
Sprite.flashIntensity = 0   // from 0 to 1
Sprite.normalTint = null
Sprite.flash = function
	if self.normalTint == null then self.normalTint = self.tint
	self.flashIntensity = 1
	self.tint = self.flashColor
end function
Sprite.updateFlash = function
	if self.flashIntensity <= 0 then return
	self.tint = color.lerp(self.normalTint, self.flashColor, self.flashIntensity)
	self.flashIntensity -= 0.05
end function

Sprite.addBbox = function(inset=0)
	self.localBounds = new Bounds
	self.localBounds.width = self.image.width - inset*2
	self.localBounds.height = self.image.height - inset*2
end function

// Castle class
castle = new Sprite
castle.image = resources.castleImage
castle.x = 780
castle.y = 500
castle.scale = 0.5
castle.tint = constants.PLAYERCOLOR
castle.addBbox 16
castle.update = null
spriteDisp.sprites.push castle

drawBackground = function
	gfx.clear "#000045FF"
	gfx.color = "#004671FF"
	for x in range(0, 960, 64)
		gfx.line x,0, x,640
	end for
	for y in range(0, 640, 64)
		gfx.line 0,y, 960,y
	end for
end function

drawBackground
player.setup
enemies.setup

while true
	for sp in spriteDisp.sprites
		sp.update
		sp.updateFlash
	end for
	enemies.update
	yield
end while
