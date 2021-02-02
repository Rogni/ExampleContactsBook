module models.Contact;


class Contact {

    this() {}

    this(string _firstname, string _secondname, string _lastname) {
        firstname = _firstname;
        secondname = _secondname;
        lastname = _lastname;
    }

    string firstname;
    string secondname;
    string lastname;

    string [] phones;
    string [] adresses;
}