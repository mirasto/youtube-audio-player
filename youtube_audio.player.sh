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


echo "📺 Выберите канал:"
channel_name=$(printf "%s\n" "${!CHANNELS[@]}" | fzf --prompt="Канал: ")
[[ -z "$channel_name" ]] && echo "❌ Отменено." && exit 1

channel_url="${CHANNELS[$channel_name]}"

echo "📥 Загружается список видео с '$channel_name'..."
video_data=$(yt-dlp --flat-playlist -J "$channel_url" 2>/dev/null)
video_ids=$(echo "$video_data" | jq -r '.entries[].id')
video_titles=$(echo "$video_data" | jq -r '.entries[].title')

if [[ -z "$video_ids" ]]; then
    echo "❌ Видео не получены."
    exit 1
fi

# Ограничиваем до последних 10 видео
mapfile -t ids < <(echo "$video_ids")
mapfile -t titles < <(echo "$video_titles")

if (( ${#ids[@]} > 10 )); then
    start=$(( ${#ids[@]} - 10 ))
    ids=( "${ids[@]:start:10}" )
    titles=( "${titles[@]:start:10}" )
fi

echo -n "🎲 Выбрать случайное видео? [y/N]: "
read -r random_choice

if [[ "$random_choice" =~ ^[Yy]$ ]]; then
    mode="random"
else
    mode="sequential"
    echo "📃 Выберите видео:"
    selected_title=$(printf "%s\n" "${titles[@]}" | fzf --prompt="Видео: ")
    [[ -z "$selected_title" ]] && echo "❌ Отменено." && exit 1

    for i in "${!titles[@]}"; do
        [[ "${titles[$i]}" == "$selected_title" ]] && start_index=$i && break
    done
fi

echo "▶️ Начинаем воспроизведение..."

while true; do
    if [[ "$mode" == "random" ]]; then
        index=$((RANDOM % ${#ids[@]}))
    else
        index=$start_index
        ((start_index++))
        if [[ $index -ge ${#ids[@]} ]]; then
            echo "✅ Достигнут конец списка."
            break
        fi
    fi

    video_url="https://www.youtube.com/watch?v=${ids[$index]}"
    echo "🎧 Играет: ${titles[$index]}"
    mpv "$video_url" --no-video

    echo "⏭ Переход к следующему видео..."
    sleep 1
done
