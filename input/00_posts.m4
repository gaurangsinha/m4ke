define(__timestamp, esyscmd(date -I))dnl
define(__title, `Posts')dnl
define(__subtitle, `List of posts')dnl
define(__id, `00_posts')dnl
include(./__header__.tmpl)
<br/>
include(./tmp_index_items)

include(./__footer__.tmpl)
