package no.minimon.fragmentrules.utils;

import android.content.Context;
import no.minimon.fragmentrules.R;
import org.json.JSONObject;

import java.io.InputStream;

public class JSONParser {

	private static JSONObject getMeSomeJson(Context context, String file) {
		if (!file.endsWith(".json")) {
			file += ".json";
		}

		try {
			InputStream inputStream = context.getAssets().open(file);

			byte[] buffer = new byte[inputStream.available()];
			inputStream.read(buffer);
			inputStream.close();

			return new JSONObject(new String(buffer));
		} catch (Exception e) {
			throw new IllegalJSONException("Can't generate JSON from the file " + file, e);
		}
	}

	public static JSONObject getJsonRule(Context context, String json) {
		try {
			return JSONParser.getMeSomeJson(context, json);
		} catch (Exception e) {
			throw new IllegalJSONException("Can't retrieve " + json, e);
		}
	}

	public static JSONObject getJsonChangelog(Context context) {
		try {
			return getMeSomeJson(context, context.getString(R.string.changelog_file));
		} catch (Exception e) {
			throw new IllegalJSONException("Can't retrieve the changelog", e);
		}
	}
}
