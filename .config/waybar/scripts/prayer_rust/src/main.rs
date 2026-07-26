use chrono::{Local, NaiveTime};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::PathBuf;
use std::process::Command;
use std::thread::sleep;
use std::time::Duration;

const API_URL: &str = "http://api.aladhan.com/v1/timingsByCity?city=Giza&country=Egypt&method=5";

#[derive(Serialize, Deserialize, Clone)]
struct PrayerState {
    date: String,
    #[serde(default)]
    done: Vec<String>,
    #[serde(default)]
    show_media: bool,
    #[serde(default)]
    end_dots: bool,
}

impl Default for PrayerState {
    fn default() -> Self {
        Self {
            date: get_today_str(),
            done: vec![],
            show_media: false,
            end_dots: false,
        }
    }
}

#[derive(Serialize, Deserialize)]
struct TimesCache {
    date: String,
    times: HashMap<String, String>,
}

#[derive(Serialize)]
struct WaybarOutput {
    text: String,
    tooltip: String,
    class: Vec<String>,
}

fn escape_pango(text: &str) -> String {
    text.replace('&', "&amp;")
        .replace('<', "&lt;")
        .replace('>', "&gt;")
        .replace('"', "&quot;")
        .replace('\'', "&#39;")
}

fn get_cache_paths() -> (PathBuf, PathBuf) {
    let home = env::var("HOME").unwrap_or_default();
    let times = PathBuf::from(format!("{}/.cache/waybar_prayer_times.json", home));
    let state = PathBuf::from(format!("{}/.cache/waybar_prayer_state.json", home));
    (times, state)
}

fn get_today_str() -> String {
    Local::now().format("%d-%m-%Y").to_string()
}

fn fetch_timings() -> Option<HashMap<String, String>> {
    let date_str = get_today_str();
    let (times_path, _) = get_cache_paths();

    if let Ok(data) = fs::read_to_string(&times_path) {
        if let Ok(cache) = serde_json::from_str::<TimesCache>(&data) {
            if cache.date == date_str {
                return Some(cache.times);
            }
        }
    }

    let resp = match ureq::get(API_URL).timeout(Duration::from_secs(5)).call() {
        Ok(r) => r,
        Err(_) => return None,
    };

    let json: serde_json::Value = match resp.into_json() {
        Ok(j) => j,
        Err(_) => return None,
    };

    let timings = json.get("data")?.get("timings")?.as_object()?;

    let mut filtered = HashMap::new();
    let allowed = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

    for p in allowed {
        if let Some(val) = timings.get(p) {
            if let Some(s) = val.as_str() {
                filtered.insert(p.to_string(), s.to_string());
            }
        }
    }

    let cache = TimesCache {
        date: date_str,
        times: filtered.clone(),
    };
    if let Ok(s) = serde_json::to_string(&cache) {
        let _ = fs::write(times_path, s);
    }

    Some(filtered)
}

fn get_state() -> PrayerState {
    let date_str = get_today_str();
    let (_, state_path) = get_cache_paths();

    if let Ok(data) = fs::read_to_string(&state_path) {
        if let Ok(state) = serde_json::from_str::<PrayerState>(&data) {
            if state.date == date_str {
                return state;
            }
        }
    }
    PrayerState::default()
}

fn save_state(state: &PrayerState) {
    let (_, state_path) = get_cache_paths();
    if let Ok(s) = serde_json::to_string(state) {
        let _ = fs::write(state_path, s);
    }
}

fn exec_direct(program: &str, args: &[&str]) -> String {
    if let Ok(output) = Command::new(program).args(args).output() {
        String::from_utf8_lossy(&output.stdout).trim().to_string()
    } else {
        String::new()
    }
}

