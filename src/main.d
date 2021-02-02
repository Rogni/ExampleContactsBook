import gtk.Main;

import views;
import controllers;
import gtk.Application;

void main(string[] args)
{
    // Main.init(args);
    Application app = new Application("contactlist.app", GApplicationFlags.FLAGS_NONE);
    app.addOnStartup(delegate(Application) {
        import std.stdio: writeln;
        "+".writeln;
        MainWindowController mainController = new MainWindowController(app);

    });
    app.run(args);
    // Main.run();
}