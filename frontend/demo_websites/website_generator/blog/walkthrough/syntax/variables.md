@@work_title="Walkthrough Syntax Variables"
# Syntax for Modified Markdown Variables

## Syntax for variables.
- **ConfigVariable** = @@cofig_var=data (data can be any type)
  - **NOTE:** Every md file should, for filekeeping, have a work_title ConfigVariable for NexusPointer sanity: 
    - @@work_title="Lorem Ipsum"
    - Improve later to use NexusKey to rename NexusPointers with versioning?
- **SetVariable** = @$var_name="data"
- **UseVariable** = @$var_name$@ (can be used as anywhere as String like config_var in ConfigVariable and link_pointer in NexusPointer)
