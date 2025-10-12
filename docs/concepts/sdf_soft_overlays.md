---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# SDF Soft Overlays & Curve Fitting (Schema-First Tracking)

## Purpose
Define how Synesthetic uses **signed distance fields (SDFs)** and lightweight **curve fitting** to extract real-time state from video (and other sensors) with deterministic, low-footprint math — no heavy encoders. This is the perception counterpart to our schema-first rendering.

## One-liner
**Draw the gradient, follow it, predict the future.**  
SDF gives a continuous error signal; a couple of param updates per frame lock state; a tiny dynamics model predicts where things will be when latency lands.

## Minimal pipeline (portable Mermaid)
```mermaid
flowchart TD
  A[Camera frame] --> B[Warp to canonical (H)]
  B --> C[SDF overlay loss]
  C --> D[Param update 1–3 steps]
  D --> E[State (x,y,v)]
  E --> F[Curve fit / Kalman]
  F --> G[Latency-compensated intercept]
  G --> H[Action out]
  E --> I[Logs: state/loss/latency]
```

## Schema-first pieces

* **Overlay shader** (GLSL/SDF) is the *measurement kernel* and the *debug overlay*. Same geometry both ways → no domain gap.
* **Uniforms = tokens**: all tracked state is explicit, named, typed.
* **Dynamics** are declared (not learned): constant-velocity + bounce, first-order actuator lag, measured latency.

### Suggested schema slots (concept-level; not a migration)

* In `Shader` (or a new `Overlay` concept): declare required uniforms for measurement.
* In `Control/RuleBundle`: map measured state → actions.
* In `docs/evidence/`: record baseline runtimes + latencies.

## Minimal parameterization

* **Ball**: `ball.cx`, `ball.cy`, `ball.r`
* **Paddles**: `paddleL.x`, `paddleR.x` (height/width fixed)
* **Score (optional now)**: `score.digits[]` (SDF glyph IDs)
* **Warp**: `H[0..8]` (row-major homography)
* **Loss sharpness**: `alpha` (SDF → soft mask steepness)

## Loss + update (why this works)

* SDF distance: `d(x; θ)` (negative inside, positive outside)
* Soft mask: `s(x) = sigmoid(-alpha * d(x; θ))`
* Image loss (e.g., L2): `L = Σ w(x) * (s(x) - I(x))^2`
* Update: compute ∂L/∂θ for θ ∈ {ball.cx, ball.cy, ball.r, …}, do 1–3 small steps per frame (Gauss-Newton or gradient).
* Output: **sub-pixel state + confidence** (use loss value / gradient norm).

## Dynamics & latency (fit to the real world)

* **Ball**: constant-velocity + elastic bounce (bounds known in canonical frame).
* **Paddle actuator**: first-order lag `v(t)=k(1−e^{−t/τ})`, fit `τ` from step tests.
* **Prediction**: aim at state at `t + τ_act` (measured end-to-end latency).
* **Filter**: constant-velocity Kalman or short LS window.

## Evidence baseline

* Runs real-time with no dropped frames on a **12-year-old i5 Inspiron (Intel iGPU)**.
* Target hardware class: **Jetson/FPGA**; footprint is procedural, no cloud needed.

## Example (concept JSON)

```json
{
  "overlay": {
    "shaderRef": "shaders/sdf_physical_overlay.glsl",
    "uniforms": {
      "H": [1,0,0, 0,1,0, 0,0,1],
      "alpha": 8.0,
      "ball": {"cx": 80.0, "cy": 100.0, "r": 3.8},
      "paddleL": {"x": 10.0},
      "paddleR": {"x": 150.0},
      "score": {"digits": [0,0]}
    }
  },
  "perception": {
    "measurement": {"loss": "l2", "roi": "screen"},
    "update": {"steps": 2, "stepSize": 0.5}
  },
  "dynamics": {
    "ballModel": "constant_velocity_bounce",
    "paddleModel": "first_order_lag",
    "tauActMs": 45
  },
  "logging": {
    "rateHz": 60,
    "fields": ["timestamp","state","action","loss","latencyMs"]
  }
}
```

## Interfaces with Labs

* **Generator** can emit both: the overlay shader + initial uniform seeds.
* **Critic** scores tracking stability (loss mean/var), RMS pixel error, intercept hit-rate.
* **Logs** are JSONL @ 60 Hz; these become training/proof artifacts.

## Acceptance criteria (for POC)

* ≥59 Hz end-to-end tracking on modest laptop.
* Ball RMS error ≤2 px (canonical frame).
* Intercept prediction hit-rate ≥90% at measured `τ_act`.
* Latency histogram (p50/p90) included in logs.

## Next steps

* Add links from:

  * `concepts/tokenized_manifold.md` (this is the concrete manifold-measurement path).
  * `concepts/crosswalk_embodied_ai.md` (runtime footprint + deterministic measurement).
* Land a Labs POC with homography + ball/paddle only; scoreboard later.
