package no.uio.ifi.sonen.ai.dotwars;

import no.uio.ifi.sonen.ai.dotwars.UnitGroup.UnitType;

public class UnitGroup {

	private UnitType unitType;
	private int size;
	private int atX, atY;
	private int goX, goY;
	private int playerId;

	public UnitGroup(int playerId, int x, int y, UnitType unitType, int size) {
		this.unitType = unitType;
		this.size = size;
		this.atX = x;
		this.atY = y;
		this.playerId = playerId;
	}
	
	public int getSize() {
		return size;
	}
	
	public int getPlayer() {
		return playerId;
	}
	
	public int getGoX() {
		return goX * 24;
	}
	
	public int getGoY() {
		return goY * 24;
	}
	
	public int getAtX() {
		return atX;
	}
	
	public int getAtY() {
		return atY;
	}
	
	public void unitAt(int x, int y) {
		this.atX = x;
		this.atY = y;
	}
	
	public void goTo(int x, int y) {
		goX = x;
		goY = y;
	}
	
	public int kill(int dead) {
		this.size -= dead;
		return this.size;
	}
	
	public enum UnitType {
		GUARD, SCOUT, DIGGER;
	}

}
