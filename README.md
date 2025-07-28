# 🎵 YouTube Audio Player Script

This Bash script allows you to browse and play the latest audio from selected YouTube channels directly in your terminal, with interactive selection and playback.

## 📌 What the Script Does

- Displays a list of preconfigured channels (e.g., lofi, classical).
- Lets you choose a channel using `fzf` (fuzzy finder).
- Fetches the latest 10 videos from the selected channel using `yt-dlp`.
- Allows you to:
  - Play a random video
  - Or select a specific video manually
- Plays audio using `mpv` (video is disabled).
- In sequential mode, it automatically proceeds to the next track.

## 🛠️ Dependencies

Make sure the following tools are installed:

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) — to fetch video metadata
- [`jq`](https://stedolan.github.io/jq/) — to parse JSON
- [`fzf`](https://github.com/junegunn/fzf) — for interactive selection
- [`mpv`](https://mpv.io/) — to play audio from YouTube

### Install dependencies on Linux (Ubuntu / Arch)

```bash
# Ubuntu / Debian
sudo apt update
sudo apt install -y yt-dlp jq fzf mpv

# Arch / Manjaro
sudo pacman -S yt-dlp jq fzf mpv
```

---

## How to Add Your Own Channel

To add a custom YouTube channel:

1. Open the `youtube-music.sh` file.

2. Locate the `CHANNELS` associative array:

   ```bash
   declare -A CHANNELS=(
       ["Channel Name"]="https://www.youtube.com/@username/videos"
   )
   ```

3. Add a new entry in the same format:

   ```bash
   ["Ambient Chill"]="https://www.youtube.com/@AmbientChillChannel/videos"
   ```

4. Save the script and run it again.

> ⚠️ **Note:** Make sure the URL points to the `/videos` section of the channel. Otherwise, `yt-dlp` may not fetch the video list correctly.

## ⚠️ Notes

* The script plays only audio (`--no-video`) via `mpv`.
* If `fzf` or `yt-dlp` are missing, the script will not work.
* Developed for `bash`. Compatibility with other shells (e.g. `zsh`) is not guaranteed without modification.
