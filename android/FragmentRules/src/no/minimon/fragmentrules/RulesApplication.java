package no.minimon.fragmentrules;

import android.app.Application;
import no.minimon.fragmentrules.utils.IllegalJSONException;
import no.minimon.fragmentrules.utils.JSONParser;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class RulesApplication extends Application {

	// Json-keys
	public final static String JSON_NAME = "name";
	public final static String JSON_TEXT = "text";
	public final static String JSON_IMAGE = "image";

	public static final String JSON_COST = "cost";
	public static final String JSON_PREREQUISITE = "prerequisite";
	public static final String JSON_MODIFIER = "modifier";
	public static final String JSON_TYPE = "type";
	public static final String JSON_RELIC = "relic";
	public static final String JSON_OWNER = "owner";
	public static final String JSON_SET = "set";
	public static final String JSON_ID = "id";
	public static final String JSON_KEYWORDS = "keywords";
	public static final String JSON_IS_NESTED = "isNested";
	public static final String JSON_RULES = "rules";

	// Language
	public final static String ENGLISH = "english";

	private Map<String, JSONObject> mapOverJSONRules;
	private Map<String, String[]> categoryTitles;
	private String language;

	public RulesApplication() {
		language = ENGLISH;
		categoryTitles = new HashMap<String, String[]>(4);
		mapOverJSONRules = new HashMap<String, JSONObject>();
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language.toLowerCase(Locale.getDefault());
		resetJsonObjects();
	}

	private void resetJsonObjects() {
		mapOverJSONRules.clear();
		categoryTitles.clear();
	}

	public JSONObject getJSONRules(String category) throws IllegalJSONException {
		// TODO Implement languages
		JSONObject jsonObject = mapOverJSONRules.get(category);

		if (jsonObject == null) {
			mapOverJSONRules.put(category, JSONParser.getJsonRule(this, category));
			return mapOverJSONRules.get(category);
		}

		return jsonObject;
	}
}
