import "importUtil"
ensureImport "resources"
ensureImport "constants"
ensureImport "listUtil"
ensureImport "spriteExtensions"
ensureImport "grid"

// Enemy class
globals.Enemy = new Sprite
Enemy.image = resources.unitSpriteImage(1,2)
Enemy.scale = 0.5
Enemy.rotation = 90
Enemy.tint = constants.ENEMYCOLOR
Enemy.flashColor = color.white
Enemy.addBbox 8
Enemy.target = null
Enemy.speed = 4
Enemy.hitPoints = 15
Enemy.dead = false
Enemy.cashValue = 1
Enemy.blockedDir = null
Enemy.blockedTime = 0
Enemy.debug = false

Enemy.init = function
	self.blockedDir = {}
	return self
end function

Enemy.update = function
	// check nearby points; face closest
	bestDist = 999
	bestDelta = null
	if self.debug then print "speed:" + self.speed + 
	  ", blockedDir:" + self.blockedDir
	for dx in [-30, 0, 30]
		for dy in [-30, 0, 30]
			if not dx and not dy then continue
			if self.speed < 2 and dx != 0 and dy != 0 then continue
			if self.blockedDir.hasIndex([dx,dy]) then continue
			dist = grid.distanceToGoal(self.x+dx, self.y+dy)
			if self.debug then print "in " + dx+","+dy+", dist="+dist
			if dist < bestDist then
				bestDist = dist
				bestDelta = [dx, dy]
			end if
		end for
	end for
	if self.debug then print "bestDelta:" + bestDelta
	// if bestDelta == null then
	// print "Can't move!  Woe is me!"
	// self.die
	// return
	// end if
	targetAng = atan(bestDelta[1], bestDelta[0]) * 180/pi
	self.rotation = moveTowardsAngle(self.rotation, targetAng, 5)
	self.speed = mathUtil.moveTowards(self.speed, Enemy.speed, 0.5)
	self.moveForward self.speed
	self.checkCollisions
	if self.speed == 0 then
		// Oops, we hit something... this direction is blocked.
		self.blockedDir.push bestDelta
		self.blockedTime = time
	else if self.blockedDir and time > self.blockedTime+0.5 then
		self.blockedDir = {}
	end if	
end function

Enemy.chaseTarget = function
	// NOT CURRENTLY IN USE
	// pick target
	playerDist = mathUtil.distance(self, player.player)
	if playerDist < 100 then
		self.target = player.player
	else
		self.target = castle
	end if
	// chase target
	targetAng = atan(self.target.y - self.y,
	self.target.x - self.x) * 180/pi
	self.rotation = moveTowardsAngle(self.rotation, targetAng, 5)
	self.speed = mathUtil.moveTowards(self.speed, Enemy.speed, 0.5)
	self.moveForward self.speed
	self.checkCollisions
end function

Enemy.checkCollisions = function
	for sp in spriteDisp.sprites
		if sp != self and sp.localBounds != null and 
		self.overlaps(sp) and self.isFacing(sp) then
			self.hit sp
		end if
	end for
	if grid.overlapsWall(self) then self.hitWall
end function

Enemy.hit = function(other)
	self.speed = 0
	self.moveForward -3
	if other isa Enemy then return
	if other == player.player or other == castle then
		other.takeDamage
	end if
end function

Enemy.hitWall = function
	self.speed = 0
	self.moveForward -3
end function

Enemy.takeDamage = function(amount)
	self.flash
	self.hitPoints -= amount
	if self.hitPoints <= 0 then self.die
end function

Enemy.die = function
	enemies.removeVal self
	spriteDisp.sprites.removeVal self
	self.dead = true
	castle.addCash self.cashValue
end function

spawn = function(qty=null)
	if qty == null then qty = ceil(3 + 7*rnd)
	for i in range(1, qty)
		enemy = (new Enemy).init
		// enemy.x = 100 + 760*rnd
		// enemy.y = 10 + 50*rnd
		enemy.x = 300; enemy.y = 484; enemy.rotation = 0
		
		enemy.speed += rnd - 0.5
		spriteDisp.sprites.push enemy
		enemies.push enemy
	end for
	outer.nextSpawnTime = time + 5 + 10*rnd
end function

setup = function
	// Create some enemies
	outer.enemies = []
	spawn 1
	// Have them all go for the castle by default
	Enemy.target = castle	
end function

update = function
	if time > nextSpawnTime then spawn	
end function
