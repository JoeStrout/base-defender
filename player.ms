import "importUtil"
ensureImport "resources"
ensureImport "constants"
ensureImport "spriteExtensions"
ensureImport "grid"

// Player class

player = new Sprite
player.image = resources.playerSpriteImage
player.x = 480; player.y = 320
player.speed = 0
player.scale = 0.5
player.tint = constants.PLAYERCOLOR
player.addBbox 16

player.update = function
	dx = key.axis("Horizontal")
	dy = key.axis("Vertical")
	if dx or dy then
		dir = atan(dy, dx) * 180/pi
		if dir < 0 then dir += 360
		delta = dir - self.rotation
		if abs(dir-360 - self.rotation) < abs(delta) then
			dir -= 360
		end if
		self.rotation = moveTowardsAngle(self.rotation, dir, 90)
		self.speed = mathUtil.moveTowards(self.speed, 5, 0.5)
	else
		self.speed = mathUtil.moveTowards(self.speed, 0, 1)
	end if
	if not self.speed then return
	self.moveForward self.speed
	// handle collisions
	self.checkCollisions
end function

player.checkCollisions = function
	for sp in spriteDisp.sprites
		if sp != self and sp.localBounds != null and
		  self.overlaps(sp) and self.isFacing(sp) then
			self.hit sp
		end if
	end for
	if grid.overlapsWall(self) then self.hitWall
end function

player.hit = function(other)
	self.speed = 0
	if other isa Enemy then other.takeDamage 1
end function

player.hitWall = function
	self.speed = 0
	self.moveForward -3
end function

player.takeDamage = function
	self.flash
end function

setup = function
	spriteDisp.sprites.push player	
end function

