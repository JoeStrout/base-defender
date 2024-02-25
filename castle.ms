import "importUtil"
ensureImport "constants"
ensureImport "resources"
ensureImport "tower"

Castle = new Sprite
Castle.image = resources.castleImage
Castle.tint = constants.PLAYERCOLOR
Castle.addBbox 16
Castle.scale = 0.5
Castle.update = null
Castle.health = 100
Castle.cash = 0

setup = function
	// Castle class
	outer.castle = new Castle
	castle.x = 780
	castle.y = 500
	spriteDisp.sprites.push castle
	
	for dx in [-1, 1]
		for dy in [-1, 1]
			t = new Turret
			t.x = castle.x + dx * 68 * castle.scale
			t.y = castle.y + dy * 68 * castle.scale
			t.damage = 2
			spriteDisp.sprites.push t
		end for
	end for
	castle.drawStats
end function

Castle.drawStats = function
	text.color = constants.PLAYERCOLOR
	text.row = 25; text.column = 4
	print "$" + self.cash + "    "
	text.row = 25; text.column = 50
	print "Castle Health: " + self.health + "   "
end function

Castle.addCash = function(dCash)
	self.cash += dCash
	self.drawStats	
end function

Castle.addHealth = function(dHealth)
	self.health += dHealth
	self.drawStats	
end function

Castle.takeDamage = function
	self.flash
	self.addHealth -1
end function

if locals == globals then
	spriteDisp = display(4)
	spriteDisp.clear
	//setup
else
	// This module returns the castle as its value, rather than
	// the module itself.  After importing it, you'll have 
	// "castle" as a direct reference to the castle sprite.
	setup
	return castle
end if
