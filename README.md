# Moontex
1. [Overview/features](#overview)
2. [Usage](#usage)
    1. [Installation](#installation)
    2. [Config](#config)
    3. [Workspace folder](#workspace)
3. [Non-fetures](#non-features)

<a name="overview"></a>
## Overview/features 
Moontex is a Neovim plugin that provides basic features to work with LaTex files. *This is a personal project and does **NOT** aim to be a complete and feature-rich plugin. You should use this only if you need a basic latex plugin that integrates with other lua plugins (TreeSitter, LSP, LuaSnips). Most users should definetely opt for [Vimtex](https://github.com/lervag/vimtex) instead*

## Features
Moontex provides basic features such as
1. Continuous compilation using [latexmk](https://ctan.org/pkg/latexmk/?lang=en)
2. Forward/inverse search with [skim](https://skim-app.sourceforge.io)
3. Treesitter based conceal and hilighting
4. Support for multi-file projects
5. Treesitter based context detection (for context specific snippets with LuaSnips or UltiSnips)

<a name="usage"></a>
## Usage 
<a name="installation"></a>
### Installation 
In order for compilation to work, latexmk should be installed. It very likely comes by default with your latex distribution. Check if it's installed by running:
```
latexmk -version
```
Install with any plugin manager, e.g. Packer:
```lua 
use 'mattia-marini/MoonTex'
```
Note that the context detection and conceal features relie on Treesitter, hence you should install it togheter with a latex parser

<a name="config"></a>
### Config 
Not much to do here. Configure like any other plugin. Below are listed the default settings:
```lua 
require("MoonTex").config({
  workspace_folder_name = "latex_workspace",
  mainfile_name = "main.tex",
  max_search_depth = 5,
  server_name = "tex_server"
})
```

* ```workspace_folder_name```: when trying to detect the main file, moontex searches in the partent folders of the current buffer. When a folder matches this name though, it stops.
* ```mainfile_name```: simplest way to efficiently detect the main file is to explicitly set its name. Other ways of detecting the mainfile will be implemented in the near future
* ```max_search_depth```: the max number of recursions to do in order to set the main file path.
* ```server_name```: the name of moontex's socket. The socket is created in the same directory as the main file

#### Inverse serach cofiguration
By far, document syncing is supported only on Skim. Forward search should work out of the box, whereas you should setup skim in order for backward search to work properly.
1. Open a .tex file with moontex installed and run ```MTPrintSkimCommand```
2. Open ```skim -> Preferences -> Sync``` and paste the otput of the previous command in the corresponding sections. Your command should look something like this:
```bash
command: nvim
args: --headless --noplugin -u /Users/<your-name>/.local/share/nvim/site/pack/packer/start/MoonTex/lua/MoonTex/search.lua -c "InverseSearch \"%file\" %line"
```

<a name="workspace"></a>
### Optimal workspace folder
In order for moontex to work properly, your workspace folder should look something like this:
```
latex_workspace
├── project1
│  ├── images
│  │  ├── image1.jpg
│  │  └── image2.pdf
│  ├── main.tex
│  └── sections
│     ├── sec1.tex
│     └── sec2.tex
└── project2
   ├── images
   │  ├── image1.jpg
   │  └── image2.pdf
   ├── main.tex
   └── sections
      ├── sec1.tex
      └── sec2.tex
```


<a name="non-features"></a>
## Non-features
* Navigation (Table of Contents/labels)
* Forward/inverse search in pdf viewers other that skim
* Support for fallback main-file detection methods
