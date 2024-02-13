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


