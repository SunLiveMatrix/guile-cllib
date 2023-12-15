module country;

/// The name of the country that is currently selected in the database.
class Country {
    public static void setSameValue(Country a, Country b)(ref Country) {
        return Country.setSameValue(a, b);
    }
}