fn get_mpris() -> (String, String, String) {
    let raw = exec_direct(
        "playerctl",
        &[
            "-a",
            "metadata",
            "--format",
            "{{status}}:::{{artist}}:::{{title}}:::{{playerName}}",
        ],
    );

    if raw.is_empty() {
        return (String::new(), String::new(), String::new());
    }

    let mut playing = None;
    let mut paused = None;

    for line in raw.lines() {
        let parts: Vec<&str> = line.split(":::").collect();
        if parts.len() >= 4 {
            let status = parts[0].trim().to_lowercase();
            let artist = parts[1].trim();
            let title = parts[2].trim();
            let player_name = parts[3].trim();

            if status == "playing" {
                playing = Some((
                    status,
                    artist.to_string(),
                    title.to_string(),
                    player_name.to_string(),
                ));
                break;
            } else if status == "paused" && paused.is_none() {
                paused = Some((
                    status,
                    artist.to_string(),
                    title.to_string(),
                    player_name.to_string(),
                ));
            }
        }
    }

    let chosen = playing.or(paused);

    if let Some((status, artist, title, player_name)) = chosen {
        let mut text = if !artist.is_empty() && !title.is_empty() {
            format!("{} - {}", artist, title)
        } else if !title.is_empty() {
            title.clone()
        } else if !artist.is_empty() {
            artist.clone()
        } else if !player_name.is_empty() {
            player_name
        } else {
            "Media Playing".to_string()
        };

        let chars: Vec<char> = text.chars().collect();
        if chars.len() > 32 {
            text = chars[..29].iter().collect::<String>() + "...";
        }

        let display_title = if !title.is_empty() { &title } else { "Unknown Title" };
        let display_artist = if !artist.is_empty() { &artist } else { "Unknown Artist" };
        let tooltip = format!("{}\n{}", display_title, display_artist);

        (status, escape_pango(&text), escape_pango(&tooltip))
    } else {
        (String::new(), String::new(), String::new())
    }
}

#[derive(Clone)]
struct PrayerTime {
    name: String,
    time: chrono::DateTime<Local>,
}

fn get_current_next(timings: &HashMap<String, String>) -> (PrayerTime, PrayerTime) {
    let now = Local::now();
    let mut prayers = Vec::new();
    let order = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

    for name in order {
        if let Some(t_str) = timings.get(name) {
            if let Ok(t) = NaiveTime::parse_from_str(t_str, "%H:%M") {
                if let Some(dt) = now
                    .date_naive()
                    .and_time(t)
                    .and_local_timezone(Local)
                    .single()
                {
                    prayers.push(PrayerTime {
                        name: name.to_string(),
                        time: dt,
                    });
                }
            }
        }
    }

    prayers.sort_by_key(|p| p.time);

    if prayers.is_empty() {
        let fallback = PrayerTime { name: "N/A".to_string(), time: now };
        return (fallback.clone(), fallback);
    }

    let mut current = prayers.last().unwrap().clone();
    current.time -= chrono::Duration::days(1);
    let mut next = prayers.first().unwrap().clone();

    for i in 0..prayers.len() {
        if now >= prayers[i].time {
            current = prayers[i].clone();
            if i + 1 < prayers.len() {
                next = prayers[i + 1].clone();
            } else {
                next = prayers[0].clone();
                next.time += chrono::Duration::days(1);
            }
        }
    }
    (current, next)
}

