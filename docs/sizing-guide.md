# Workload Sizing Guide

> Which AiNu PC hardware fits your team's AI workload? Use this guide to match your needs to the right configuration.

## Quick Decision Tree

```
1. How many people will use AI simultaneously?
   ├── 1 user → Strix Halo ADW (Ryzen AI MAX+ 395) or consumer AI PC
   ├── 2–10 users → Strix Halo PRO (MAX+ PRO 495) or multi-user workstation
   ├── 10–50 users → Multi-GPU workstation (2x–4x R9700)
   └── 50+ users → Server-class deployment

2. What models do you need?
   ├── Small models (<10B params, e.g., Qwen3.6-35B-A3B MoE) → Any Strix Halo device
   ├── Medium models (10–70B params, e.g., Llama-4-Scout-109B) → MAX+ PRO 495 or multi-GPU
   └── Large models (>70B params, e.g., Qwen3-235B-A22B) → Multi-GPU workstation or server

3. What's your latency budget?
   ├── <1s response → Single GPU (R9700 32GB) or Strix Halo for small models
   ├── 1–5s response → Multi-GPU workstation
   └── >5s acceptable → Server-class with larger quantization
```

## Benchmark Reference: Qwen3.6-35B-A3B (MoE, 3B active params)

This is our flagship model for most SME workflows — fast, accurate, and efficient.

### Single-User Performance (tok/s)

| Hardware | Throughput | Latency (per token) | Notes |
|---|---|---|---|
| **MAX+ 395** (Strix Halo, 256 GB/s) | ~58 tok/s | ~17 ms/token | Best consumer option |
| **MAX+ PRO 495** (PRO, 273 GB/s) | ~64 tok/s | ~16 ms/token | ECC memory, better for production |
| **Ryzen AI 9 HX 370** (Consumer APU) | ~27 tok/s | ~37 ms/token | Budget alternative |
| **Core Ultra 9 285H** (Intel Lunar Lake) | ~19 tok/s | ~53 ms/token | ~30% slower than Strix Halo |

### Multi-User Performance (aggregate tok/s → per-user at load)

| Hardware | c=1 | c=3 | c=5 | c=10 |
|---|---|---|---|---|
| **MAX+ 395** | 58 | 107 (36/user) | 126 (25/user) | 90 (9/user) |

> At 5 concurrent users, each still gets ~25 tok/s — readable response in ~4 seconds for a 100-token answer.
> At 10 concurrent users, throughput drops to ~9 tok/s per user — acceptable for non-real-time workflows.

## Workload-Sized Recommendations

### Solo Developer / Power User

**Recommended:** AiNU ADW with MAX+ 395 ($2,500–3,500)
- Run Qwen3.6-35B-A3B locally at ~58 tok/s
- Also handles gpt-oss-20B (~47 tok/s) and Llama-4-Scout-109B (Q4_K)
- 32 GB unified memory — fits most models up to 70B with quantization

### Small Team (2–5 Users)

**Recommended:** MAX+ PRO 495 workstation ($3,500–5,000) or 1x R9700 mini-workstation
- Sustains 3–5 concurrent users on Qwen3.6-35B-A3B at >25 tok/s each
- ECC memory for production reliability
- Option to add a dedicated GPU (R9700 32GB) for larger models

### Medium Team (5–20 Users)

**Recommended:** Multi-GPU workstation: 2x R9700 ($10,000–15,000)
- Qwen3.6-35B-A3B at ~450 tok/s aggregate across the team
- DeepSeek-R1-Distill-Qwen-32B at ~200+ tok/s with 10 concurrent users
- Room to scale to 4x GPU if needed

### Enterprise (20–50+ Users)

**Recommended:** Server-class: 4x R9700 or 8x RTX 4090 ($20,000–40,000)
- DeepSeek-R1-Distill-Qwen-32B at ~750 tok/s with 30 concurrent users
- Qwen3-235B-A22B (INT4) feasible for specialized tasks
- Consider Ollama + vLLM or TGI for production serving

## Model Sizing Quick Reference

| Model | Params | BF16 VRAM | Q4_K RAM | Recommended Hardware |
|---|---|---|---|---|
| Qwen3.6-35B-A3B (MoE) | 35B (3B active) | ~70 GB | ~20 GB | Any Strix Halo device |
| gpt-oss-20B | 20B | ~40 GB | ~12 GB | Consumer AI PC |
| Llama-4-Scout-109B | 109B | ~218 GB | ~60 GB | MAX+ PRO 495 (Q4_K) |
| DeepSeek-R1-Distill-Qwen-32B | 32B | ~64 GB | ~18 GB | Any Strix Halo device |
| Qwen3-235B-A22B (MoE) | 235B (22B active) | ~470 GB | ~130 GB | 2x+ R9700 or server |

> **Note:** MoE models activate only a fraction of parameters per token. The "Params" column shows total; "active params" in parentheses is what actually runs per inference — this is why MoE models are fast on consumer hardware.

## Memory Sizing Formula

For non-MoE dense models:
```
Required RAM (GB) ≈ model_params × bytes_per_param × quantization_factor
```

| Quantization | Bytes/Param | Example: 70B model |
|---|---|---|
| BF16 (full precision) | 2.0 | 140 GB |
| INT8 | 1.0 | 70 GB |
| Q4_K (recommended) | ~0.5–0.6 | 35–42 GB |
| Q3_K | ~0.4 | 28 GB |

For MoE models, use active_params instead of total_params for per-token memory during inference.

## Benchmark Data Sources

All benchmarks in this guide come from our internal testing, try our interactive workload-sizing calculator at [ainupc.com/hardware](https://ainupc.com/hardware)
