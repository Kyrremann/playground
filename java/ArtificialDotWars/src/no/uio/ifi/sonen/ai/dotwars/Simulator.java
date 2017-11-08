package no.uio.ifi.sonen.ai.dotwars;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferStrategy;
import java.util.ArrayList;
import java.util.List;

import javax.swing.ImageIcon;
import javax.swing.SwingUtilities;
import javax.swing.Timer;

import no.uio.ifi.sonen.ai.dotwars.team.dumb.Dumb;

public class Simulator {

	private Gfx gfx;
	private BufferStrategy strategy;
	private int delay = 1;
	private Timer timer;
	private Type[][] map;
	private List<UnitGroup> movingUnitGroups;

	/** All the images we need. */
	private ImageIcon imgEmpty;
	private ImageIcon imgResource;
	private ImageIcon imgCastle;

	public Simulator(String mapName) {

		movingUnitGroups = new ArrayList<UnitGroup>();
		map = MapLevel.loadMap(mapName);

		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				gfx = new Gfx();
				strategy = gfx.getBufferStrategy();
				loadImages();
				timer = new Timer(delay, new ActionListener() {

					@Override
					public void actionPerformed(ActionEvent e) {
						display();
						strategy.show();

					}
				});
				timer.start();
			}
		});

		// Start the game
		letTheGameBegin();
	}

	private void letTheGameBegin() {
		// Create players from arguments
		final Player playerOne = new Player(1, 20, Color.red, 45, 15);
		final Dumb dumb = new Dumb("Dumb", playerOne.getPlayer());

		Thread playerOneThread = new Thread(new Runnable() {

			@Override
			public void run() {
				ArrayList<UnitGroup> unitGroups = new ArrayList<UnitGroup>();

				while (true) { // This is where the fun is
					// First test;
					// Don't give the users time to think, fake real time
					unitGroups = dumb.action(playerOne.getCastle());
					for (UnitGroup group : unitGroups) {
						moveUnit(group);
					}
				}
			}
		});
		playerOneThread.start();
		
		final Player playerTwo = new Player(2, 20, Color.red, 4, 15);
		final Dumb dumbTwo = new Dumb("Dumb", playerTwo.getPlayer());

		Thread playerTwoThread = new Thread(new Runnable() {

			@Override
			public void run() {
				ArrayList<UnitGroup> unitGroups = new ArrayList<UnitGroup>();

				while (true) { // This is where the fun is
					// First test;
					// Don't give the users time to think, fake real time
					unitGroups = dumbTwo.action(playerTwo.getCastle());
					for (UnitGroup group : unitGroups) {
						moveUnit(group);
					}
				}
			}
		});
		playerTwoThread.start();
	}

	synchronized private void moveUnit(UnitGroup group) {
		movingUnitGroups.add(group);
	}

	/**
	 * Loads an image through the resource system.
	 * 
	 * @param fileName
	 *            The name of the file to load.
	 * @return An ImageIcon containing the loaded image.
	 */
	private ImageIcon loadImage(String fileName) {
		ImageIcon ret = null;
		try {
			ret = new ImageIcon(fileName);
		} catch (Exception e) {
			System.err.printf("Could not load image (%s) - %s%n", fileName,
					e.getMessage());
			System.exit(1);
		}
		return ret;
	}

	/** Loads the necessary image files. */
	private void loadImages() {
		imgEmpty = loadImage("res/gfx/empty.png");
		imgResource = loadImage("res/gfx/grass.png");
		imgCastle = loadImage("res/gfx/skigard.png");
	}

	private void display() {
		Graphics graphics = strategy.getDrawGraphics();
		ImageIcon drawMe = null;

		graphics.setColor(Color.green);
		graphics.fillRect(0, 0, Gfx.WIDTH, Gfx.HEIGHT);

		for (int y = 0; y < Gfx.YUNIT; y++) {
			for (int x = 0; x < Gfx.XUNIT; x++) {

				switch (map[y][x]) {
				case EMPTY:
					drawMe = imgEmpty;
					break;
				case RESOURCE:
					drawMe = imgResource;
					break;
				case CASTLE:
					drawMe = imgCastle;
					break;
				default:
					break;
				}

				graphics.drawImage(drawMe.getImage(), (x * Gfx.UNIT),
						(y * Gfx.UNIT), null, null);
			}
		}

		// Draw peasants with this
		for (UnitGroup group : movingUnitGroups) {
			int x = group.getAtX(), y = group.getAtY();
			graphics.setColor(getColor(group.getPlayer()));
			graphics.fillRect(x, y, 6, 6);
			
			if (group.getGoX() == x && group.getGoY() == y) {
				graphics.setColor(Color.white);
				graphics.drawChars("DONE".toCharArray(), 0, 4, x, y - 6);
				continue;
			}
			
			if (group.getGoX() > x)
				x += 6;
			else if (group.getGoX() < x)
				x -= 6;
			if (group.getGoY() > y)
				y += 6;
			else if (group.getGoY() < y)
				y -= 6;
			
			group.unitAt(x, y);
		}

		graphics.dispose();
	}
	
	public Color getColor(int player) {
		if (player == 1)
			return Color.blue;
		else if (player == 2)
			return Color.red;
		
		return Color.pink;
	}
}
