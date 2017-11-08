package no.uio.ifi.sonen.ai.dotwars.team.dumb;

import java.util.ArrayList;
import java.util.Random;

import no.uio.ifi.sonen.ai.dotwars.Castle;
import no.uio.ifi.sonen.ai.dotwars.King;
import no.uio.ifi.sonen.ai.dotwars.UnitGroup;
import no.uio.ifi.sonen.ai.dotwars.UnitGroup.UnitType;

// TODO: Need to extends something...
public class Dumb extends King {

	public Dumb(String name, int playerId) {
		super(name, playerId);
	}

	public ArrayList<UnitGroup> action(Castle castle) {
		ArrayList<UnitGroup> units = new ArrayList<UnitGroup>();
		// if (units.isEmpty()) { // Probably first round, send troops
		int peasants = castle.getPeasantCount();
		if (peasants > 1) { // get half of the peasants
			peasants = castle.getPeasants(1);

			// Create unit group and send them out for gathering
			Random random = new Random();
			int goToX;
			int goToY;
			if (getPlayerId() == 1) {
				goToX = random.nextInt(40) + 8;
				goToY = random.nextInt(20) + 3;
			} else {
				goToX = random.nextInt(10) + 8;
				goToY = random.nextInt(20) + 3;
			}
			UnitGroup unitGroup = new UnitGroup(getPlayerId(), castle.getX(),
					castle.getY(), UnitType.DIGGER, peasants);
			unitGroup.goTo(goToX, goToY);
			units.add(unitGroup);
		}
		// }

		return units;
	}
}
