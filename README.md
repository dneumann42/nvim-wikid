# A wickedly cool wiki manager

## Requirements

[neovim >= 0.9.0](https://github.com/neovim/neovim/wiki/)

## Installation and configuration

Install using your preferred package manager

`"dneumann42/nvim-wikid"`

Depends on `nvim-lua/plenary.nvim`

## Usage

You can select a wikid command to run using `:WikidCommands`

### Configuration

```lua
-- defaults
require("wikid").setup {
  wiki_dir = "~/.wiki",
  daily_date_format = "%m-%d-%Y",
  daily_subdir = "daily",
  templates_subdir = "templates",
}
```

### Daily Notes

Open daily note by running the WikidDaily command

```lua
:WikidDaily
```

### Note and note templates

Can create and edit templates that you can use when creating a new note.

```lua
:WikidNewTemplate
:WikidEditTemplate
```

Can create note note using a template

```lua
:WikidNewNoteFromTemplate
```

## Planned Features

+ [ ] [2/4] Daily Notes
  - [X] Create and Edit daily notes
  - [X] Note templates
  - [X] Configure daily note directory
  - [X] Configure daily note date format
  - [ ] Daily note templates

+ [ ] [1/7] Notes
  - [X] [3/3] Templates
    + [X] New templates
    + [X] Edit templates
    + [X] Create note from template
  - [X] Create blank note
  - [ ] Quick open note
  - [ ] Move note to directory
  - [ ] Update note links
  - [ ] Validate note links
  - [ ] [0/3] Tasks
    + [ ] Nested tasks
    + [ ] Task state toggling
    + [ ] Task states configuration

+ [X] [1/1] Discoverablity and Documentation
  - [X] Select a command from a menu
