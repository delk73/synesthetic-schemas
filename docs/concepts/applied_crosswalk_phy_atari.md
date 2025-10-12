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
## Applied Crosswalk: Physical Atari (camera-in, actuator-out @ ~60 FPS)

**Why this target:** real hardware, strict latency, simple geometry → perfect for SDF soft overlays + curve-fit.

### Mapping
- **Sensor → Canonical frame:** USB camera → (opt) lens undistort → crop to screen → homography `H` → canonical Atari space (e.g., 160×192; adjust per title).
- **Measurement kernel:** SDF soft overlays (ball, paddles, optional digits) → continuous loss; 1–3 param updates per frame → sub-pixel state + confidence.
- **State vector:**  
  - Ball: `(cx, cy, r, vx, vy)`  
  - Paddles: `x_L`, `x_R` (optionally `v_L`, `v_R`)  
  - Score (opt): `digits[ ]` with per-digit confidence
- **Dynamics:** ball = constant-velocity + elastic bounds; paddle = first-order lag (fit `τ_paddle`); measured end-to-end latency `τ_total`.
- **Control:** predict intercept at `t + τ_total`; output joystick via RoboTroller or DB-9.
- **Reward:** scoreboard ROI → SDF-OCR → integer score; diff for reward.
- **Runtime footprint:** grayscale ROI + GLSL SDF + tiny filters → runs on modest laptops; scales to Jetson/FPGA.

### Minimal POC (no heroics)
1. **Calibrate `H`**: capture four corners (or AprilTags); store `H` and screen ROI.
2. **Track**: ball+paddles only; L2 (or BCE) on soft mask; 1–3 gradient steps/frame.
3. **Filter & predict**: constant-velocity Kalman; wall bounce; predict to `t + τ_total`.
4. **Actuate**: send joystick; record send timestamps.
5. **(Opt) Score**: 2-digit SDF glyph OCR with confidence thresholding.
6. **Measure latency**: blink test (screen patch) → detect → act → detect; compute `τ_total` (p50/p90).
7. **Logs**: JSONL @ 60 Hz.

### Logging schema (concrete)
- Fields:  
  `ts_ms, frame_id, ball:{cx,cy,r,vx,vy,conf}, paddles:{xL,xR}, action:{u}, loss, grad_norm, latency_ms, score:{val,conf}`
- Example line:
```json
{"ts_ms": 1695840012345, "frame_id": 8421,
 "ball":{"cx":78.4,"cy":96.2,"r":3.7,"vx":2.1,"vy":-1.8,"conf":0.94},
 "paddles":{"xL":12.0,"xR":148.7},
 "action":{"u":"RIGHT"},
 "loss":0.012,"grad_norm":0.43,"latency_ms":47,
 "score":{"val":3,"conf":0.99}}
````

### Overlay shader uniforms (min set)

`H[9], alpha, bounds, ball:{cx,cy,r}, paddleL:{x}, paddleR:{x}, score:{digits[]}`

### Acceptance (stop when all true)

* Tracking ≥59 Hz end-to-end on your Inspiron-class laptop.
* Ball RMS error ≤2 px (canonical frame).
* Intercept hit-rate ≥90% at measured `τ_total`.
* Latency histogram (p50/p90) present in logs; method documented.

### Risks & mitigations

* **Glare/rolling shutter:** narrow ROI + exposure lock; prefer grayscale.
* **Homography drift:** verify corner error ≤1 px every N frames; re-cal if needed.
* **Actuator slack:** fit `τ_paddle` from step response; include in `τ_total`.

### Pointers to Concepts

* **Measurement method:** `docs/concepts/sdf_soft_overlays.md`
* **Positioning frame:** `docs/concepts/tokenized_manifold.md`, `docs/concepts/positioning_embodied.md`

See the live corpus: [SOTA: Perception & Interface Landscape](../sota/sota_perception_interfaces.md)
See governance.md §Versioning