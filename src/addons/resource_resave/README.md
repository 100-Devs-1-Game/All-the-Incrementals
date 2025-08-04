Don't ask me why godot doesn't do this :(

The downside is that this could cause extra merge conflicts with people editing a resource on one branch, when its definition changes on another. However, these merge conflicts should happen because the likely outcome of avoiding the conflict is having lost data and broken resources

For example, changing the type of a dictionary in a Resource from Dictionary[string, int] to Dictionary[string, int] without resaving all the resource files using it, will cause them to remain as Dictionary[int, int] on-disk and then fail to open/function correctly. That change in datatype will also cause all data assigned to the files to be lost, but we can't avoid that for fundamentally different types
