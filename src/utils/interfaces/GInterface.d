module utils.interfaces.GInterface;

import gobject.Type;

void registerStaticInterface(GInterfaceType)(GType) {
    static assert(false, "Can find C bint to " ~ GInterfaceType.stringof ~ " interface");
}