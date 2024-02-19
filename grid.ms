import "importUtil"
ensureImport "constants"
ensureImport "mapUtil"
ensureImport "listUtil"

WALLIDX = 8
ROWS = 20
COLUMNS = 30

// cellBounds: a matrix of bounding boxes for wall/obstace cells
cellBounds = list.init2d(COLUMNS, ROWS)

addCellBounds = function(col, row)
	bb = new Bounds
	bb.x = (col + 0.5) * td.cellSize
	bb.y = (row + 0.5) * td.cellSize
	bb.width = td.cellSize
	bb.height = td.cellSize
	cellBounds[col][row] = bb
end function

addWall = function(x0,y0, x1,y1)
	while true
		td.setCell x0, y0, WALLIDX
		td.setCellTint x0, y0, "#CCCCFF"
		addCellBounds x0, y0
		x0 += sign(x1-x0)
		y0 += sign(y1-y0)
		if x0==x1 and y0==y1 then break
	end while
end function

isWall = function(col, row)
	return td.cell(col, row) == WALLIDX
end function

column = function(xy)
	return floor(xy.x / td.cellSize)
end function

row = function(xy)
	return floor(xy.y / td.cellSize)
end function

distanceToGoal = function(x, y)
	col = floor(x / td.cellSize)
	row = floor(y / td.cellSize)
	if 0 <= col < COLUMNS and 0 <= row < ROWS then
		return distMap[col][row]
	end if
	return 9999
end function

setup = function
	display(5).mode = displayMode.tile
	outer.td = display(5)
	td.extent = [30, 20]
	td.cellSize = 32
	td.tileSet = file.loadImage("/sys/pics/TileShapes.png")
	td.tileSetTileSize = 64
	td.clear 0
	outer.columns = range(0, td.extent[0]-1)
	outer.rows = range(0, td.extent[1]-1)
	for x in columns
		for y in rows
			td.setCellTint x, y, color.rgb(50, 50, 150*((x+y)%2))
		end for
	end for
	
	addWall 20,19, 20,12
	addWall 29,5, 11,5
	addWall 11,5, 11,15
end function

overlapsWall = function(spriteOrPoint)
	col = floor(spriteOrPoint.x / td.cellSize)
	row = floor(spriteOrPoint.y / td.cellSize)
	if spriteOrPoint isa Sprite then
		// Harder case: check a bounding box
		bb = spriteOrPoint.worldBounds
		for c in range(col-1, col+1)
			for r in range(row-1, row+1)
				wallBB = cellBounds[c][r]
				if wallBB and wallBB.overlaps(bb) then return true
			end for
		end for
		return false
	else
		// Easy case: check a point
		return td.cell(col, row) == WALLIDX
	end if
end function

setDistance = function(col, row, dist)
	distMap[col][row] = dist
	td.setCellTint col, row, rgb(255 - dist * 8, 0, 0)
end function

prepareDistanceMap = function(goalPos)
	outer.distMap = list.init2d(COLUMNS, ROWS, null)
	goalCol = floor(goalPos.x/td.cellSize)
	goalRow = floor(goalPos.y/td.cellSize)
	setDistance goalCol, goalRow, 0
	toDo = []
	toDo.push [goalCol, goalRow]
	while toDo
		pos = toDo.pull
		x = pos[0]; y = pos[1]
		d = distMap[x][y]
		for c in range(x-1, x+1)
			if c < 0 or c >= COLUMNS then continue
			for r in range(y-1, y+1)
				if r < 0 or r >= ROWS then continue
				if isWall(c, r) then
					setDistance c, r, 999
				else if distMap[c][r] == null then
					setDistance c, r, d+1
					toDo.push [c,r]
				end if
			end for
		end for
	end while	
end function

if locals == globals then
	clear
	setup
	while true
		text.row = 25; print overlapsWall(mouse)
		yield
	end while
end if