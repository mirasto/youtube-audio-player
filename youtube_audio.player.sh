#!/bin/bash

declare -A CHANNELS=(
    ["chilli music"]="https://www.youtube.com/@chillimusicrecords/videos"
    ["Lofi Coffee"]="https://www.youtube.com/@lofi_cafe_s2/videos"
    ["Lost Sounds"]="https://www.youtube.com/@LSTSOUNDS/videos"
    ["Asthenic (Synthwave )"]="https://www.youtube.com/@Asthenic/videos"
    ["HALIDONMUSIC (classic music)"]="https://www.youtube.com/@HALIDONMUSIC/videos"
    ["Essential Classics"]="https://www.youtube.com/@EssentialClassics/videos"
    ["Piano Deus"]="https://www.youtube.com/@PianoDeuss/videos"
)

echo "📺 Select a channel:"
channel_name=$(printf "%s\n" "${!CHANNELS[@]}" | fzf --prompt="Channel: ")
[[ -z "$channel_name" ]] && echo "❌ Cancelled." && exit 1

channel_url="${CHANNELS[$channel_name]}"

echo "📥 Fetching video list from '$channel_name'..."
video_data=$(yt-dlp --flat-playlist -J "$channel_url" 2>/dev/null)
video_ids=$(echo "$video_data" | jq -r '.entries[].id')
video_titles=$(echo "$video_data" | jq -r '.entries[].title')

if [[ -z "$video_ids" ]]; then
    echo "❌ Failed to retrieve videos."
    exit 1
fi

# Limit to last 10 videos
mapfile -t ids < <(echo "$video_ids")
mapfile -t titles < <(echo "$video_titles")

if (( ${#ids[@]} > 10 )); then
    start=$(( ${#ids[@]} - 10 ))
    ids=( "${ids[@]:start:10}" )
    titles=( "${titles[@]:start:10}" )
fi

echo -n "🎲 Play a random video? [y/N]: "
read -r random_choice

if [[ "$random_choice" =~ ^[Yy]$ ]]; then
    mode="random"
else
    mode="sequential"
    echo "📃 Select a video:"
    selected_title=$(printf "%s\n" "${titles[@]}" | fzf --prompt="Video: ")
    [[ -z "$selected_title" ]] && echo "❌ Cancelled." && exit 1

    for i in "${!titles[@]}"; do
        [[ "${titles[$i]}" == "$selected_title" ]] && start_index=$i && break
    done
fi

echo "▶️ Starting playback..."

while true; do
    if [[ "$mode" == "random" ]]; then
        index=$((RANDOM % ${#ids[@]}))
    else
        index=$start_index
        ((start_index++))
        if [[ $index -ge ${#ids[@]} ]]; then
            echo "✅ End of the list reached."
            break
        fi
    fi

    video_url="https://www.youtube.com/watch?v=${ids[$index]}"
    echo "🎧 Now playing: ${titles[$index]}"
    mpv "$video_url" --no-video

    echo "⏭ Moving to the next video..."
    sleep 1
done
