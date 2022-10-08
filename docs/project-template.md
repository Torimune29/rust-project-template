# Project Template Information

## Directory Hierarcy

* Base: [Folder-Structure-Conventions](https://github.com/kriasoft/Folder-Structure-Conventions)
* Select:
    * docs (not doc)
    * tests (not test)

## Config

* [direnv](https://github.com/direnv/direnv): setting environment variables
    * Set environment variables into [.envrc](../.envrc)
        * For example, navi cheatsheat path, Git local config, etc
    * Execute `direnv allow` on bash to allow .envrc
* [navi](https://github.com/denisidoro/navi): cheating commands
    * Set Project-specified cheatsheet into [cheats directory](../tools/cheats/)
    * Execute `navi` with `NAVI_PATH=(project-root)/tools/cheats` to load above
        * Recommend: set environment on [.envrc](../.envrc)
* [editorconfig](https://editorconfig.org/): maintaining coding style
    * Set Project-specified style into [.editorconfig](../.editorconfig)
    * Add editorconfig extension in editor
* [Codacy](https://www.codacy.com/)
    * Set Project-specified directory into [./codacy.yml](../.codacy.yml)
    * Add repository in Codacy

## Author

[Torimune29](https://github.com/Torimune29)
