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

Sprite.face = function(target)
	self.rotation = atan(target.y - self.y, target.x - self.x) * 180/pi
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
