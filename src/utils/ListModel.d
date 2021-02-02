module utils.ListModel;

import gobject.ObjectG;
import gobject.Type;

import gobject.c.types;
import gobject.c.functions;

import gio.c.functions;
import gio.c.types;

import gio.ListModelT;
import gio.ListModelIF;

class ListModel: ObjectG, ListModelIF
{
    this(GObject* gObject, bool owned = false) {
        super(gObject, owned);
    }

    this() {
        super(ListModel.getType, []);
    }

    void* getItem(uint position) {
        return null;
    }

    GType getItemType() {
        return GType.INVALID;
    }

    uint getNItems() {
        return 0;
    }

    ObjectG getObject(uint position) {
        return null;
    }

    static GType getType() {
        static GType type = GType.INVALID;
        if (type == GType.INVALID) {
            static GTypeInfo info = {
                GObjectClass.sizeof,
                null,
                null,
                null,
                null,
                null,
                GObject.sizeof,
                0,
                null,
                null
            };

            type = Type.registerStatic(GType.OBJECT, "ListModel", &info, cast(GTypeFlags) 0);
            
            GInterfaceInfo list_iface_info = {
                cast(GInterfaceInitFunc)&init_list_model_interface,
                null, 
                null
            };

            Type.addInterfaceStatic(type, ListModelIF.getType(), &list_iface_info);
        }
        return type;
    }

    private static extern (C) void init_list_model_interface(
                                    GListModelInterface* list,
                                    void* iface_data) {
        list.getItem = &getItemImpl;
        list.getNItems = &getNItemsImpl;
        list.getItemType = &getItemTypeImpl;
    } 

    private static extern (C) GType getItemTypeImpl(GListModel* list) 
    {
        return getDObject!(ListModel)(cast(GObject*)list).getItemType();
    }

    private static extern (C) uint getNItemsImpl(GListModel* list) {
        return getDObject!(ListModel)(cast(GObject*)list).getNItems();
    }

    private static extern (C) void* getItemImpl(GListModel* list, uint position) {
        return getDObject!(ListModel)(cast(GObject*)list).getItem(position);
    }

    override {
        void * getStruct() {
            return ObjectG.getStruct();
        }

        GListModel* getListModelStruct(bool transferOwnership = false) {
            return cast(GListModel*) getObjectGStruct(transferOwnership);
        }

        public void itemsChanged(uint position, uint removed, uint added) {
            g_list_model_items_changed(getListModelStruct(), position, removed, added);
        }

        gulong addOnItemsChanged(void delegate(uint, uint, uint, ListModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
        {
            return Signals.connect(this, "items-changed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
        }
    }

}