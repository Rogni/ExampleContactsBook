module utils.interfaces.gio.ListModelIF;

public import gio.ListModelIF;
public import utils.interfaces.GInterface;

import gobject.ObjectG;
import gobject.Type;

GInterfaceInfo * getInterfaceInfo(GInterfaceType: ListModelIF)() {
    static GInterfaceInfo info = {
            cast(GInterfaceInitFunc)&init_list_model_interface,
            null, 
            null
    };
    return &info; 
}

private extern (C) void init_list_model_interface(
                                GListModelInterface* list,
                                void* iface_data) {
    list.getItem = &getItemImpl;
    list.getNItems = &getNItemsImpl;
    list.getItemType = &getItemTypeImpl;
} 

private extern (C) GType getItemTypeImpl(GListModel* list) 
{
    return ObjectG.getDObject!(ListModelIF)(cast(GObject*)list).getItemType();
}

private extern (C) uint getNItemsImpl(GListModel* list) {
    return ObjectG.getDObject!(ListModelIF)(cast(GObject*)list).getNItems();
}

private extern (C) void* getItemImpl(GListModel* list, uint position) {
    return ObjectG.getDObject!(ListModelIF)(cast(GObject*)list).getItem(position);
}