#!/bin/bash
set -x

# Download the webpage to the local machine
curl -s "https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway" > "page.html.txt"

# Remove whitespace characters and tabs
cat "html.txt" | tr -d '\n\t' > "page.html.one.line.txt"
sed 's|<table class="sortable wikitable">|\n<table class="sortable wikitable">|'"page.html.one.line.txt" | 
    sed 's|</table>|</table>\n|g' > "page.html.table.newline.txt"

# only take the third line
sed -n '3p' "page.html.table.newline.txt" > "table.only.txt"

# string literal - our future page -- inserting extracted table as body content
page_template='
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>sfgsfsfdsfd</title>
</head>
<body>
    '"$(cat "table.only.txt")"'
</body>
</html>
'

# dumping variable contents into a file
echo "$page_template" > "our.page.html"

$SHELL