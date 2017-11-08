package no.minimon.app.rivetwarsrules.utils;

import com.codename1.io.JSONParser;
import com.codename1.javascript.JSObject;
import com.codename1.ui.Display;
import com.codename1.ui.util.Resources;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

public class SimpleJSONParser {

    public static Map<String, Object> getMeSomeJson(Resources resources, String filename) {
        if (!filename.endsWith(".json")) {
            filename += ".json";
        }

        try {
            InputStream inputStream = resources.getData(filename);
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
            JSONParser jsonParser = new JSONParser();
            return jsonParser.parseJSON(inputStreamReader);
        } catch (IOException e) {
            throw new RuntimeException("Couldn't parse JSON file", e);
        }
    }
}
