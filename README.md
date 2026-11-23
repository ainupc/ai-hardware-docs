# AiNu PC — On-Premises AI Hardware Reference

> **Forward-deployed AI engineering for startups and SMEs.** We bring on-site engineers + AMD Strix Halo hardware to your office — no cloud SaaS, no data leaving your perimeter. Singapore 🇸🇬 / Shenzhen 🇨🇳

---

## What We Do

- **Workflow audits:** On-site engineers map your processes and identify automation opportunities
- **Custom AI agents:** Built for your specific workflows, running locally on our hardware
- **On-premises deployment:** 256 GB/s unified memory AMD Strix Halo — powerful enough to run large models locally

## Why It Matters

Cloud SaaS means sending customer data to third parties and paying per-seat forever. Our approach: **hardware you own, models that never leave your building, automation that scales without recurring API costs.**

---

## Hardware Lineup & Benchmarks

All benchmarks measured with llama.cpp / Ollama on standard workloads (512-token output, Q4_K quantization unless noted).

### AI Desktop Workstations (Strix Halo)

| Model | Single-User | 3 Users | 5 Users | Memory | Bandwidth |
|---|---|---|---|---|---|
| **MAX+ PRO 495** (Pro) | 64 tok/s | — | — | 32 GB / 8533 MT/s | ~273 GB/s |
| **MAX+ 395** (Flagship) | 58 tok/s | 107 tok/s | 126 tok/s | 32 GB / 8000 MT/s | ~256 GB/s |
| **MAX+ 388** (80W) | 74 tok/s | — | — | 64 GB | ~256 GB/s |
| **Ryzen AI 9 HX 370** (Consumer) | 27 tok/s | — | — | 32 GB / 6400 MT/s | ~205 GB/s |

> Qwen3.6-35B-A3B model, Q4_K quantization. Single-user = per-user tokens/second. Multi-user = aggregate throughput across concurrent requests.

### Small Workstations (Mini PC / Thin Client)

| Model | Qwen3.6-35B-A3B | gpt-oss-20B | Notes |
|---|---|---|---|
| **Ryzen AI 9 HX 370** (8GB RAM + compression) | 27 tok/s | — | MoE compression enables running 35B on thin clients |
| **Core Ultra 9 285H** (Lunar Lake) | 19 tok/s | 12 tok/s | Intel Arc iGPU, ~30% slower than Strix Halo |
| **Core Ultra 5 228V** (Lunar Lake) | 26 tok/s | 15 tok/s | Budget option, good for smaller models |

### Multi-GPU Workstations

| Config | Qwen3.6-35B-A3B (BF16) | DeepSeek-R1-Distill-Qwen-32B | Users Supported |
|---|---|---|---|
| **1x R9700** (32 GB VRAM) | 40 tok/s | 44 tok/s | 1–5 users |
| **2x R9700** (64 GB VRAM) | 90 tok/s @ c=1 | 206 tok/s @ c=10 | 5–20 users |
| **4x R9700** (128 GB VRAM) | 90 tok/s @ c=1 | 748 tok/s @ c=30 | 20–50 users |

> DeepSeek-R1-Distill-Qwen-32B on 4x R9700 sustains **~25 tok/s per user at 30 concurrent users** — suitable for team-wide AI assistance.

### Server-Class (Data Center)

| Config | DeepSeek-R1-Distill-Qwen-32B @ c=30 | Qwen3-235B-A22B @ c=1 |
|---|---|---|
| **8x RTX 4090** (FP8) | ~1,140 tok/s aggregate | — |
| **8x R9700** (INT4) | ~320 tok/s aggregate | — |
| **4x W7900** (INT4) | — | 64 tok/s aggregate |

---

## Quick Start: Deploy with Ollama

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull a model
ollama pull qwen3.6:35b-a3b

# Run it
ollama run qwen3.6:35b-a3b
```

See `examples/ollama-deploy.sh` for an automated setup script with monitoring.

---

## TCO Comparison (Annual)

| Approach | Year 1 | Year 2 | Year 3 | Data Privacy |
|---|---|---|---|---|
| **Cloud SaaS** (per-seat API) | $12,000+ | $14,400+ | $17,280+ | Third-party processing |
| **AiNu PC Hardware** | ~$3,500–8,000 | $0 | $0 | Your perimeter |

> Based on 5-user team. Cloud costs at ~$200/user/month including token overage. AiNu hardware is a one-time purchase with no recurring fees.

---

## Compliance

- **PDPA (Singapore):** All data processed and stored within your premises
- **GDPR:** No cross-border data transfer; full controller control
- See [docs/pdpa-compliance.md](docs/pdpa-compliance.md) for full technical details

---

## Sizing Guide

Not sure which hardware fits your workload? See [docs/sizing-guide.md](docs/sizing-guide.md).

---

## Links

- [ainupc.com](https://ainupc.com)

## License

MIT — see [LICENSE](LICENSE) for terms and disclaimer.
