package no.uio.ifi.sonen.ai.dotwars;

import java.util.ArrayList;

public abstract class King {
	
	private String name;
	private int playerId;

	public King(String name, int playerId) {
		this.name = name;
		this.playerId = playerId;
	}
	
	// public abstract ArrayList<UnitGroup> action(Castle Castle, ArrayList<UnitGroup> units);
	
	public abstract ArrayList<UnitGroup> action(Castle Castle);
	
	public String getName() {
		return name;
	}
	
	public int getPlayerId() {
		return playerId;
	}

}
