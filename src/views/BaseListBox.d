module views.BaseListBox;

import gtk.ListBox;
import gio.ListModelIF;
import gobject.ObjectG;

import gtk.Widget;

import std.traits;
import std.meta;


private template IsObjectGChild(Type)
{
    template IsObjectG(T) {
        enum IsObjectG = is(T==ObjectG);
    }

    enum IsObjectGChild = is(Type == class) && anySatisfy!(IsObjectG, BaseClassesTuple!Type); 
}

unittest {
    class A: ObjectG { this() {super(getType(), []);}}
    class B: A {}
    class C {}
    static assert(IsObjectGChild!A);
    static assert(IsObjectGChild!B);
    static assert(!IsObjectGChild!C);
    static assert(!IsObjectGChild!float);
}


class BaseListBox: ListBox {
    alias CreateRowDelegate = Widget delegate(void* item);
    private CreateRowDelegate _createRowDg;

    this() {
        super();
    }

    this(GtkListBox* gStruct, bool owned = false) {
        super(gStruct, owned);
    }

    void bindModel(ItemType)(ListModelIF model, Widget delegate(ItemType * item) create_row)
        if (!IsObjectGChild!ItemType)
    {
        _createRowDg = (void * item) {
            ItemType * asItemT = cast(ItemType *)item;
            return create_row(asItemT);
        };
        ListBox.bindModel(model, &createRowImpl, this.getStruct, null);
    }

    void bindModel(ItemType)(ListModelIF model, Widget delegate(ItemType item) create_row)
        if (IsObjectGChild!ItemType)
    {
        _createRowDg = (void * item) {
            ItemType asItemT = ObjectG.getDObject!ItemType(cast(GObject*) item);
            return create_row(asItemT);
        };
        ListBox.bindModel(model, &createRowImpl, this.getStruct, null);
    }

    private static extern (C) GtkWidget * createRowImpl(void* item, void* listBox) {
        BaseListBox baseListBox = ObjectG.getDObject!BaseListBox(cast(GtkListBox*) listBox);
        auto row = baseListBox._createRowDg(item);
        return row.getWidgetStruct();
    }
}