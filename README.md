# m4ke
With static site generators getting complex, m4ke is an extremely simple generator using easily accessible tools like `make` and `m4`.   

### Usage
```
$ make clean
$ make
```
`make` will process all `.m4` files present in the [`INPUT_FOLDER`](https://github.com/gaurangsinha/m4ke/blob/main/Makefile#L3).

### Folder structure
```
| - Makefile
| - posts/
  | - __header__.tmpl
  | - __footer__.tmpl
  | - 00_about.m4
  | - 2023-07-30_bootstrapping.m4
  | - style.css
| - out/
  | - 00_about.html
  | - 2023-07-30_bootstrapping.html
  | - style.css
```


### Post structure
Post filename must be for the following format `YYYY-MM-DD_title_of_post.m4`.

Other static pages on the site can have the following format `00_page_name.m4`.

Basic structure of a post: defines a few macros (timestamp, title, etc), includes header and footer templates.
```
define(__timestamp, `Sun, 30 Jul 2023 15:54:18 -0700')dnl
define(__title, `bootstrapping')dnl
define(__description, `building a static site generator')dnl
define(__id, `2023-07-30_bootstrapping')dnl
include(./__header__.tmpl)

post content goes here.
this can be html
<a href="#">links</a>

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
