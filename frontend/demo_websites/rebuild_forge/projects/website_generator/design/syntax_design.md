@@work_title="Projects Website Generator Syntax Design"
# Extended Markdown Syntax

## Purpose
---
To extend Markdown to be parsed into powerful components with which to generate a full website thereby requiring little more than well organized writing to build one.

## Key
---
- **Italic** = \*text\*
- **Bold** = \*\*text\*\*
- **BoldItalic** = \*\*_word_\*\*
- **Headers** = #-###### for H1-H6
- **Plain** = nothing
- **ConfigVariable** = @@cofig_var=data (data can be any type)
  - **NOTE:** Every md file should, for filekeeping, have a work_title ConfigVariable for NexusPointer sanity: 
    - @@work_title="Lorem Ipsum"
    - Improve later to use NexusKey to rename NexusPointers with versioning?
- **SetVariable** = @$var_name="data"
- **UseVariable** = @$var_name$@ (can be used as anywhere as String like config_var in ConfigVariable and link_pointer in NexusPointer)
- **NexusPointer** = \$\{"String for link"link_type:link_pointer\}\$
  - **String for link** = The text displayed for link, duh
  - **link_type** = enum { work, link }
    - **work** = Uses work_name (variable set in md file)
    - **link** = Goes to external url: "https://www..."
  - **link_pointer** = String used to specify target
- **ForceToText** = \\ (negative-line forces next character to be text, and itself is edited out, so if a potentially restricted character needs to be displayed as text, this goes first)


## Data Structures
---

#### NexusPointer
**Abstract**
Holds data for a link either hard-coded to another site or encoded with a work_title to go to another page.

**Design**
struct NexusPointer {
  text: String,
  type: LinkType,
  pointer: String,
}
enum LinkType {
  Work,
  Link,
}

#### NexusKey
**Abstract** 
It takes in the descriptive data from the NexusPointers and returns a hard link.

**Design** 
* Each file has it's relevant data collected during parsing - including: work_title, file location, and any NexusPointers it has.
* Once all files are processed into JSON, the NexusKey begins editing.
* It builds out Map, "work_title_to_location_map"
  - {String work_title: Path current_build_file_location, ...}
* It then goes through every file's NexusPointers and replaces them with a hard link
  - Generate this a &$&$"Link text"{url}
* Rather than crashing, it will collect all broken links and their locations to crash afterward and return the list of broken links
  - This way fixing errors won't be like whack-a-mole
