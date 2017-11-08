package no.uio.ifi.sonen.ai.dotwars;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream.GetField;

public class MapLevel {

	public static Type[][] loadMap(String mapName) {
		Type[][] map = new Type[Gfx.YUNIT][Gfx.XUNIT];

		BufferedReader in = null;
		try {
			in = new BufferedReader(new FileReader("res/" + mapName));
//			new InputStreamReader(BattleField.class
//					.getClassLoader().getResourceAsStream(mapName)));
		} catch (NullPointerException e) {
			System.err.printf("Could not open map file '%s'\n", mapName);
			System.exit(1);
		} catch (FileNotFoundException e) {
			System.err.printf("Could not open map file '%s'\n", mapName);
			e.printStackTrace();
		}
		
		int next = -1;
        for (int y = 0; y < Gfx.YUNIT; ++y) {
            for (int x = 0; x < Gfx.XUNIT / 2; ++x) {
                try {
                    next = in.read();
                    if (next == 10)
                        next = in.read();  // Skip line break
                } catch (IOException e) {
                    System.err.println(e.getMessage());
                }

                if (next == -1)
                    break;
                map[y][x] = Type.getType((char)next);
                map[y][(Gfx.XUNIT - 1) - x] = Type.getType((char)next);
            }
        }


		return map;
	}
}
