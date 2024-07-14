#!/bin/bash

# Directory containing .ogg files (change this to your desired directory)
input_dir="assets"

# Find all .ogg files recursively and convert to .mp3
find "$input_dir" -type f -name "*.ogg" | while IFS= read -r file; do
    if [ -f "$file" ]; then
        output_file="${file%.ogg}.mp3"

        echo "Converting $file to $output_file"
        ffmpeg -i "$file" "$output_file" -hide_banner -loglevel error -y < /dev/null
    fi
done

echo "Conversion complete!"