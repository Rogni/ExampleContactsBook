module models.Store;

import models.Contact;

interface StoreDelegate {
    void onAddContact(Store store, Contact contact, uint index);
}

class Store {
    private Contact [] _contacts;
    private StoreDelegate _dg;
    this(StoreDelegate dg) {
        _contacts = [
            new Contact("first0", "second0", "last0"),
            new Contact("first1", "second1", "last1")
        ];
        _dg = dg;
    }

    uint contactsCount() {
        return cast(uint) _contacts.length;
    }

    Contact contactByIndex(uint index) {
        return _contacts[index];
    }

    void addNewContact(Contact contact) {
        _contacts ~= contact;
        if (_dg) {
            _dg.onAddContact(this, contact, cast(uint) (_contacts.length - 1));
        }
    }
}
