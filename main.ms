import "importUtil"
ensureImport "mathUtil"
ensureImport "qa"
ensureImport "enemies"
ensureImport "resources"
ensureImport "constants"
ensureImport "player"
ensureImport "tower"
ensureImport "grid"

clear
spriteDisp = display(4)
ensureImport "castle"  // (import after spriteDisp is ready)


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
grid.setup
grid.prepareDistanceMap castle
player.setup
enemies.setup
t = (new Tower).init(300, 300)

while true
	for sp in spriteDisp.sprites
		sp.update
		sp.updateFlash
	end for
	enemies.update
	text.row = 25; print grid.distanceToGoal(mouse.x, mouse.y) + "    "
	yield
end while
