# m4ke
Static site generators have become complex requiring effort to learn and customize, m4ke is an extremely simple static site generator which only leverages easily accessible tools like `make` and `m4`.   

m4ke leverages [m4 macro processor](https://en.wikipedia.org/wiki/M4_(computer_language)) as its text processor and [make](https://en.wikipedia.org/wiki/Make_(software)) as its builder.

```
                       ┌────────────┐
┌──────────┐  ┌────┐  ┌┴───────────┐│
│          │  │    │  │            ││
│ Makefile ├─►│ m4 ├─►│Posts (html)││
│          │  │    │  │            ├┘
└──────────┘  └─▲──┘  └────────────┘
                │
        ┌───────┴──┐
       ┌┤Posts (m4)│
       │└─────────┬┘
       └──────────┘          
```

### Usage
```
$ make clean
$ make all
```
`make` will process all `.m4` files present in the [`INPUT_FOLDER`](https://github.com/gaurangsinha/m4ke/blob/main/Makefile#L5).

### Folder structure
```
| - Makefile
| - input/
  | - 00_about.m4
  | - 00_contact.m4
  | - 00_posts.m4
  | - 2023-09-02_hello_world.m4
  | - 2023-09-03_hello_again.m4
  | - __header__.tmpl
  | - __footer__.tmpl
  | - style.css
```
- Files starting with `NN` are pages (e.g. `00_about.m4`)
- Files starting with a `YYYY-MM-DD` are post (e.g. `2023-09-02_hello_world.m4`)
- `00_posts.m4` is a special page which the `Makefile` populates with the index of all the posts. This index will not contain static pages i.e. the ones starting with `NN`.
- Other static files like `style.css` need to copied into the destination folder by specifying them in the [`static`](https://github.com/gaurangsinha/m4ke/blob/main/Makefile#L32) section of the Makefile.
- Files with `tmpl` extensions are template files (e.g. `__header__.tmpl`), these are used by other pages and posts during their processing. 

### Post & page structure
Post filename must be for the following format `YYYY-MM-DD_title_of_post.m4`.

Other static pages on the site can have the following format `00_page_name.m4`.

Basic structure of a post: defines a few macros (timestamp, title, etc), includes header and footer templates.
```
define(__timestamp, `Sat, 2 Sep 2023 12:17:43')dnl
define(__title, `Hello, world')dnl
define(__subtitle, `Hello, world - first post using m4ke')dnl
define(__id, `2023-09-02_hello_world')dnl
include(./__header__.tmpl)

This is the first post make using <a href="https://github.com/gaurangsinha/m4ke">m4ke</a>.

You can use html, css & javascript to create, style and format your post.

I'd recommend sticking to a minimal set of html and css for your posts.

Happy posting!

include(./__footer__.tmpl)
```

### Templates | Headers & Footers
Header
```
<!DOCTYPE html>
<html>
<head>
  <title>__title</title>
</head>
<body>
    <h1>__title</h1>
    __timestamp
```

Footer
```
<p>$copy; All rights reserved</p>
</body>
</html>
```
