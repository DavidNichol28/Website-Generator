@@work_title="Projects Website Generator General Architecture"
# Designing a Website Generator

## Purpose
---
Take in standardized data, and output a static website that streamlines the process while still allowing for sensible customizability.

## MVP Vision
---
* To process the JSON data output from md_parser into a fully functional, respectable website.

* To develop a platform that can be expanded to allow more customization and capabilities modularly.

## MVP Specs
---
* Builds website based off the data in the assets directory (put there by md_parser) 
  - Lines are represented according to the attributes in their data structure
  - Navigation is auto-generated and follows the tree of the directory in the assets directory
    - Uses the Map keys as slugs
    - Handles directories and files differently
	  - Files get webpages presenting file data
	  - Directories get webpages presenting children
    - Config files are not made into webpages, but can affect them
  - Code gen stuff is used to turn this purely static thereby removing the process of processing anything and leaving the website only with the widgets that have all the processed data hard-coded into it.
* Config files are used to provide scope variables
  - These will be named config.json
    - Must exist at top level as root_config.json
      - Auto-gen if not there
  - Lower scope configs override higher scoped config variables
    - Individual markdown files can override variables with file-level variable mutation
      - Top-level JSON attribute in file => "config_overrides": {...}
  - Whatever the variable is set to be at the given node (whether directory or markdown file), it is processed into that webpage.
    - Can be navbar, background, etc 
* Create a modular styling system for MD webpages
* Create and package a modular navbar for MD website navigation

## Deliverables:
---
* CLI tool that turns directory of markdown into a website
  - Use md_parser to parser target directory into website generator's assets
  - 1st input required: root of target directory
  - 2nd input optional: location of website output
  - Options:
	- Launch on finish (default true)
	- Style (edit all MD elements, background, etc)
	- Navbar location
		- Top (default)
		- Side
		- Bottom
		- None
* Simple walkthroughs
  * Config extensibility
  * Modifying styles
