import "importUtil"
ensureImport "resources"
ensureImport "constants"
ensureImport "listUtil"

globals.Projectile = new Sprite
Projectile.speed = 8
Projectile.imageIndex = 0
Projectile.scale = 0.5
Projectile.tint = constants.PLAYERCOLOR
Projectile.framesLeft = 40
Projectile.damage = 4
Projectile.target = null

Projectile.update = function
	if self.target then
		if self.target.dead then
			self.target = null
		else
			self.face self.target
		end if
	end if
	
	self.moveForward self.speed
	
	if self.target and self.target.contains(self) then
		self.hitTarget
		return
	end if
	
	if self.imageIndex < 7 then
		self.imageIndex += 0.2
		self.image = resources.projectileImages[self.imageIndex]
	end if
	self.framesLeft -= 1
	if self.framesLeft <= 0 then
		spriteDisp.sprites.removeVal self
	end if
end function

Projectile.hitTarget = function
	self.target.takeDamage self.damage
	spriteDisp.sprites.removeVal self
end function

if locals == globals then
	p = new Projectile
	spriteDisp = display(4)
	spriteDisp.clear
	spriteDisp.sprites.push p
	p.x = 480; p.y = 320
	while spriteDisp.sprites.contains(p)
		p.update
		yield
	end while
end if
