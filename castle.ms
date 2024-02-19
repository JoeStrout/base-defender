import "importUtil"
ensureImport "constants"
ensureImport "resources"
ensureImport "tower"

setup = function
	// Castle class
	outer.castle = new Sprite
	castle.image = resources.castleImage
	castle.x = 780
	castle.y = 500
	castle.scale = 0.5
	castle.tint = constants.PLAYERCOLOR
	castle.addBbox 16
	castle.update = null
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
end function

if locals == globals then
	spriteDisp = display(4)
	spriteDisp.clear
	setup
else
	// This module returns the castle as its value, rather than
	// the module itself.  After importing it, you'll have 
	// "castle" as a direct reference to the castle sprite.
	setup
	return castle
end if
