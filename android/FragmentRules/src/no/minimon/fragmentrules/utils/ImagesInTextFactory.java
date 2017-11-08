package no.minimon.fragmentrules.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.Drawable;
import android.preference.PreferenceManager;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ImageSpan;
import no.minimon.fragmentrules.SettingsActivity;

public class ImagesInTextFactory {

	public static final float IMAGE_THRESHOLD_DP = 24f;
	private static int image_dp = 24;
	private static float scale = 0f;

	/**
	 *
	 * @param context The context of the activity
	 * @param rule The stringe to be parsed
	 * @return The rule in a SpannableStringBuilder with images or the name inserted in the rule
	 */
	public static SpannableStringBuilder parseText(Context context, String rule) {
		if (scale == 0) {
			calculateImageScale(context);
		}

		SharedPreferences preferences = PreferenceManager
				.getDefaultSharedPreferences(context);
		boolean image = preferences.getBoolean(SettingsActivity.PREFS_IMAGES,
				true);
		if (image) {
			return parseTextAndInsertImages(context, rule);
		} else {
			return parseTextAndInsertText(context, rule);
		}
	}

	/**
	 * Calculate the scale and image_dp of the images that are going to be inserted
	 * based on the density of the screen
	 * @param context The context of the activity
	 */
	private static void calculateImageScale(Context context) {
		scale = context.getResources().getDisplayMetrics().density;
		image_dp = (int) (IMAGE_THRESHOLD_DP * scale + 0.5f);
	}

	private static SpannableStringBuilder parseTextAndInsertText(
			Context context, String rule) {
		String[] tmp = rule.split("\\|");
		SpannableStringBuilder builder = new SpannableStringBuilder();
		builder.append(tmp[0]);

		for (int i = 1; i < tmp.length; i++) {
			String text = null;
			if (tmp[i].equals("speed")) {
				text = tmp[i];
			} else if (tmp[i].equals("attack")) {
				text = tmp[i];
			}

			if (text != null) {
				builder.append(text);
			} else {
				builder.append(tmp[i]);
			}
		}

		return builder;
	}

	private static SpannableStringBuilder parseTextAndInsertImages(
			Context context, String rule) {
		String[] tmp = rule.split("\\|");
		SpannableStringBuilder builder = new SpannableStringBuilder();
		builder.append(tmp[0]);
		int lengthOfPart = builder.length();
		builder.append(" ");
		for (int i = 1; i < tmp.length; i++) {
			int image = -1;
			Drawable d;
			if (tmp[i].equals("speed")) {
				image = -1;
			} else if (tmp[i].equals("attack")) {
				image = -1;
			}

			if (image != -1) {
				d = context.getResources().getDrawable(image);
				if (d == null) {
					builder.append(tmp[i]);
					builder.append(" ");
					lengthOfPart += tmp[i].length() + 1;
				} else {
					if (imageExtraWide(tmp[i])) {
						d.setBounds(0, 0, image_dp * 2, image_dp);
					} else {
						d.setBounds(0, 0, image_dp, image_dp);
					}
					ImageSpan myImage = new ImageSpan(d, ImageSpan.ALIGN_BASELINE);
					builder.setSpan(myImage, lengthOfPart, lengthOfPart + 1,
							Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
					builder.append("");
				}
			} else {
				builder.append(tmp[i]);
				builder.append(" ");
				lengthOfPart += tmp[i].length() + 1;
			}
		}
		return builder;
	}

	/**
	 * Some images may be wider then the others, use this method to check for width
	 * @param string String to be checked against
	 * @return true if the string is an image that should use the wide setting
	 */
	private static boolean imageExtraWide(String string) {
		return false;
	}
}
