# 🤖 Crypto Futures Trading Bot

A professional-grade automated trading system for BTCUSDT perpetual futures on Bybit, featuring AI-powered decision making, comprehensive risk management, and real-time monitoring.

## 🌟 Features

### Core Trading Intelligence
- **Multi-timeframe Analysis**: 1m, 5m, 15m, 1h, 4h, 1d data analysis
- **Technical Indicators**: RSI, MACD, EMA/SMA, VWAP, Bollinger Bands, ATR
- **Smart Money Concepts**: Liquidity grabs, FVG, Order blocks, BOS, CHOCH
- **AI/ML Learning**: Pattern recognition, regime detection, adaptive parameters
- **News & Sentiment**: Automated news analysis and sentiment scoring

### Risk Management (Institutional Grade)
- **Position Sizing**: Dynamic calculation based on risk percentage
- **Stop Loss/Take Profit**: Dynamic SL/TP based on ATR and market structure
- **Drawdown Control**: Daily/weekly maximum loss limits
- **Emergency Controls**: Kill switch, cooldown periods, auto position closure
- **Risk Scoring**: Real-time risk assessment and scoring

### Monitoring & Control
- **Real-time GUI Dashboard**: Web-based interface with live updates
- **Position Tracking**: Real-time PnL and position management
- **Performance Analytics**: Comprehensive statistics and reporting
- **Manual Override**: Pause, close all, emergency stop controls
- **Mobile Responsive**: Works on all devices

### Safety Features
- **Paper Trading Mode**: Risk-free testing environment (mandatory first step)
- **Gradual Deployment**: Start with minimal capital
- **Comprehensive Logging**: All decisions and trades logged
- **No Overfitting**: Transparent, explainable decision-making
- **Automatic Restart**: Fault tolerance and recovery

## 🏗️ Architecture

```
Market Data → Technical Analysis → Smart Money Concepts → Signal Generation
     ↓
Risk Management ← AI Learning ← News & Sentiment
     ↓
Execution Engine → Order Management → Position Tracking
     ↓
GUI Dashboard ← Logging & Analytics ← Performance Monitoring
```

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Docker & Docker Compose (optional)
- Bybit API credentials (for live trading)

### Installation

#### Option 1: Docker (Recommended)
```bash
# Clone the repository
git clone <repository-url>
cd crypto-trading-bot

# Copy environment file
cp .env.example .env

# Edit configuration
nano .env  # Add your API keys and configure settings

# Start with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f trading-bot
```

#### Option 2: Manual Installation
```bash
# Clone the repository
git clone <repository-url>
cd crypto-trading-bot

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure the bot
cp config/config.yaml config/config.yaml.local
nano config/config.yaml.local

# Run the bot
python -m src.main --config config/config.yaml.local
```

### Configuration

#### Essential Settings (`config/config.yaml`)
```yaml
# Bybit API (get from https://www.bybit.com/app/user/api-management)
bybit:
  testnet: true  # Set to false for live trading
  api_key: "YOUR_API_KEY"
  api_secret: "YOUR_API_SECRET"

# Risk Management (IMPORTANT - adjust carefully)
risk:
  max_risk_per_trade: 0.01    # 1% max risk per trade
  max_daily_drawdown: 0.05    # 5% max daily loss
  max_weekly_drawdown: 0.10   # 10% max weekly loss
  stop_loss_atr_multiplier: 2.0
  take_profit_ratio: 2.0

# Always start with paper trading
paper_trading:
  enabled: true  # Keep true until thoroughly tested
  initial_balance: 10000.0
```

#### Environment Variables (`.env`)
```bash
BYBIT_API_KEY=your_api_key_here
BYBIT_API_SECRET=your_api_secret_here
PAPER_TRADING=true
MAX_RISK_PER_TRADE=0.01
```

## 📊 Dashboard

Access the web dashboard at `http://localhost:8080` when the bot is running.

### Dashboard Features
- **Real-time Charts**: Price action with technical indicators
- **Position Management**: View and manage open positions
- **Performance Metrics**: PnL, win rate, drawdown statistics
- **Risk Monitoring**: Real-time risk assessment
- **Trade History**: Detailed log of all trades
- **Bot Controls**: Manual override and emergency controls

## 🎯 Trading Strategy

The bot combines multiple analysis techniques:

### 1. Technical Analysis
- Multi-timeframe trend analysis using EMAs
- Momentum indicators (RSI, MACD)
- Volatility analysis (ATR, Bollinger Bands)
- Volume analysis and price action

### 2. Smart Money Concepts
- **Liquidity Zones**: Support/resistance, equal highs/lows
- **Fair Value Gaps (FVG)**: Imbalance areas
- **Order Blocks**: Institutional entry zones
- **Structure Breaks**: BOS and CHOCH detection

### 3. AI/ML Analysis
- **Pattern Recognition**: Candlestick and chart patterns
- **Market Regime Detection**: Trending vs ranging markets
- **Signal Strength Prediction**: Confidence scoring
- **Parameter Optimization**: Adaptive strategy tuning

