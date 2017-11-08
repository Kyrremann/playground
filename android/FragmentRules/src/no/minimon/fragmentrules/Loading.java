package no.minimon.fragmentrules;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;

public class Loading extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_loading);

		new Handler().postDelayed(new Runnable() {
			@Override
			public void run() {
				Intent intent;
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
					intent = new Intent(Loading.this, FragmentRulesHoneyComb.class);
				} else {
					intent = new Intent(Loading.this, FragmentRules.class);
				}
				startActivity(intent);
				finish();
			}
		}, 1200);
	}

}
