@@work_title="Walkthrough Website Overview"
# How To Set Up Your Website 

Go here if you are looking for the syntax to ${"edit the content"work_title:Walkthrough Syntax Overview}$ in the files.

## Format Basics
The navigation tree is a direct reflection of the root directory.

All directories must have two files:
- *overview.md*
  This will act as the home screen for the directory it is found in.
  For instance, the overview.md found in the root of a website directory is the main home screen, but a child directory of that - let's call it, "blog" - will display the data in root/blog/overview.md when the navigation goes to root/blog.
- *config.json*
  This will hold data for streamlined components - currently just the navbar
  
  Currently, there needs to be a config.json in every directory, but the data in it is not used. All the data in the root/config.json is passed down to children, and a future implementation will have the config.json of children just do updates by using basic json overwriting mechanics where all things that aren't overwritten or removed (create "remove" call) are left the same and things can be added as well.
