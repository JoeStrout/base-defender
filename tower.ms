import "importUtil"
ensureImport "resources"
ensureImport "constants"
ensureImport "listUtil"
ensureImport "mathUtil"
ensureImport "projectile"
ensureImport "spriteExtensions"

globals.Turret = new Sprite
Turret.image = resources.turretImage
Turret.scale = 0.5
Turret.target = null
Turret.targetDist = null
Turret.nextCheckIdx = 0
Turret.cooldownFrames = 20

Turret.update = function
	self.cooldownFrames -= 1
	self.nextCheckIdx += 1
	if self.nextCheckIdx >= spriteDisp.sprites.len then
		self.nextCheckIdx = 0
	end if
	sp = spriteDisp.sprites[self.nextCheckIdx]
	if sp isa Enemy then
		dist = mathUtil.distance(self, sp)
		if self.target == null or dist < self.targetDist then
			// New target!
			self.target = sp
		end if
	end if
	if self.target and self.target.dead then self.target = null
	if not self.target then return
	self.face self.target
	self.targetDist = mathUtil.distance(self, self.target)
	if self.cooldownFrames <= 0 and self.targetDist < 200 then
		self.fire
	end if
end function

Turret.fire = function
	p = new Projectile
	p.x = self.x; p.y = self.y
	p.rotation = self.rotation
	p.moveForward 48 * self.scale
	p.target = self.target
	spriteDisp.sprites.push p
	self.cooldownFrames = Turret.cooldownFrames
end function

globals.Tower = new Sprite
Tower.image = resources.towerImage
Tower.scale = 0.5
Tower.init = function(x, y)
	self.x = x; self.y = y
	self.turret = new Turret
	self.turret.x = x; self.turret.y = y
	spriteDisp.sprites.push self
	spriteDisp.sprites.push self.turret
	return self
end function
Tower.update = null

if locals == globals then
	spriteDisp = display(4)
	spriteDisp.clear
	t = (new Tower).init(480, 320)
	while true
		for sp in spriteDisp.sprites
			sp.update
		end for
		if rnd < 0.05 then t.turret.fire
		yield
	end while	
end if