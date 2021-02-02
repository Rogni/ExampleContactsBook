module views.ContactRow;

import gtk.ListBoxRow;
import gtk.Box;
import gtk.Label;

class ContactRow: ListBoxRow {
    Label firstnameLabel;
    Label secondnameLabel;
    Label lastnameLabel;
    this() {
        super();
        Box box = new Box(GtkOrientation.VERTICAL, 2);
        firstnameLabel = new Label("");
        box.packStart(firstnameLabel, false, false, 0);
        secondnameLabel = new Label("");
        box.packStart(secondnameLabel, false, false, 0);
        lastnameLabel = new Label("");
        box.packStart(lastnameLabel, false, false, 0);
        add(box);
        showAll();
    }

    void fill(string firstname, string secondname, string lastname) {
        firstnameLabel.setText(firstname);
        secondnameLabel.setText(secondname);
        lastnameLabel.setText(lastname);
    }
}