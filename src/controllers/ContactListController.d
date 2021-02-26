module controllers.ContactListController;

import views;

import gobject.ObjectG;
import gtk.Widget;
import gtk.Button;

import utils.GObjectType;
import utils.interfaces.gio.ListModelIF;
import gobject.Signals;
import gio.c.functions;

import models;

class ContactRowItem: ObjectG {
    Contact contact;
    this (Contact _contact) {
        super(getType, []);
        contact = _contact;
    }

    this(GObject* gStruct, bool owned) {
        super(gStruct, owned);
    }
}

class ContactListController: ObjectG, ListModelIF, StoreDelegate
{
    mixin GRegisterStaticType!(ContactListController, "ContactListController");

    private ContactsWidget _contacts;
    private Store _store;

    ContactsWidget view() {
        return _contacts;
    }

    this(GObject *gobj, bool owned = false) {
        super(gobj, owned);
        _contacts = new ContactsWidget();
        _store = new Store(this);
        _contacts.contactsListBox.bindModel!(ContactRowItem)(this, (ContactRowItem item) {
            auto row = new ContactRow();
            row.fill(item.contact.firstname, item.contact.secondname, item.contact.lastname);
            return row;
        });
        _contacts.onNewContact = (string firstname, string secondname, string lastname) {
            _store.addNewContact(new Contact(firstname, secondname, lastname));
        };
    }

    override {
        void onAddContact(Store store, Contact contact, uint index) {
            itemsChanged(index, 0, 1);
        }
    }

    override {
        void* getStruct() {
            return getObjectGStruct();
        }

        GListModel* getListModelStruct(bool transferOwnership = false) {
            return cast(GListModel*) getStruct;
        }

        GType getItemType() {
            return GType.OBJECT;
        }

        uint getNItems() {
            return _store.contactsCount;
        }

        ObjectG getObject(uint position) {
            return null;
        }

        void* getItem(uint position) {
            return (new ContactRowItem(_store.contactByIndex(position))).getStruct();
        }

        void itemsChanged(uint position, uint removed, uint added) {
            g_list_model_items_changed(getListModelStruct(), position, removed, added);
        }

        gulong addOnItemsChanged(void delegate(uint, uint, uint, ListModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
        {
            return Signals.connect(this, "items-changed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
        }
    }
}