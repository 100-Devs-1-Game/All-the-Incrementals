Don't ask me why godot doesn't do this :(

The downside is that this could cause extra merge conflicts with people editing a resource on one branch, when its definition changes on another. However, these merge conflicts should happen because the likely outcome of avoiding the conflict is having lost data and broken resources

For example, changing the type of a dictionary in a Resource from `Dictionary[string, int]` to `Dictionary[int, int]` without resaving all the resource files using it, will cause them to remain with the original `Dictionary[string, int]` data on-disk and then fail to open/function correctly

That change in datatype will also cause all data assigned to the files to be lost, but we can't avoid that for fundamentally different types

This is the source of errors like "Failed to assign array of type Array[Object] with Array[Object]", because the type of data in each object is different, even though they're the same type of Resource
