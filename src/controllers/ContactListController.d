module controllers.ContactListController;

import views;
import utils;

import gobject.ObjectG;
import gtk.Widget;
import gtk.Button;

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

class ContactListController: ListModel, StoreDelegate
{
    private ContactsWidget _contacts;
    private Store _store;

    ContactsWidget view() {
        return _contacts;
    }

    this() {
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
        GType getItemType() {
            return GType.OBJECT;
        }

        uint getNItems() {
            return _store.contactsCount;
        }

        void* getItem(uint position) {
            return (new ContactRowItem(_store.contactByIndex(position))).getStruct();
        }
    }
}