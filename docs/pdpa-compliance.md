# PDPA & GDPR Compliance Guide

## Overview

AiNu PC hardware is designed from the ground up for data privacy compliance. This document explains how our on-premises AI deployment model satisfies Singapore's PDPA and the EU's GDPR requirements.

## Data Flow Architecture

```
[Your Office]
    │
    ├── AiNU PC Hardware (local)
    │       │
    │       ├── Model inference runs locally
    │       ├── All data stays in RAM/disk on your premises
    │       └── No network calls to external servers
    │
    [No data leaves your perimeter]
```

### Key Design Decisions

1. **No cloud dependency** — Models run entirely on local hardware; no API calls to third parties
2. **No telemetry** — Ollama and llama.cpp have no built-in telemetry by default
3. **Local model storage** — Model weights stored on your premises' drives
4. **Network-isolated operation** — Hardware can operate on an air-gapped network if required

## Singapore PDPA Compliance

### PDPA Requirements Met

| Requirement | How AiNu PC Addresses It |
|---|---|
| **Consent** | You control what data is processed; no third-party collection |
| **Purpose Limitation** | Data only used for your stated business purposes |
| **Access & Correction** | Full access to all stored data on your premises |
| **Protection** | On-premises storage + encryption options (see below) |
| **Retention** | You control retention policies; no automatic cloud deletion |
| **Transfer Restrictions** | No cross-border data transfer by design |

### PDPA Obligations Checklist

- [ ] Appoint a Data Protection Officer (DPO) — still required under PDPA
- [ ] Create a data breach notification policy — hardware can't leak data, but you need IT procedures
- [ ] Implement reasonable security measures — see Security section below
- [ ] Conduct DPIA for high-risk processing — we provide technical details to support this

## GDPR Compliance

### GDPR Requirements Met

| Article | Requirement | How AiNu PC Addresses It |
|---|---|---|
| **Art. 6** | Lawful basis for processing | Data never leaves your control; you are the data controller |
| **Art. 25** | Data protection by design | Hardware designed for local-only operation |
| **Art. 32** | Security of processing | On-premises storage, encryption options, network isolation |
| **Art. 44–50** | Cross-border transfers | Not applicable — no data leaves your premises |
| **Art. 35** | Data Protection Impact Assessment | Technical documentation provided for DPIA completion |

### Key GDPR Advantages

1. **No transfer mechanism needed** — Since data never leaves your EU/Singapore premises, Article 44–50 restrictions don't apply
2. **Full controller control** — You maintain complete custody of all personal data
3. **Right to erasure** — Delete local files; no cloud backups to purge
4. **Data minimization** — Only process what you need; no incidental data collection by service providers

## Security Recommendations

### Hardware-Level Security

1. **Full disk encryption (FDE)** — Enable BitLocker (Windows) or LUKS (Linux) on all AiNU PC storage
2. **BIOS/UEFI password** — Prevent unauthorized boot from external media
3. **TPM 2.0** — Use for hardware-backed key storage (available on most AiNU PC models)
4. **Network segmentation** — Place AiNU PC hardware on your internal network, not exposed to the internet

### Software-Level Security

1. **Ollama configuration:**
   ```bash
   # Disable any telemetry (already off by default in recent versions)
   export OLLAMA_DEBUG=1  # Enable debug logging for auditing
   
   # Run Ollama on localhost only (default, but verify)
   ollama serve --listen localhost:11434
   
   # Set up API key authentication for remote access
   export OLLAMA_ORIGINS=https://your-internal-app.domain
   ```

2. **Model integrity verification:**
   ```bash
   # Verify model checksums after download
   ollama show <model-name> --verbose
   
   # Use pinned versions in production
   ollama pull qwen3.6:35b-a3b@sha256:<verified-hash>
   ```

3. **Access control:**
   - Restrict physical access to hardware
   - Use OS-level authentication for Ollama API endpoints
   - Implement network ACLs if the API is exposed internally

### Audit & Monitoring

```bash
# Monitor Ollama processes
ps aux | grep ollama

# Check disk encryption status (Linux)
sudo dmsetup status

# Check BitLocker status (Windows)
manage-bde -status

# Review system logs for unauthorized access
journalctl -u ollama --since "24 hours ago"  # Linux
```

## Data Processing Addendum (DPA)

When AiNu PC hardware is deployed at a customer site:

1. **Data Controller:** The customer organization
2. **Data Processor:** None — AiNu PC acts as a hardware vendor, not a processor
3. **Sub-processors:** None — all processing occurs on customer premises
4. **Data Location:** Customer's physical premises (Singapore/EU)
5. **Retention:** Controlled entirely by the customer
6. **Deletion:** Physical access to drives enables complete data erasure

## Compliance Certifications & Standards

### Current Status

- AiNU PC hardware is designed to support compliance with PDPA and GDPR
- Technical documentation provided for customer DPIA processes
- No third-party certifications held directly (hardware vendor, not a service provider)

### Recommended Customer Actions

1. **Consult your legal team** — This document provides technical details; legal interpretation is required
2. **Conduct a DPIA** — Use our technical documentation to complete the assessment
3. **Implement recommended security measures** — See Security section above
4. **Regular audits** — Verify on-premises deployment hasn't been modified

## Incident Response

If you suspect a data breach involving AiNU PC hardware:

1. **Isolate the hardware** — Disconnect from network immediately
2. **Preserve evidence** — Do not power off; create disk image if possible
3. **Check for unauthorized access** — Review system logs, check for unexpected processes
4. **Contact AiNu PC support** — We can provide technical details about the deployment
5. **Notify authorities** — Under PDPA (72-hour rule) or GDPR (72-hour rule) as applicable

## Contact

For compliance questions:
- Email: sales@ainupc.com
- Technical documentation: This repository (ai-hardware-docs)

---

*Last updated: November 2026. This document provides technical details for compliance purposes. Consult legal counsel for binding compliance opinions.*
