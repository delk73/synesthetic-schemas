---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

# Hardware Baseline A — Constrained Device

## Device Overview
- **Model**: Dell Inspiron (2015)
- **CPU**: Intel i5-5200U (2 cores / 4 threads, 2.2 GHz base, 500 MHz observed idle)
- **GPU**: Intel HD Graphics 5500 (integrated)
- **RAM**: 8 GB DDR3 (7.66 GiB usable)
- **OS / WM**: Linux, Hyprland
- **Power Profile**: ≤10 W package (observed 4.3–5.0 W CPU, 0.1–0.13 W GPU at idle)

## Baseline Measurements (Idle Desktop)
Captured 2025-09-28.

- **CPU frequency**: 500 MHz per core (<1 GHz total), ~14–18% util per core
- **GPU util**: 35–44%, ~0.10–0.13 W
- **Load avg**: ~0.9–1.0
- **Memory**: 2.47 GiB used of 7.66 GiB
- **Swap**: 0 GiB used of 3.8 GiB
- **Power draw**: CPU 4.3–5.0 W, package ≤5 W
- **Battery**: 100%, reported drain ~0.02 W
- **Processes**: Chromium, VS Code, Alacritty, Hyprland, btop, ssh

### Screenshot A
Idle baseline at 12:17:38, ~14% CPU, ~44% GPU util.  
![constrained_env_a](constrained_env_a.png)

### Screenshot B
Idle baseline at 12:19:44, CPU fixed at 500 MHz, GPU util ~35%.  
![constrained_env_b](constrained_env_b.png)

## Role in Perf Protocol
This device serves as **Mode A (Constrained)** in the performance hypothesis protocol.  
All Synesthetic benchmarks must demonstrate **real-time multimodal output** under the following conditions:
- End-to-end frame latency <20 ms
- Dropped frames <5% over 5 minutes
- Sustained power ≤10 W

The app footprint is expected to be negligible relative to this baseline. Perf results will be logged in `perf/perf-baselines.md`.
