module views.MainWindow;

import gtk.ApplicationWindow;
import gtk.ListBox;
import gtk.ListBoxRow;
import gtk.Stack;
import gtk.Paned;
import gtk.Application;
import gtk.Main;

public import views.BaseListBox;
import gtk.Application;
import gtk.Button;
import gtk.Window;

class MainWindow: ApplicationWindow {

    Stack stack;
    
    this(Application app) {
        super(app);
        addOnHide((Widget){
            app.quit();
        });
        stack = new Stack();
        add(stack);
        setTitle("Test application");
        showAll();
    }
}