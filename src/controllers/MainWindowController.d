module controllers.MainWindowController;

import views;
import controllers.ContactListController;
import gtk.Application;
import gtk.Stack;
import gtk.Button;
import utils.GObjectType;

class MainWindowController {
    private MainWindow _window;
    private ContactListController _contactsListController;

    this(Application app) {
        _window = new MainWindow(app);
        _contactsListController = newGObject!ContactListController();
        _window.stack.add(_contactsListController.view);
        _window.showAll();
    }
}