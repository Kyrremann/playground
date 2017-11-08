package no.minimon.fragmentrules.utils;

import java.util.Locale;

public enum JSONFilenameMode {

	TO_LOWERCASE_NAME,
	TO_UPPERCASE_NAME,
	USE_UPPERCASE_LETTERS,
	INITIAL_NAME;

	public static String generateFilename(String title, JSONFilenameMode filenameMode) {
		String filename = "";
		switch (filenameMode) {
			case TO_LOWERCASE_NAME:
				return title.toUpperCase(Locale.ENGLISH).replace("\\s", "_");
			case TO_UPPERCASE_NAME:
				return title.toLowerCase(Locale.ENGLISH).replace("\\s", "_");
			case USE_UPPERCASE_LETTERS:
				char[] chars = title.toCharArray();
				for (char aChar : chars) {
					if (Character.isUpperCase(aChar)) {
						filename += aChar;
					}
				}
				return filename;
			case INITIAL_NAME:
				String[] array = title.split("\\s");
				for (String s : array) {
					if (s.isEmpty()) {
						filename += s.charAt(0);
					}
				}
				return filename;
		}

		return generateFilename(title, TO_LOWERCASE_NAME);
	}
}
