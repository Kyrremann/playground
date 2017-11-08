package no.minimon.fragmentrules.utils;

public interface RuleSelectedListener {
	
	void onRuleSelectedListener(int position, String[] rules, String category);
	
	void onNestedRuleSelectedListener(int position, String[] rules, String category, String nestedRule);
}
