#!/bin/bash
set -x

# set variables
# change user_name to your own raspberry pi username
user_name="oystrost"
page_url="https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway"
other_folder="/home/${user_name}/Desktop/exam-stuff/grade-d/other"
page_file="${other_folder}/original.page.html.txt"
page_file_one_line="${other_folder}/page.html.one.line.txt"
page_file_table_newline="${other_folder}/page.html.table.newline.txt"
table_only="${other_folder}/table.only.txt"
final_page="page.html"

# Create folder
mkdir -p "$other_folder"

# Download the webpage to the local machine
curl -s "$page_url" > "$page_file"

# Remove whitespace characters and tabs
cat "html.txt" | tr -d '\n\t' > "$page_file_one_line"
sed 's|<table class="sortable wikitable">|\n<table class="sortable wikitable">|'"$page_file_one_line" | 
    sed 's|</table>|</table>\n|g' > "$page_file_table_newline"

# only take the third line
sed -n '3p' "$page_file_table_newline" > "$table_only"

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
    '"$(cat "$table_only")"'
</body>
</html>
'

# dumping variable contents into a file
echo "$page_template" > "$final_page"

$SHELL