# Cataloger

This is a simple experiment to learn a bit of
[Elixir](http://elixir-lang.org) and the
[Phoenix framework](http://www.phoenixframework.org).

The idea is to create a simple application to maintain a "catalog" of
items, divided in sections. Each item and section then has a cover
image and a title, and items also have description and tags.

This application exports the result of the catalog to a directory
containing a JSON file (describing the whole structure) and all the
images, including thumbnails in the specified sizes.

Then, a front-end application can be written that reads the JSON file
and shows the catalog without the need for a back-end. This second
application is supposed to be custom, although I will soon write a
reference example.

## Running

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Install Node.js dependencies with `npm install`
* Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## TODO

* Copy the original cover image as part of the export
* Specify the thumbnail sizes, both generally and for each image
* Delete the export directory before starting
