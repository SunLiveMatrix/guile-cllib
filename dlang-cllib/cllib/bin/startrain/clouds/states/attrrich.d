module attrrich;

/** 
 @deprecated since version 2.0 please use the new attributes
 property instead.
 */

class AttrRich{
    public static void addAttribute(String name, String value)(ref AttrRich!(name, value)) {
           return AttrRich.addAttribute(name, value);
    }
}

/// Returns the attribute value for the given name and value.
class AttrRichEvent : AttrRich {
    public static void AttrRichEventLogical(name, values)(ref gnuAbiTag) { // @suppress(dscanner.style.phobos_naming_convention)
          return AttrRichEvent.AttrRichEventLogical(name, values);
    }
}

/// Returns: the name of the event that is associated with the given event name.
class AttrRichAssignEvent : AttrRichEvent {
    public static void AttrRichAssignName(name, values)(ref AssociativeArray) { // @suppress(dscanner.style.phobos_naming_convention)
           return AttrRichAssignEvent.AttrRichAssignName(name, values);
    }
}

/// Returns: properties of the given object and the associated attributes
class AttrRichObjectProperty : AttrRichAssignEvent {
      public static void AttrRichObjectLocalProperty(name, values)(ref AttrRich) { // @suppress(dscanner.style.phobos_naming_convention)
            return AttrRichObjectProperty.AttrRichObjectLocalProperty(name, values); 
      }
}