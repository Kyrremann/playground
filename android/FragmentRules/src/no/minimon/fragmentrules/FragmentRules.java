package no.minimon.fragmentrules;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import no.minimon.fragmentrules.fragments.*;
import no.minimon.fragmentrules.utils.ChangelogUtil;
import no.minimon.fragmentrules.utils.RuleSelectedListener;

import java.util.List;
import java.util.Locale;

import static android.support.v4.app.FragmentManager.POP_BACK_STACK_INCLUSIVE;

public class FragmentRules extends FragmentActivity implements
		RuleSelectedListener {

	private static final int SETTINGS_ACTIVITY = 128;
	private static final String STACK_TAG = "LIST";

	protected DrawerLayout mDrawerLayout;
	protected ListView mDrawerList;
	protected CharSequence mDrawerTitle;
	protected ActionBarDrawerToggle mDrawerToggle;

	protected CharSequence mTitle;
	protected String[] mRulesTitles;
	protected int selectedDrawer;
	private AlertDialog donateDialog, aboutDialog, changelogDialog;
	private RulesApplication application;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		application = (RulesApplication) getApplication();
		application.setLanguage(PreferenceManager.getDefaultSharedPreferences(
				this).getString(SettingsActivity.PREFS_LANGUAGE,
				RulesApplication.ENGLISH));

		mTitle = mDrawerTitle = getTitle();
		mRulesTitles = getResources().getStringArray(R.array.rules_array);

		initDrawer();
		createDrawer(savedInstanceState);
	}

	private void initDrawer() {
		mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
		mDrawerList = (ListView) findViewById(R.id.left_drawer);
		mDrawerToggle = new ActionBarDrawerToggle(this, /* host Activity */
				mDrawerLayout, /* DrawerLayout object */
				R.drawable.ic_drawer, /* nav drawer image to replace 'Up' caret */
				R.string.drawer_open, /* "open drawer" description for accessibility */
				R.string.drawer_close) { /* "close drawer" description for accessibility */

			public void onDrawerClosed(View view) {
			}

			public void onDrawerOpened(View drawerView) {
			}
		};

		// set a custom shadow that overlays the main content when the drawer
		// opens
		mDrawerLayout.setDrawerShadow(R.drawable.drawer_shadow, GravityCompat.START);
		// set up the drawer's list view with items and click listener
		mDrawerList.setAdapter(new ArrayAdapter<String>(this,
				R.layout.drawer_list_item, mRulesTitles));
		mDrawerList.setOnItemClickListener(new DrawerItemClickListener());
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.main, menu);
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// The action bar home/up action should open or close the drawer.
		// ActionBarDrawerToggle will take care of this.
		if (mDrawerToggle.onOptionsItemSelected(item)) {
			return true;
		}
		// Handle action buttons
		switch (item.getItemId()) {
			case R.id.menu_about:
				showAboutDialog();
				break;
			case R.id.menu_settings:
				startActivityForResult(
						createIntent(SettingsActivity.class,
								SettingsActivityHoneyComb.class), SETTINGS_ACTIVITY);
				selectItem(selectedDrawer);
				break;
			case R.id.menu_donate:
				showDonateDialog();
				break;
			case R.id.menu_feedback:
				startFeedbackActivity();
				break;
			case R.id.menu_changelog:
				showChangelog();
				break;
			default:
				return super.onOptionsItemSelected(item);
		}
		return true;
	}

	/**
	 * Used to switch between pre-honeycomb classes and post-honeycom classes
	 *
	 * @param normalClass    The pre-honeycomb class
	 * @param honeyCombClass The post-honeycomb class
	 * @return A new intent using the correct class
	 */
	private Intent createIntent(Class normalClass,
	                            Class honeyCombClass) {
		Intent intent;
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			intent = new Intent(this, honeyCombClass);
		} else {
			intent = new Intent(this, normalClass);
		}
		return intent;
	}

	/* The click listener for ListView in the navigation drawer */
	private class DrawerItemClickListener implements
			ListView.OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position,
		                        long id) {
			selectedDrawer = position;
			selectItem(position);
		}
	}

	/**
	 * // update the main content by replacing fragments
	 *
	 * @param position in the drawer-list
	 */
	protected void selectItem(int position) {
		Fragment fragment = new RuleListFragment();
		Bundle args = new Bundle();
		args.putString(AbstractRuleFragment.ARG_RULE_TITLE, mRulesTitles[position]);
		fragment.setArguments(args);

		FragmentManager fragmentManager = getSupportFragmentManager();
		fragmentManager.popBackStack(STACK_TAG, POP_BACK_STACK_INCLUSIVE);
		fragmentManager.beginTransaction()
				.replace(R.id.content_frame, fragment, mRulesTitles[position])
				.addToBackStack(STACK_TAG)
				.commit();

		// update selected item and title, then close the drawer
		mDrawerList.setItemChecked(position, true);
		setTitle(mRulesTitles[position]);
		mDrawerLayout.closeDrawer(mDrawerList);
	}

	protected void createDrawer(Bundle savedInstanceState) {
		// ActionBarDrawerToggle ties together the the proper interactions
		// between the sliding drawer and the action bar app icon
		mDrawerLayout.setDrawerListener(mDrawerToggle);

		if (savedInstanceState == null) {
			getSupportFragmentManager().beginTransaction()
					.replace(R.id.content_frame, new StartScreenFragment())
					.commit();
		}
	}

	@Override
	public void setTitle(CharSequence title) {
		super.setTitle(mTitle);
		mTitle = title;
	}

	/**
	 * When using the ActionBarDrawerToggle, you must call it during
	 * onPostCreate() and onConfigurationChanged()...
	 */
	@Override
	protected void onPostCreate(Bundle savedInstanceState) {
		super.onPostCreate(savedInstanceState);
		// Sync the toggle state after onRestoreInstanceState has occurred.
		mDrawerToggle.syncState();
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
		// Pass any configuration change to the drawer toggle
		mDrawerToggle.onConfigurationChanged(newConfig);
	}

	@Override
	public void onRuleSelectedListener(int position, String[] rules, String category) {
		Fragment fragment;
		if (isRuleNestedHierarchy(rules[position], category)) {
			fragment = changeToNestedRuleFragment(rules[position]);
		} else {
			fragment = changeToSectionsRuleFragment(position, rules);
		}
		getSupportFragmentManager().beginTransaction()
				.replace(R.id.content_frame, fragment)
				.addToBackStack(null)
				.commit();
	}

	private Fragment changeToNestedRuleFragment(String rule) {
		Fragment fragment = new NestedRuleFragment();
		Bundle args = new Bundle(5);
		args.putString(SectionsRuleFragment.ARG_CATEGORY, mTitle.toString().toLowerCase(Locale.getDefault()));
		args.putString(RuleListFragment.ARG_RULE_TITLE, rule);
		fragment.setArguments(args);
		return fragment;
	}

	private Fragment changeToSectionsRuleFragment(int position, String[] rules) {
		Fragment fragment = new SectionsRuleFragment();
		Bundle args = new Bundle(4);
		String category = mTitle.toString().replaceAll("\\spowers", "")
				.toLowerCase(Locale.getDefault());
		args.putString(SectionsRuleFragment.ARG_CATEGORY, category);
		args.putInt(SectionsRuleFragment.ARG_RULE_POSITION, position);
		args.putStringArray(SectionsRuleFragment.ARG_RULES, rules);
		args.putString(AbstractRuleFragment.ARG_OBJECT, application.getJSONRules(category).toString());
		fragment.setArguments(args);
		return fragment;
	}

	@Override
	public void onNestedRuleSelectedListener(int position, String[] rules,
	                                         String category, String nestedRule) {
		Fragment fragment = new SectionsRuleFragment();
		Bundle args = new Bundle(5);
		category = category.replaceAll("\\spowers", "")
				.toLowerCase(Locale.getDefault());
		args.putString(SectionsRuleFragment.ARG_CATEGORY, category);
		args.putString(SectionsRuleFragment.ARG_NESTED_CATEGORY, nestedRule);
		args.putInt(SectionsRuleFragment.ARG_RULE_POSITION, position);
		args.putStringArray(SectionsRuleFragment.ARG_RULES, rules);
		args.putString(AbstractRuleFragment.ARG_OBJECT, application
				.getNestedJSONRules(category, nestedRule).toString());
		fragment.setArguments(args);

		getSupportFragmentManager().beginTransaction()
				.replace(R.id.content_frame, fragment).addToBackStack(null)
				.commit();
	}

	private void createDonateDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("Donation");
		builder.setMessage(R.string.donate_text);
		builder.setPositiveButton(android.R.string.ok,
				new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						Intent browserIntent = new Intent(
								"android.intent.action.VIEW",
								Uri.parse(getString(R.string.donate_url)));
						startActivity(browserIntent);
					}
				});
		builder.setNegativeButton(R.string.dialog_button_later,
				new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				});

		donateDialog = builder.create();
	}

	public void createAboutDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle(R.string.dialog_title_about);
		builder.setMessage(R.string.about_message);
		builder.setPositiveButton(R.string.dialog_button_rate,
				new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						String url;
						// url = getString(R.string.rate_url_amazon);
						url = getString(R.string.rate_url_playstore);

						Intent browserIntent = new Intent(
								"android.intent.action.VIEW", Uri
								.parse(url));

						startActivity(browserIntent);
					}
				});

		builder.setNeutralButton(android.R.string.ok,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				});
		builder.setNegativeButton(R.string.dialog_button_donate,
				new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						showDonateDialog();
					}
				});

		aboutDialog = builder.create();
	}

	private void createChangelogDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle(R.string.changelog_title);
		builder.setView(ChangelogUtil.getChangelogView(this));
		builder.setNeutralButton(android.R.string.ok,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				});
		changelogDialog = builder.create();
	}

	private void startFeedbackActivity() {
		Intent intent = new Intent(Intent.ACTION_SEND);
		intent.setType("plain/text");
		intent.putExtra(Intent.EXTRA_EMAIL,
				new String[]{getString(R.string.e_mail)});
		String version = "3.*";
		try {
			version = getPackageManager().getPackageInfo(
					getString(R.string.package_name), 0).versionName;
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}

		intent.putExtra(Intent.EXTRA_SUBJECT,
				getString(R.string.feedback_subject) + " " + version);
		startActivity(Intent.createChooser(intent, ""));
	}

	/**
	 * The listener for the icon on the front screen
	 *
	 * @param view The view that got clicked
	 */
	public void onStartScreenClicked(View view) {
		switch (view.getId()) {
//		case R.id.speed:
//			switchToPower("Speed powers");
//			selectedDrawer = 0;
//			break;
//		case R.id.attack:
//			switchToPower("Attack powers");
//			selectedDrawer = 1;
//			break;
//		case R.id.defense:
//			switchToPower("Defense powers");
//			selectedDrawer = 2;
//			break;
//		case R.id.damage:
//			switchToPower("Damage powers");
//			selectedDrawer = 3;
//			break;
			case R.id.instruction:
				mDrawerLayout.openDrawer(GravityCompat.START);
				break;
			case R.id.changelog:
				showChangelog();
				break;
		}
	}

	private void showChangelog() {
		if (changelogDialog == null) {
			createChangelogDialog();
		}
		changelogDialog.show();
	}

	private void showDonateDialog() {
		if (donateDialog == null) {
			createDonateDialog();
		}
		donateDialog.show();
	}

	private void showAboutDialog() {
		if (aboutDialog == null) {
			createAboutDialog();
		}
		aboutDialog.show();
	}


	private void switchToPower(String power) {
		Fragment fragment = new RuleListFragment();
		Bundle args = new Bundle();
		args.putString(RuleListFragment.ARG_RULE_TITLE, power);
		fragment.setArguments(args);

		FragmentManager fragmentManager = getSupportFragmentManager();
		fragmentManager.popBackStack(STACK_TAG, POP_BACK_STACK_INCLUSIVE);
		fragmentManager.beginTransaction()
				.replace(R.id.content_frame, fragment)
				.addToBackStack(STACK_TAG)
				.commit();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == SETTINGS_ACTIVITY) {
			RuleListFragment fragment = getVisibleFragment();
			if (fragment != null) {
				fragment.notifyListChanged();
			}
		} else {
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	public RuleListFragment getVisibleFragment() {
		FragmentManager fragmentManager = getSupportFragmentManager();
		List<Fragment> fragments = fragmentManager.getFragments();
		for (Fragment fragment : fragments) {
			if (fragment != null && fragment.isVisible())
				if (fragment instanceof RuleListFragment) {
					return (RuleListFragment) fragment;
				} else {
					break;
				}
		}
		return null;
	}
}