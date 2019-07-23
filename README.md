## RELATIONAL SCHEMA

https://docs.google.com/document/d/12Qh9CRBV76QHS8DFw5QmwEp3t0LESOJTBiWDaPonKmY/edit

This document contains the relational schema _and_ the structure of all of the tables used in our database. 
Refer to this when building UI elements of the application, and when generating your SQL query statemtns. 

## Naming Conventions

This is by no means a rule, but since our application will have dozens of UI elements in Visual Studio, it might be helpful if we're all using simialr conventions for naming them, so we know what elements we are looking at in code when we start to review/edit each others' work.

A few guidelines that may be helpful: 
- snake_case appears to be the most common type for object naming, so try to stick with it where possible
- input fields, such as text boxes or drop-down menus, are often named after what attribute they are expected to take
    - for instance, the drop-down menu for the customer's street address type is *street_type*
- the UI labels that accompany these fields are usually identically named, but with *_label* appended to the end
    - in the previous example, you would see *"street_type_label"*
- When typing out SQL attributes, camelCase is prevalent
    - *streetType, customerID*, etc.

this is by no means an exhaustive list so add things here if you run into anything else you think will be helpful.

## Please View User Guide
