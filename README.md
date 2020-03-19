Spider
======

[![](https://github.com/AjxLab/Emoji_Extractor/workflows/build/badge.svg)](https://github.com/AjxLab/Emoji_Extractor/actions)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

Spider of this [emoji list](https://www.webfx.com/tools/emoji-cheat-sheet/).


## Requirements
* macOS
* Ruby 2.7
* SQLite3


## Usage
### Start Crawling
```sh
$ bundle exec ruby spider.rb
```
### Setup Gmail
```sh
$ bundle exec rake setup:gmail
Gmail Address：your.address@gmail.com     # Enter your gmail address
Application Password：**********  # Enter your application password
```
### Setup LINE
```sh
$ bundle exec rake setup:line
TOKEN：your line notify token
```
### Database
#### Migratiton
1. Write DB settings in [config/db.yml](config/db.yml)
* file -> sqlite3 file path (required)
* name -> column name (not required)
* type -> column type (required)
* opts -> column opts (not required)
```yml
file:
  'your db file'
tables:
  - <table name>:
    - name: <column name>
      type: <column type>
      opts:
        - <column opts>
        - 'unique: true'
        - 'null: false'
    - name: ...
      type: ...
  - <table name>:
    ...
```
2. Execute migration
```sh
$ bundle exec rake db:migrate
```
#### Clear DB
```sh
$ bundle exec rake db:clear
```
#### Clear Table
```sh
$ bundle exec rake db:clear_<tablename>
```
### Clear Log
```sh
$ bundle exec rake log:clear
```

## Installation
1. Clone this repo
```sh
$ git clone <this repo>
$ cd <this repo>
```
2. Build gems
```sh
$ bundle install
```


## Author
* Tatsuya Abe
* abe12@mccc.jp
