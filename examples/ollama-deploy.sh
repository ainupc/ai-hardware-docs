#!/bin/bash
# AiNu PC — Ollama Deployment Script
# Automated setup for on-premises AI deployment
# Compatible with Ubuntu 22.04+, Debian 12+, Fedora 38+

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    elif [ -f /etc/redhat-release ]; then
        OS="rhel"
        VERSION=$(grep -oP '\d+' /etc/redhat-release | head -1)
    else
        log_error "Unsupported operating system"
        exit 1
    fi
    log_info "Detected: ${OS} ${VERSION}"
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check RAM (minimum 32 GB recommended for Strix Halo)
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$TOTAL_RAM" -lt 16 ]; then
        log_warn "System has only ${TOTAL_RAM}GB RAM. Recommended: 32GB+"
    else
        log_info "RAM: ${TOTAL_RAM}GB ✓"
    fi
    
    # Check disk space (minimum 50 GB for models)
    AVAILABLE_DISK=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
    if [ "$AVAILABLE_DISK" -lt 50 ]; then
        log_warn "Only ${AVAILABLE_DISK}GB available. Recommended: 100GB+"
    else
        log_info "Disk space: ${AVAILABLE_DISK}GB ✓"
    fi
    
    # Check for AMD GPU (Strix Halo)
    if lspci 2>/dev/null | grep -i "vga\|3d\|display" | grep -qi "amd"; then
        log_info "AMD GPU detected ✓"
    else
        log_warn "No AMD GPU detected. Performance may be limited."
    fi
}

# Install Ollama
install_ollama() {
    if command -v ollama &>/dev/null; then
        CURRENT_VER=$(ollama --version 2>/dev/null || echo "unknown")
        log_info "Ollama already installed: ${CURRENT_VER}"
        return 0
    fi
    
    log_info "Installing Ollama..."
    
    case $OS in
        ubuntu|debian)
            curl -fsSL https://ollama.com/install.sh | sh
            ;;
        fedora|rhel)
            curl -fsSL https://ollama.com/install.sh | sh
            ;;
        *)
            log_error "Package manager not supported. Install manually: https://ollama.com/download"
            exit 1
            ;;
    esac
    
    log_info "Ollama installed successfully"
}

# Pull recommended models
pull_models() {
    local models=("$@")
    
    for model in "${models[@]}"; do
        log_info "Pulling model: ${model}"
        ollama pull "$model" || {
            log_warn "Failed to pull ${model}. Skipping."
            continue
        }
        log_info "Model ${model} ready ✓"
    done
}

# Configure Ollama for production
configure_ollama() {
    log_info "Configuring Ollama for production use..."
    
    # Create systemd service if not exists
    if [ ! -f /etc/systemd/system/ollama.service ]; then
        log_warn "Ollama service not configured. Start with: ollama serve &"
    fi
    
    # Set environment variables
    local env_file="/etc/default/ollama"
    cat > "$env_file" << 'EOF'
# Ollama environment configuration
OLLAMA_HOST=0.0.0.0
OLLAMA_PORT=11434
OLLAMA_MAX_LOADED_MODELS=2
OLLAMA_NUM_PARALLEL=4
OLLAMA_KEEP_ALIVE=24h
EOF
    
    log_info "Configuration written to ${env_file}"
    log_warn "Restart Ollama to apply: systemctl restart ollama"
}

# Monitor GPU/memory usage
monitor() {
    log_info "Starting monitoring (Ctrl+C to stop)..."
    
    while true; do
        clear
        echo "=== AiNU PC AI Monitor ==="
        echo ""
        
        # RAM usage
        echo "Memory:"
        free -h | grep -E "Mem|Swap"
        echo ""
        
        # GPU info (if AMD)
        if command -v rocm-smi &>/dev/null; then
            echo "GPU (ROCm):"
            rocm-smi --showmeminfo 2>/dev/null || echo "ROCm not available"
        elif command -v nvidia-smi &>/dev/null; then
            echo "GPU (NVIDIA):"
            nvidia-smi --query-gpu=name,memory.total,memory.used,memory.free --format=csv,noheader 2>/dev/null || echo "No NVIDIA GPU"
        else
            echo "GPU: Integrated or not detected"
        fi
        
        echo ""
        echo "Ollama processes:"
        ps aux | grep -E "ollama|llama" | grep -v grep || echo "  None running"
        
        echo ""
        echo "Updated: $(date '+%Y-%m-%d %H:%M:%S')"
        sleep 5
    done
}

# Main execution
main() {
    echo "====================================="
    echo "  AiNU PC — Ollama Deployment"
    echo "  On-Premises AI Setup"
    echo "====================================="
    echo ""
    
    detect_os
    check_requirements
    
    # Install Ollama
    install_ollama
    
    # Pull default models (Qwen3.6-35B-A3B is the recommended starting point)
    log_info "Pulling default models..."
    pull_models "qwen3.6:35b-a3b"
    
    # Configure for production
    configure_ollama
    
    echo ""
    log_info "Setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Verify installation: ollama list"
    echo "  2. Test a model:        ollama run qwen3.6:35b-a3b"
    echo "  3. Monitor hardware:    bash $(basename "$0") monitor"
    echo "  4. Enable auto-start:  systemctl enable --now ollama"
    echo ""
    log_warn "Remember to configure firewall rules if exposing the API:"
    echo "  ufw allow 11434/tcp   # Ubuntu/Debian"
}

# Parse command line
case "${1:-install}" in
    install)
        main
        ;;
    monitor|status)
        monitor
        ;;
    models)
        pull_models "${@:2}"
        ;;
    *)
        echo "Usage: $0 {install|monitor|models <model1> [model2 ...]}"
        exit 1
        ;;
esac
