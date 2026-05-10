@@work_title="Walkthrough Syntax Linking"
# Syntax for Modified Markdown Linking

## Syntax for linking
- **NexusPointer** = \$\{"String for link"link_type:link_pointer\}\$
  - **String for link** = The text displayed for link, duh
  - **link_type** = enum { work_title, link }
    - **work_title** = Uses work_name (variable set in md file)
    - **link** = Goes to external url: "https://www..."
  - **link_pointer** = String used to specify target
    - Can be a url (used with "link")
    - Can link to a file via setting work_title as a ${"config variable"work_title:Walkthrough Syntax Variables}$ (used with "work_title")
