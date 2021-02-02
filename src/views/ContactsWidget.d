module views.ContactsWidget;

import gtk.Bin;
import gtk.Box;
import gtk.ActionBar;

import views.BaseListBox;
import gtk.ActionBar;
import gtk.Entry;
import gtk.Button;
import gtk.MenuButton;
import gtk.Popover;


class ContactsWidget: Box
{
    BaseListBox contactsListBox;

    void delegate(string firstname, string secondname, string lastname) onNewContact;

    this() {
        super(GtkOrientation.VERTICAL, 0);
        contactsListBox = new BaseListBox();
        ActionBar bar = new ActionBar();

        packEnd(contactsListBox, true, true, 0);
        packEnd(bar, false, false, 0);
        
        MenuButton addButton = new MenuButton();
        Popover popover = new Popover(addButton);
        addButton.setPopover(popover);
        auto newContact = new NewContactWidget;
        newContact.onAddClicked = (string firstname, string secondname, string lastname) {
            popover.hide();
            if (onNewContact) {
                onNewContact(firstname, secondname, lastname);
            }
        };

        popover.add(newContact);
        bar.add(addButton);
        showAll();
    }
}

class NewContactWidget: Box
{
    void delegate (string, string, string) onAddClicked;

    this() {
        super(GtkOrientation.VERTICAL, 2);
        Entry firstname = new Entry();
        firstname.setPlaceholderText("Firstname");
        Entry secondname = new Entry();
        secondname.setPlaceholderText("Secondname");
        Entry lastname = new Entry();
        lastname.setPlaceholderText("Lastname");
        Button addButton = new Button("Add");
        addButton.addOnClicked((Button) {
            if (onAddClicked) {
                onAddClicked(firstname.getText, secondname.getText, lastname.getText);
                firstname.setText("");
                secondname.setText("");
                lastname.setText("");
            }
        });
        
        packStart(firstname, false, false, 0);
        packStart(secondname, false, false, 0);
        packStart(lastname, false, false, 0);
        packStart(addButton, false, false, 0);
        showAll();
    }
}