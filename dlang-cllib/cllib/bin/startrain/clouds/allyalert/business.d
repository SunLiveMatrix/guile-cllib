module business;

/// The application that will be responsible for the application.
class Application {
    public static const ApplicationName = "Application"; // @suppress(dscanner.style.phobos_naming_convention)
}

/// @deprecated Use the application name instead of the application name
class ApplicationInputPattern : Application {
     public static void main(String, Application)(ref Application) {
        return ApplicationInputPattern.main(String, Application);
     }
}

/// The application name that is used to generate the input pattern for the application
class ApplicationUsePattern : Application {
    public static void main(String, Application)(ref Application) {
        return ApplicationUsePattern.main(String, Application);
    }
}

