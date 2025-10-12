---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Performance Baselines

---

## Hypothesis v0 (2025-09-28)

**Claim**  
Synesthetic (schema-first, procedural) sustains real-time multimodal output (visual+audio+haptic) on constrained hardware (≤10 W Jetson-/old-iGPU-class) with **<20 ms** end-to-end frame latency and **<5%** drop rate over 5 minutes, **without** cloud or learned perceptual tokenizers.

**Falsifiers (fail conditions)**  
- avg frame dt ≥ 20.0 ms or p90 ≥ 22.0 ms  
- dropped frames ≥ 5%  
- sustained power > 10 W  
- requires network inference to hit targets  

**Environments**  
- **Mode A**: constrained baseline device ([hardware_baseline.md](hardware_baseline.md))  
- **Mode B**: reference laptop/desktop  

---

## Protocol

1. Warm-up 60 s (discard metrics).  
2. Run Visual (light/med/heavy), Audio, Haptic, Coupled (5 min each).  
3. Log JSONL rows per frame ([perf_baseline_2025-09-27.jsonl](perf_baseline_2025-09-27.jsonl)).  
4. Summarize into fps, dt, drop%, power.  

---

## Results — 2025-09-27

### Summary
- **FPS**: 59.98  
- **avg_dt**: 16.670 ms  
- **p50**: 16.667 ms  
- **p90**: 18.000 ms  
- **Dropped frames**: 0  
- **CPU**: Intel i5-5200U @ 500 MHz (load avg ~1.1, cores 2–8%)  
- **GPU**: idle (~1%)  
- **Memory footprint (page)**: ~76 MiB  
- **System memory**: 7.66 GiB total, 2.72 GiB used, 4.93 GiB available  

### First 3 JSONL lines

```json
{"ts_ms":129884,"frame":264,"dt_ms":16.7,"dropped":0}
{"ts_ms":129901,"frame":265,"dt_ms":16.7,"dropped":0}
{"ts_ms":129931,"frame":266,"dt_ms":17,"dropped":0}
