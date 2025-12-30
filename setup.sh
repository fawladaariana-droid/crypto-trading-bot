#!/bin/bash

# Crypto Trading Bot Setup Script
# This script helps you set up and run the trading bot

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/config.yaml"
ENV_FILE="$SCRIPT_DIR/.env"

# Function to print colored output
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check Python
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
        print_success "Python 3.9+ found: $PYTHON_VERSION"
    else
        print_error "Python 3.9+ not found. Please install Python 3.9 or higher."
        exit 1
    fi
    
    # Check pip
    if command -v pip3 &> /dev/null; then
        print_success "pip3 found"
    else
        print_error "pip3 not found. Please install pip."
        exit 1
    fi
    
    # Check Docker (optional)
    if command -v docker &> /dev/null; then
        print_success "Docker found"
    else
        print_warning "Docker not found (optional for containerized deployment)"
    fi
    
    # Check Docker Compose (optional)
    if command -v docker-compose &> /dev/null; then
        print_success "Docker Compose found"
    else
        print_warning "Docker Compose not found (optional for containerized deployment)"
    fi
}

# Function to setup virtual environment
setup_virtual_env() {
    print_header "Setting up Virtual Environment"
    
    if [ ! -d "$SCRIPT_DIR/venv" ]; then
        print_info "Creating virtual environment..."
        python3 -m venv "$SCRIPT_DIR/venv"
        print_success "Virtual environment created"
    else
        print_info "Virtual environment already exists"
    fi
    
    # Activate virtual environment
    source "$SCRIPT_DIR/venv/bin/activate"
    print_success "Virtual environment activated"
}

# Function to install dependencies
install_dependencies() {
    print_header "Installing Dependencies"
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install requirements
    if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
        print_info "Installing Python dependencies..."
        pip install -r "$SCRIPT_DIR/requirements.txt"
        print_success "Dependencies installed"
    else
        print_error "requirements.txt not found"
        exit 1
    fi
}

# Function to setup configuration
setup_configuration() {
    print_header "Setting up Configuration"
    
    # Copy config file if it doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        if [ -f "$SCRIPT_DIR/config/config.yaml.example" ]; then
            cp "$SCRIPT_DIR/config/config.yaml.example" "$CONFIG_FILE"
            print_success "Configuration file created from example"
        else
            print_error "Configuration example file not found"
            exit 1
        fi
    else
        print_info "Configuration file already exists"
    fi
    
    # Copy environment file if it doesn't exist
    if [ ! -f "$ENV_FILE" ]; then
        if [ -f "$SCRIPT_DIR/.env.example" ]; then
            cp "$SCRIPT_DIR/.env.example" "$ENV_FILE"
            print_success "Environment file created from example"
        else
            print_error "Environment example file not found"
            exit 1
        fi
    else
        print_info "Environment file already exists"
    fi
    
    print_warning "Please edit $CONFIG_FILE and $ENV_FILE with your settings"
}

# Function to create necessary directories
create_directories() {
    print_header "Creating Directories"
    
    mkdir -p "$SCRIPT_DIR/logs"
    mkdir -p "$SCRIPT_DIR/data"
    mkdir -p "$SCRIPT_DIR/backups"
    
    print_success "Directories created"
}

# Function to test API connection
test_api_connection() {
    print_header "Testing API Connection"
    
    # Test with a simple Python script
    python3 -c "
import sys
sys.path.insert(0, '$SCRIPT_DIR')
try:
    from pybit.unified_trading import HTTP
    client = HTTP(testnet=True)
    result = client.get_server_time()
    if result['retCode'] == 0:
        print('✓ Bybit API connection successful')
    else:
        print('✗ Bybit API connection failed: ' + str(result))
except Exception as e:
    print('✗ API test failed: ' + str(e))
"
}

# Function to run the bot
run_bot() {
    print_header "Running the Trading Bot"
    
    # Activate virtual environment
    source "$SCRIPT_DIR/venv/bin/activate"
    
    # Ask user for mode
    echo -e "${BLUE}Choose mode:${NC}"
    echo "1) Paper Trading (Recommended)"
    echo "2) Live Trading (⚠️ Risky)"
    echo "3) Exit"
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            print_info "Starting in PAPER TRADING mode..."
            export PAPER_TRADING=true
            python3 -m src.main --config "$CONFIG_FILE"
            ;;
        2)
            print_warning "Starting in LIVE TRADING mode!"
            read -p "Are you sure you want to use real money? (yes/no): " confirm
            if [ "$confirm" = "yes" ]; then
                export PAPER_TRADING=false
                python3 -m src.main --config "$CONFIG_FILE"
            else
                print_info "Cancelled. Use paper trading first to test the bot."
            fi
            ;;
        3)
            print_info "Exiting setup"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
}

# Function to setup with Docker
setup_docker() {
    print_header "Setting up with Docker"
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker not found. Please install Docker first."
        return 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose not found. Please install Docker Compose first."
        return 1
    fi
    
    # Build and start with Docker Compose
    print_info "Building Docker image..."
    docker-compose build
    
    print_success "Docker setup completed"
    print_info "To start the bot with Docker, run: docker-compose up -d"
    print_info "To view logs, run: docker-compose logs -f trading-bot"
    print_info "To stop the bot, run: docker-compose down"
}

# Function to display menu
show_menu() {
    print_header "Crypto Trading Bot Setup"
    
    echo -e "${GREEN}Welcome to the Crypto Trading Bot setup!${NC}"
    echo
    echo -e "${BLUE}What would you like to do?${NC}"
    echo
    echo "1) Complete setup (recommended for first time)"
    echo "2) Install dependencies only"
    echo "3) Run the bot"
    echo "4) Setup with Docker"
    echo "5) Test API connection"
    echo "6) Exit"
    echo
    read -p "Enter your choice (1-6): " choice
    
    case $choice in
        1)
            check_prerequisites
            setup_virtual_env
            install_dependencies
            setup_configuration
            create_directories
            test_api_connection
            print_success "Setup completed! You can now run the bot."
            ;;
        2)
            setup_virtual_env
            install_dependencies
            ;;
        3)
            run_bot
            ;;
        4)
            setup_docker
            ;;
        5)
            test_api_connection
            ;;
        6)
            print_info "Exiting setup"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
}

# Main execution
main() {
    # Check if we're in the right directory
    if [ ! -f "$SCRIPT_DIR/requirements.txt" ]; then
        print_error "This script must be run from the crypto-trading-bot directory"
        exit 1
    fi
    
    # Show menu
    show_menu
}

# Run main function
main "$@"