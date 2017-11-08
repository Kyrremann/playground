package no.uio.ifi.sonen.ai.dotwars;

public class Castle {
	
	private int resources;
	private int peasants;
	private Player player;
	private int x, y;
	
	public Castle(Player player, int peasants, int x, int y) {
		this.player = player;
		this.peasants = peasants;
		this.resources = 0;
		this.x = x;
		this.y = y;
	}
	
	public int getX() {
		return x;
	}
	
	public int getY() {
		return y;
	}

	public int getPeasantCount() {
		return peasants;
	}

	public int getPeasants(int peasants) {
		// TODO: Check how many there are left
		this.peasants -= peasants;
		return peasants;
		
	}
	
	public int getResoruces() {
		return resources;
	}
}
