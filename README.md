# Scripts

I'm still learnin'

I neither accept responsibility nor choose to be accountable for the damage these scripts cause if you choose to
use them.

╮(╯_╰)╭

## Bookmarks

Simple bookmarking cli app that allows for navigating between mapped folders with
associated bookmark names.

It has a basic menu interface that let's you select a bookmark from
a bookmark file.

You can also temporarily bookmark a folder with `bookmarks -T`, navigate to another folder, then run
`bookmarks -D` to go back to that bookmark, then use `bookmarks -D` to go _back_
to the location you were at before jumping to the bookmarked location. Pretty
neat!

Run `bookmarks -h` for more info.

### Setup

Copy the script to a location within your $PATH (it defaults to $HOME/bin, since
that's my script directory).

Source the `bookmarks.sh` file in your shell profile or \_whatever_rc file.

> **IMPORTANT** It comes with several aliases, so make sure _there are no
> collisions_ **BEFORE** sourcing.

## Other Scripts

- `touch-nested` - got tired of using `mkdir ... && touch /../../../../file`, so
  this script handles creating any necessary parent folders
