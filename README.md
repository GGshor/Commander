# Maintained Commander
Welcome to the maintained version of Commander!

# Config

## Administrator

```lua
module.Admins = {
  ["GGshor"] = "Owner"
}
```

This table is where you put down all the administrators in Commander, Commander accepts three types of administrators -- Usernames, UserIds and group ranks. Here we will walk you through using each of them:

### Using Usernames
For your information, you may want to avoid using this method, as if the user happened to change their name, their administrator access will be revoked.

```lua
module.Admins = {
  ["Username"] = "Level"
}
```

The `Username` part is where you put the username of the administrator, where the `level` part is where you put the administrator's level. By default, Commander comes with `Moderator`, `Admin`, and `Owner`, each of them has different permission for commands.

### Using UserId
If you want to set a specific user to be an administrator in Commander, you may want to use the UserId option, not only it is unique, it won't be revoked due to a username change.

```lua
module.Admins = {
  [101010] = "Level"
}
```

Using UserId is similar to how you use usernames to setup administrators, but this time, rather than putting a `string`, you are supposed to put a number form, which should be the UserId of the user.

### Using group ranks
Setting every administrators for your group game with the two options above may be time consuming and labour intensive, that's why we came up with group ranks, with that, you can automate the setup process for a range of administrators by filling in the corresponding group Id, and the corresponding group rank number.

```lua
module.Admins = {
  ["10101101:>100"] = "Level"
}
```

Commander accepts a specific format for group ranks, which is `GroupId:GroupRank`, this will assign a specific group rank to be authorized to use Commander. However, if you want to setup multiple ranks, you might want to consider using `GroupId:>GroupRank` or `GroupId:<GroupRank`, where the former one is for `greater than or equal to`, and the latter one is for `lesser than or equal to`. 