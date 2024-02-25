# Base Defense Progress Log

For all my projects that take more than a few days, I make a "progress log" and try to write down each day what I did, what's next, and any musings I have about the various design and engineering decisions.  This helps me pick up where I left off, even if it is months or even years later.

This is the progress log for the Base Defense game, which I'm developing as a series of "live coding" videos.  I'll mostly have time for those on weekends, so this will help me not lose track of everything during the week.

As such, this log is mostly for my own use.  But you are welcome to read along if you like.

## 12 Feb 2024

I've spent two hours on the project so far, and we have:

- player can move around using directional inputs (push in the direction you want to go; the sprite quickly turns and moves in that direction)
- enemies spawn in groups along the bottom of the screen, and attack the player (if close enough) or castle
- sprites flash when they take damage
- enemies can be killed

So, we're off to a good start.  The next two obvious big steps are:

- add towers, which shoot at the nearest enemy (which means adding projectiles)
- add a TileDisplay obstacle map, limiting where players and enemies can go
	- and then compute a distance map so enemies can still find their way around

I'll have to decide whether to use a hex grid or a square grid.  I do loves me some hex grids, but there's no doubt they are more complex, and I don't have a strong reason to favor them in this game.  Except they're cool.  Still on the fence about this.  Perhaps I can start with a square grid, but hide all the details in a `map` module, and try to be disciplined about going through the proper module APIs rather than accessing the tile display directly.  Then I can take an hour sometime later and replace the square grid with a hex one.

## 18 Feb 2024

We've got turrets working now, firing projectiles automatically at the enemy.  We have one of these hard-coded out on the map, and four little turrets on the castle.  So that's all working swimmingly.

Then, I added a `grid` module that manages a TileDisplay, as well as a 2D list that tracks distance to the goal (castle).  The distance is also shown as cell tint, for debugging purposes.  The enemies consider 8 directions around their location, and turn to face the one that's closest to the goal according to this distance map.

This works pretty well, except that sometimes they get caught on a corner of a wall.  I think the simple solution to that will be: when their current speed is below some threshold (as it will be, when they've hit a wall), only consider the 4 orthogonal directions, ignoring diagonals.  That should work to get them unstuck.

After that, I guess we're ready to start trying to make the game fun, by having a cycle of attacks and building.  We'll need UI for selecting whether to build a tower, or upgrade the castle, or upgrade the player avatar.

## 25 Feb 2024

Well THAT was interesting.  I thought the trick of ignoring diagonals when stuck would solve the problem of enemies getting stuck on corners.  It *mostly* does, but not always; if an enemy approaches a corner from an orthogonal direction, but slightly higher than the edge of the corner, it can still get stuck.

Trying to solve that led down a rabbit hole, where I tried to keep track of which direction(s) is/are "blocked" and so try something else.  I first implemented this incorrectly (using the last dx,dy instead of the chosen dx,dy), but even after that was fixed, it doesn't work.  And the reason appears to be: in order to go in the proper direction, the enemy first has to rotate to face that direction.  And rotating causes its bounding box to clip into the neighboring wall, so it figures *that* direction is blocked, too.

In fact if I have it really remember and discard every direction it thinks is blocked, then it quickly concludes it that it's completely trapped (and commits hari-kari).

At the moment, I'm not sure what the right solution for this is.