### 4. Sentiment Analysis
- News sentiment scoring
- Social media sentiment (future feature)
- Market fear & greed indicators
- Automatic risk-off during high-impact events

## 🛡️ Risk Management

### Position Sizing
```python
# Risk per trade: 1% of account
risk_amount = account_balance * 0.01

# Position size = Risk Amount / Stop Loss Distance
position_size = risk_amount / (entry_price - stop_loss_price)
```

### Drawdown Limits
- **Daily**: 5% maximum loss
- **Weekly**: 10% maximum loss
- **Auto-stop**: Trading paused when limits exceeded

### Safety Features
- Cooldown after consecutive losses
- No revenge trading behavior
- Emergency kill switch
- Automatic position closure on errors

## 📈 Performance Tracking

### Key Metrics
- **Win Rate**: Percentage of profitable trades
- **Profit Factor**: Gross profit / Gross loss
- **Sharpe Ratio**: Risk-adjusted returns
- **Maximum Drawdown**: Largest peak-to-trough decline
- **Average Trade**: Mean profit per trade

### Trade Journal
All trades are logged with:
- Entry/exit prices and times
- Strategy and timeframe used
- Market conditions and regime
- Risk metrics and confidence scores
- Performance attribution

## 🔧 Customization

### Adding New Indicators
```python
# In src/indicators/custom.py
class CustomIndicators:
    def your_indicator(self, data, period=14):
        # Your indicator logic
        return result
```

### Custom Strategies
```python
# In src/strategy/engine.py
async def _analyze_timeframe(self, df, timeframe):
    # Add your custom analysis logic
    pass
```

### Risk Management Rules
```python
# In src/risk/manager.py
async def evaluate_signal(self, signal_data):
    # Add custom risk checks
    pass
```

## 🧪 Testing & Backtesting

### Paper Trading
Always start with paper trading:
```bash
# Paper trading is enabled by default
python -m src.main --config config/config.yaml
```

### Backtesting (Future Feature)
```bash
# Run backtest on historical data
python -m src.backtest --strategy smart_money --start-date 2023-01-01
```

## 🚀 Deployment

### Cloud Deployment

#### AWS ECS
```bash
# Build and push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
docker build -t crypto-trading-bot .
docker tag crypto-trading-bot:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/crypto-trading-bot:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/crypto-trading-bot:latest
```

#### Google Cloud Run
```bash
gcloud run deploy crypto-trading-bot \
  --image gcr.io/your-project/crypto-trading-bot \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Production Considerations
- Use environment variables for sensitive data
- Set up monitoring and alerting
- Configure log aggregation
- Implement backup strategies
- Use encrypted storage for API keys

## 📚 Documentation

### API Reference
- `GET /api/status` - Bot status
- `GET /api/performance` - Performance metrics
- `GET /api/positions` - Current positions
- `GET /api/trades` - Trade history
- `POST /api/control/pause` - Pause trading
- `POST /api/control/resume` - Resume trading

### WebSocket Events
```javascript
// Real-time updates
{
  "timestamp": "2024-01-01T12:00:00Z",
  "status": {...},
  "performance": {...},
  "positions": {...},
  "risk": {...},
  "market": {...}
}
```

## 🔍 Troubleshooting

### Common Issues

#### Connection Problems
```bash
# Check bot logs
docker-compose logs trading-bot

# Test API connection
python -c "from pybit.unified_trading import HTTP; print('Connected' if HTTP(testnet=True).get_server_time()['retCode'] == 0 else 'Failed')"
```

#### Performance Issues
- Reduce number of timeframes analyzed
- Increase analysis interval
- Disable non-essential features

#### Risk Management
- Check drawdown limits configuration
- Verify position sizing calculations
- Review stop loss placement

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

## ⚠️ Disclaimer

**IMPORTANT**: This trading bot is for educational and research purposes only. Trading cryptocurrencies involves substantial risk of loss. Past performance does not guarantee future results. Always start with paper trading and never risk more than you can afford to lose.

### Risk Warnings
- Cryptocurrency trading is highly volatile
- Leverage trading amplifies both gains and losses
- Market conditions can change rapidly
- Technical failures can result in losses
- Regulatory changes may affect trading

### Safety Guidelines
1. **Always use paper trading first**
2. **Start with minimal capital**
3. **Never risk more than 1-2% per trade**
4. **Monitor the bot continuously**
5. **Have an emergency plan**

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Bybit API](https://bybit-exchange.github.io/docs/) for market data and execution
- [TA-Lib](https://mrjbq7.github.io/ta-lib/) for technical indicators
- [scikit-learn](https://scikit-learn.org/) for machine learning
- [FastAPI](https://fastapi.tiangolo.com/) for web framework

---

**⚠️ Trade Responsibly**: This bot does not guarantee profits. Use at your own risk.