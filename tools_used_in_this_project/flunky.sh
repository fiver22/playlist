#!/bin/bash

# flunky made this for me; it pulls info from libre.fm; it needs jq, and curl, and a shell, and uh... a computer
user="";
limit_tracks="";
# Grab the JSON from the API with curl, and assign it to the variable "json"

json=$(curl -s https://libre.fm/2.0/?method=user.getrecenttracks\&user=$user\&page=1\&limit=$limit_tracks\&format\=json);

# Pipe the value of "json" into jq to get the relevant parts of the JSON, and assign that to the variable "recent_tracks"
# The '-c' flag of jq tells it to output each JSON object on a different line

recent_tracks=$(echo $json | jq -c '.recenttracks.track[]');

# Read through each line of "recent_tracks", and pipe that data into jq again
# This time it uses string interpolation to pull out the relevant parts you want,
# and it ouputs them as part of a "template":
# "Artist: <artist goes here>, Track: <title goes here>, Album: <album name goes here>"

echo $recent_tracks | while read line;
  do echo "$line" | jq -r '"Artist: \(.artist."#text"), Track: \( .name), Album: \(.album."#text")"';
done;

