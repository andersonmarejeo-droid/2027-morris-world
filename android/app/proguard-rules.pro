# WorkManager 2.7 uses Room reflection to construct this generated database
# implementation. The old Room consumer rule retains the class name but, with
# current R8 optimization, can remove its no-argument constructor. Keep the
# constructor so the AndroidX Startup initializer can create WorkManager.
-keep class androidx.work.impl.WorkDatabase_Impl {
    <init>();
}
