package no.minimon.fragmentrules.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.SpannableStringBuilder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import no.minimon.fragmentrules.R;
import no.minimon.fragmentrules.RulesApplication;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

import static no.minimon.fragmentrules.utils.RuleSectionFactory.*;

public class SectionsRuleFragment extends AbstractRuleFragment {

	private static JSONObject rules;
	private static String[] rules_array_original;

	private static int rule_position;

	public SectionsRuleFragment() {
		listOfRules = new ArrayList<String>();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_rule_section, container,
				false);
		category = getArguments().getString(ARG_CATEGORY);
		rules_array_original = getArguments().getStringArray(ARG_RULES);
		addToRulesList(rules_array_original); // listOfRules
		rule_position = getArguments().getInt(ARG_RULE_POSITION);
		try {
			rules = new JSONObject(getArguments().getString(ARG_OBJECT));
		} catch (JSONException e) {
			rules = new JSONObject();
		}
		if (isRulesANestedRule(rules)) {
			try {
				rules = rules.getJSONObject(RulesApplication.JSON_RULES);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		} else if (isCategoryANestedList(category)) {
			removeNestedRules(listOfRules, rules);
		}
		application = (RulesApplication) getActivity().getApplicationContext();

		SectionsPagerAdapter mSectionsPagerAdapter = new SectionsPagerAdapter(
				getChildFragmentManager());

		ViewPager mViewPager = (ViewPager) rootView.findViewById(R.id.pager);
		mViewPager.setAdapter(mSectionsPagerAdapter);
		mViewPager.setCurrentItem(giveCorrectPosition(rule_position), true);

		return rootView;
	}

	private int giveCorrectPosition(int position) {
		String title = rules_array_original[position];
		for (int i = 0; i < listOfRules.size(); i++) {
			if (title.equals(listOfRules.get(i))) {
				return i;
			}
		}
		return position;
	}

	public static boolean isCategoryANestedList(String category) {
		return category.equals("core rules")
				|| category.equals("abilities")
				|| category.equals("general")
				|| category.equals("tactics")
				|| category.equals("power and abilities");
	}

	private boolean isRulesANestedRule(JSONObject rules) {
		return rules.has(RulesApplication.JSON_IS_NESTED);
	}

	private void addToRulesList(String[] array) {
		Collections.addAll(listOfRules, array);
	}

	@SuppressWarnings("unchecked")
	private void removeNestedRules(List<String> rulesList, JSONObject rules) {
		List<String> keysToRemove = new ArrayList<String>();
		Iterator<String> keys = rules.keys();
		while (keys.hasNext()) {
			String key = keys.next();
			try {
				JSONObject object = rules.getJSONObject(key);
				if (object.has(RulesApplication.JSON_IS_NESTED)) {
					keysToRemove.add(key);
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}

		for (String key : keysToRemove) {
			rules.remove(key);
			rulesList.remove(key);
		}
	}

	public class SectionsPagerAdapter extends FragmentPagerAdapter {

		public SectionsPagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {
			rule_position = position;
			Fragment fragment = new DummySectionFragment();
			Bundle args = new Bundle();
			args.putInt(DummySectionFragment.ARG_SECTION_NUMBER, position);
			fragment.setArguments(args);
			return fragment;
		}

		@Override
		public int getCount() {
			return listOfRules.size();
		}

		@Override
		public CharSequence getPageTitle(int position) {
			return listOfRules.get(position).toUpperCase(Locale.getDefault());
		}
	}

	/**
	 * A dummy fragment representing a section of the app, but that simply
	 * displays dummy text.
	 */
	public static class DummySectionFragment extends AbstractRuleFragment {
		/**
		 * The fragment argument representing the section number for this
		 * fragment.
		 */
		public static final String ARG_SECTION_NUMBER = "section_number";

		public DummySectionFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
		                         Bundle savedInstanceState) {
			View rootView = inflater.inflate(
					R.layout.fragment_main_activity_test_dummy, container,
					false);
			int position = getArguments().getInt(ARG_SECTION_NUMBER);
			SpannableStringBuilder builder;
			String title = listOfRules.get(position);
			try {
				if (RulesApplication.isPowerRule(category)) {
					builder = createPowerRule(getActivity(),
							rules.getJSONArray(category), position);
				} else {
					JSONObject rule = rules.getJSONObject(title);

					if (isFeat(category)) {
						builder = createFeat(getActivity(), rule);
					} else if (isObject(category)) {
						builder = createObject(getActivity(), rule);
					} else if (isHordeToken(category)) {
						builder = createHordetoken(getActivity(), rule);
					} else if (isAta(category)) {
						builder = createAta(getActivity(), rule);
					} else {
						builder = createRule(getActivity(), rule, title,
								category);
					}
				}
				((TextView) rootView.findViewById(R.id.general_rule))
						.setText(builder);
			} catch (JSONException e) {
				e.printStackTrace();
				((TextView) rootView.findViewById(R.id.general_rule))
						.setText(getString(R.string.no_rule));
			}
			return rootView;
		}
	}
}
