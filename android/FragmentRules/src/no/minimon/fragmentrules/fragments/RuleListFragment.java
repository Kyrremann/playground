package no.minimon.fragmentrules.fragments;

import no.minimon.fragmentrules.R;

import no.minimon.fragmentrules.RulesApplication;
import no.minimon.fragmentrules.utils.JSONFilenameMode;
import no.minimon.fragmentrules.utils.RuleListArrayAdapter;
import no.minimon.fragmentrules.utils.RuleSelectedListener;
import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

public class RuleListFragment extends AbstractRuleFragment implements OnItemClickListener {

	private RuleSelectedListener mCallback;
	private ListView listView;

	public RuleListFragment() {
		// Empty constructor required for fragment subclasses
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_rule_list, container,
				false);
		String title = getArguments().getString(ARG_RULE_TITLE);
		getActivity().setTitle(title);

		listView = (ListView) rootView.findViewById(R.id.rules_list);
		category = generateCategoryBasedOnTitle(title, JSONFilenameMode.TO_LOWERCASE_NAME);
		application = (RulesApplication) getActivity().getApplicationContext();
		rules_array = application.getTitlesOfRules(category);
		rules_array = moveGeneralItemToTopOfArray(rules_array);
		listView.setAdapter(new RuleListArrayAdapter(getActivity(),
				R.layout.rules_with_image_row, R.id.rule_row, rules_array, category));
		listView.setOnItemClickListener(this);
		return rootView;
	}

	private String generateCategoryBasedOnTitle(String title, JSONFilenameMode filenameMode) {
		return JSONFilenameMode.generateFilename(title, filenameMode);
	}

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		mCallback = (RuleSelectedListener) activity;
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int position,
			long arg3) {
		mCallback.onRuleSelectedListener(position, rules_array, category);
	}

	public void notifyListChanged() {
		rules_array = application.getTitlesOfRules(category);
		rules_array = moveGeneralItemToTopOfArray(rules_array);
		listView.setAdapter(new RuleListArrayAdapter(getActivity(),
				R.layout.rules_with_image_row, R.id.rule_row, rules_array, category));
	}
}
