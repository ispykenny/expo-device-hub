---
"@expo/serve-sim": patch
---

Fix hardware buttons being ignored when CoreDevice owns Simulator input. Use CoreDevice for button delivery and report unavailable button input instead of falling back to Indigo in those sessions.
