package no.uio.ifi.sonen.ai.dotwars;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

public class Player {

	private int score;
	private int playerId;
	final Color color;
	private Castle castle;
	private List<UnitGroup> unitGroups;

	public Player(int playerId, int peasants, Color color, int x, int y) {
		this.playerId = playerId;
		this.color = color;
		this.score = 0;
		castle = new Castle(this, peasants, x * 24, y * 24);
		unitGroups = new ArrayList<UnitGroup>();
	}
	
	public int getPlayer() {
		return playerId;
	}

	public int getScore() {
		return score;
	}
	
	public Castle getCastle() {
		return castle;
	}
	
	public ArrayList<UnitGroup> getUnitGroups() {
		return (ArrayList<UnitGroup>) unitGroups;
	}
}