fn main() {
    unsafe {
        env::set_var("TZ", "Africa/Cairo");
    }

    let args: Vec<String> = env::args().collect();
    let action = if args.len() > 1 {
        args[1].clone()
    } else {
        String::new()
    };

    if !action.is_empty() {
        let mut state = get_state();
        if action == "primary" {
            if state.show_media {
                let _ = Command::new("playerctl")
                    .args(&["-a", "play-pause"])
                    .status();
            } else if let Some(timings) = fetch_timings() {
                let (current, _) = get_current_next(&timings);
                let is_current_done = state.done.contains(&current.name);
                if is_current_done {
                    state.done.retain(|x| x != &current.name);
                } else {
                    state.done.push(current.name.clone());
                }
                save_state(&state);
            }
        } else if action == "right" {
            let (status, _, _) = get_mpris();
            if !status.is_empty() {
                state.show_media = !state.show_media;
                save_state(&state);
            }
        } else if action == "middle" {
            if state.show_media {
                let _ = Command::new("playerctl").args(&["-a", "next"]).status();
            } else {
                state.end_dots = !state.end_dots;
                save_state(&state);
            }
        }
        sleep(Duration::from_millis(200));
        return;
    }

    let timings = match fetch_timings() {
        Some(t) => t,
        None => {
            let out = WaybarOutput {
                text: "API Error".to_string(),
                tooltip: String::new(),
                class: vec!["error".to_string()],
            };
            println!("{}", serde_json::to_string(&out).unwrap());
            return;
        }
    };

    let (current, next) = get_current_next(&timings);
    let mut state = get_state();

    let (mpris_status, mpris_text, mpris_tooltip) = get_mpris();
    let has_media = !mpris_status.is_empty();

    if !has_media && state.show_media {
        state.show_media = false;
        save_state(&state);
    }

    let show_media = state.show_media && has_media;
    let is_current_done = state.done.contains(&current.name);
    let mut output = WaybarOutput {
        text: String::new(),
        tooltip: String::new(),
        class: vec![],
    };

    if show_media {
        let icon = if mpris_status == "playing" {
            ""
        } else {
            ""
        };
        output.text = format!("{} {}", icon, mpris_text);
        output.class = vec!["mpris".to_string()];
        output.tooltip = mpris_tooltip;
    } else {
        let dot = if is_current_done { "." } else { "" };
        let time_str = next.time.format("%I:%M %p").to_string();

        let is_next_tomorrow = next.time.date_naive() > Local::now().date_naive();
        let next_display_str = if is_next_tomorrow {
            format!("{} (Tomorrow)", time_str)
        } else {
            time_str.clone()
        };

        let header_1 = format!("Current: {}", current.name);
        let header_2 = format!("Next: {} ({})", next.name, next_display_str);

        let mut prayer_lines = Vec::new();

        let order = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
        for name in order {
            if let Some(t_str) = timings.get(name) {
                if let Ok(t) = NaiveTime::parse_from_str(t_str, "%H:%M") {
                    if let Some(dt) = Local::now()
                        .date_naive()
                        .and_time(t)
                        .and_local_timezone(Local)
                        .single()
                    {
                        let is_done = state.done.contains(&name.to_string());
                        let is_current = dt == current.time;
                        let is_next = dt == next.time;

                        let marker = if is_next {
                            "◆"
                        } else if is_current {
                            "◈"
                        } else {
                            " "
                        };

                        let line = if state.end_dots {
                            let dot_str = if is_done { "." } else { "" };
                            format!("{} {:<8} {}{}", marker, name, dt.format("%I:%M %p"), dot_str)
                        } else {
                            let done_icon = if is_done { "●" } else { "○" };
                            format!("{} {} {:<8} {}", done_icon, marker, name, dt.format("%I:%M %p"))
                        };
                        prayer_lines.push(line);
                    }
                }
            }
        }

        let mut all_lines = vec![header_1.clone(), header_2.clone()];
        all_lines.extend(prayer_lines.clone());

        let max_len = all_lines
            .iter()
            .map(|s| s.chars().count())
            .max()
            .unwrap_or(20);

        let separator = "─".repeat(max_len);

        let mut final_tooltip_lines = Vec::new();
        final_tooltip_lines.push(header_1);
        final_tooltip_lines.push(header_2);
        final_tooltip_lines.push(separator);
        final_tooltip_lines.extend(prayer_lines);

        output.text = format!("{} {}{}", next.name, time_str, dot);
        output.class = if is_current_done {
            vec!["prayer".to_string(), "done".to_string()]
        } else {
            vec!["prayer".to_string()]
        };
        output.tooltip = escape_pango(&final_tooltip_lines.join("\n"));
    }

    println!("{}", serde_json::to_string(&output).unwrap());
}