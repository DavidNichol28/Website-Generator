@@work_title="Projects Website Generator Dynamic Page Config"
# Dynamic Page Config

## Purpose
---
To have an inheritence-based config for the website that affects general aspects like the navbar or styling.

## Data Structures
---
TreeLocationAttributeManager {
	**location**: Path // Where it is starting with '/' for root
	**nav**: NavbarData // Passed down, and updated at each level of the tree
	**style**: StylingData // Acts like NavbarData
}

## Algorithms
---
1. config.json files will be written in the md directories before processing.
2. When md is processed, the files are strictly copied over (if present (only root config.json is required))
3. When processed_data is loaded in Flutter program, the tree will be traveled creating an inheritence based TreeLocationAttributeManager at each node (dir and file locations)
4. Modifications to the inherited data are done differently depending on if its a:
  **directory:**
	  This will have a config.json if there are modifications to be made.
  **file:**
      MarkdownPage will have an attribute, "treeLocationAttributeManagerModifications" parsed from the md files which may or may not have values therein corresponding to the attributes in TreeLocationAttributeManager to modify.
5. Each page being built out statically as the end goal, a full-on page for each node will be rendered, and in its generation, it'll pull from TreeLocationAttributeManager for all of its dynamic inputs to be fed into a layout Widget.
