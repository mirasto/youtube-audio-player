# 🎵 YouTube Music Player Script

This Bash script allows you to browse and play the latest videos from selected YouTube music channels directly in your terminal, with interactive selection and playback.

## 📌 What the Script Does

- Displays a list of preconfigured music channels (e.g., lofi, classical).
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

### Install on Linux (Ubuntu / Arch)

```bash
# Ubuntu / Debian
sudo apt update
sudo apt install -y yt-dlp jq fzf mpv

# Arch / Manjaro
sudo pacman -S yt-dlp jq fzf mpv
