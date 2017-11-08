package no.minimon.fragmentrules.fragments;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import no.minimon.fragmentrules.RulesApplication;
import android.support.v4.app.Fragment;

public abstract class AbstractRuleFragment extends Fragment {

	/**
	 * The title of the rule will also be used to generate the json-file
	 */
	public static final String ARG_RULE_TITLE = "rule_title";
	public static final String ARG_RULE_POSITION = "rule_position";
	public static final String ARG_RULES = "rules_array";
	public static final String ARG_CATEGORY = "rule_category";
	public static final String ARG_NESTED_CATEGORY = "rule_nested_category";
	public static final String ARG_OBJECT = "rule_object";
	
	protected static RulesApplication application;
	protected static String[] rules_array;
	protected static List<String> listOfRules;
	protected static String category;

	protected String[] moveGeneralItemToTopOfArray(String[] array) {
		LinkedList<String> linkedList = new LinkedList<String>();
		linkedList.addAll(Arrays.asList(array));
		if (linkedList.contains("General")) {
			linkedList.remove("General");
			linkedList.addFirst("General");
		}
		
		return linkedList.toArray(new String[array.length]);
	}
}
