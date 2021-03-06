module utils.GObjectType;

import std.traits: BaseClassesTuple;

import gobject.c.types;
import gobject.c.functions;

import gobject.Type;
import gobject.ObjectG;

import utils.interfaces.GInterface;

/**
 * Check, if Type have ObjectG parent class
 */
template IsObjectGChild(Type)
{
    public import std.meta: anySatisfy;
    public import std.traits: BaseClassesTuple;
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

/**
 * Create new ObjectG child instance
 */
GObjType newGObject(GObjType)(GParameter[] parameters = []) if (IsObjectGChild!GObjType) {
    return cast(GObjType) new ObjectG(GObjType.getType, parameters);
}

/**
 * 
 */
mixin template GRegisterStaticType(Typename, string gtypename) 
{
    private GObject * gObject = null;

    private extern(C) static void init_g_object(void* self, void* klass) {
        auto asGObject = cast(GObject*)self;
        auto t = new Typename(asGObject, true);
        t.gObject = asGObject;
        t.ref_();
    }

    static GType getType() 
    {
        import std.traits: BaseClassesTuple, InterfacesTuple;
        import gobject.Type;

        static GType type = GType.INVALID;
        if (type == GType.INVALID) {
            alias ParentType = BaseClassesTuple!Typename[0];
            GType parent_g_type = ParentType.getType();
            GTypeQuery parent_type_query;
            Type.query(parent_g_type, parent_type_query);
            static GTypeInfo info;
            info.classSize = cast(ushort)parent_type_query.classSize;
            info.baseInit = null;
            info.baseFinalize = null;
            info.classInit = null;
            info.classFinalize = null;
            info.classData = null;
            info.instanceSize = cast(ushort)parent_type_query.instanceSize;
            info.nPreallocs = 0;
            info.instanceInit = &init_g_object;
            info.valueTable = null;

            type = Type.registerStatic(parent_g_type, gtypename, &info, cast(GTypeFlags) 0);
            static foreach (iface; InterfacesTuple!Typename)
            {   
                static if ( __traits(compiles, iface.getType)) {
                    Type.addInterfaceStatic(type, ListModelIF.getType(), getInterfaceInfo!iface());
                }
            }

        }
        return type;
    }
}


version(unittest) {
    class A : ObjectG 
    {
        mixin GRegisterStaticType!(A, "TestTypeA");

        string test_field;

        this(GObject * gstruct, bool owned = false) {
            super(gstruct, owned);
            test_field = "test";
            
        }

        ~this() {
        }
    }
}

unittest {
    GType atype = A.getType;
    assert(Type.fromName("TestTypeA") == atype);
    A a = newGObject!A();
    assert(a.test_field == "test");
    a.test_field = "test2";
    A a2 = ObjectG.getDObject!A(a.getObjectGStruct());
    assert(a2.test_field == "test2");
    ObjectG a3 = new ObjectG(atype, []);
    assert(a3 !is null);

    A a3_as_a = cast(A)(a3);
    assert(a3_as_a !is null);
    assert(a3_as_a.test_field == "test");
}
