module utils.interfaces.GInterface;

import gobject.Type;

GInterfaceInfo * getInterfaceInfo(GInterfaceType)() {
    static assert(false, "Can find C bint to " ~ GInterfaceType.stringof ~ " interface");
}