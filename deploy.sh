#!/bin/bash
set -x

# set variables
# change if the project directory is located somewhere other than home
directory_location_1="home"
# change user_name to your own raspberry pi username
user_name="oystrost"
# change if the project directory is located somewhere other than the desktop
directory_location_2="Desktop"
other_folder="/${directory_location_1}/${user_name}/${directory_location_2}/web-fundamentals-exam/other"
page_url="https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway"
page_file="${other_folder}/original.page.html.txt"
page_file_one_line="${other_folder}/page.html.one.line.txt"
page_file_table_newline="${other_folder}/page.html.table.newline.txt"
table_only=$other_folder/table.only.txt
final_page="index.html"

# Create folder for files generated by script
mkdir -p "$other_folder"

# Save the municipalities page to txt file
curl -s "$page_url" > "$page_file"

# Remove whitespace characters and tabs
# cat reads the data from the page_file variable and outputs the content, tr -d deletes newline and tabs
cat "$page_file" | tr -d '\n\t' > "$page_file_one_line"
# insert newline before opening table tag and after closing table tag for table element with the $table_class
# sed searches for the closing table tag and inserts newline, s is the substitue command, g is the global command
sed 's|<table class="sortable wikitable">|\n<table class="sortable wikitable">|g' "$page_file_one_line" | sed 's|</table>|</table>\n|g' > "$page_file_table_newline"

# take only the third line, the table containing the municipalities list
sed -n '3p' "$page_file_table_newline" > "$table_only"

# create template for the html, insert extracted table as body content
page_content='
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Municipalities of Norway</title>
</head>
<style>
    body {
        background-color: #f6f1f4;
        font-family: Tahoma, Geneva, Verdana, sans-serif;
        text-align: center;
    }
    a {
        color: #be0000;
    }
    a:hover {
        color: #810000;
    }
    #name {
        font-style: italic;
    }
    #portrait {
        border-radius: 100%;
        max-width: 150px;
        max-height: 150px;
    }
    div {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        align-items: center;
        margin-bottom: 30px;
        margin-top: 20px;
    }
    th, td {
        padding: 10px 15px 10px 15px;
    }
</style>
<body>
    <div>
        <h1 id="name">By Øystein Røstvik</h1>
        <img id="portrait" src="https://avatars.githubusercontent.com/u/91118560?v=4" alt="Øystein Røstvik">
    </div>
    '"$(cat "$table_only")"'
</body>
</html>
'

# dump page content into index file
echo "$page_content" > "$final_page"

$SHELL