package no.uio.ifi.sonen.ai.dotwars;

public enum Type {

    EMPTY('.'), RESOURCE('@'), CASTLE('#');

    char c;

    private Type(char c) {
        this.c = c;
    }

    public static Type getType(char c) {
        for (Type t : values())
            if (t.c == c)
                return t;
        return null;
    }
}