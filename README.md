# NitroGen BizHawk AI Agent

[![CI](https://github.com/artryazanov/nitrogen-bizhawk-ai-agent/actions/workflows/ci.yml/badge.svg)](https://github.com/artryazanov/nitrogen-bizhawk-ai-agent/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This repository contains a lightweight Lua script for the **BizHawk** emulator, enabling the **NitroGen** neural network model to control gameplay in real-time.

## 🚀 Features

* **Direct Integration**: Works via TCP sockets with [NitroGen Server](https://github.com/artryazanov/nitrogen-server).
* **Console Support**: Mappings configured for **NES** and **SNES**.
* **Low Latency**: The script captures screenshots and immediately applies predicted actions.

## 📋 Requirements

1. [BizHawk Emulator](https://tasvideos.org/BizHawk) (v2.9+ recommended, uses Lua 5.4).
2. Running [NitroGen Server](https://github.com/artryazanov/nitrogen-server) (usually on port `5556`).
3. Installed `Luarocks` package (if you want to run tests locally).

## 🛠 Installation & Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/artryazanov/nitrogen-bizhawk-ai-agent.git
   ```

2. **Configure the console**: Open `bizhawk_ai_agent.lua` and set the `CONSOLE_TYPE` variable to "NES" or "SNES" depending on your game.

3. **Start the server**: Ensure your NitroGen server is running and ready to accept TCP connections on port `5556`.

4. **Run the script in BizHawk**:
   - Open BizHawk and load a ROM.
   - Go to **Tools -> Lua Console**.
   - Select **Script -> Open Script** and open `bizhawk_ai_agent.lua`.

## ⚙️ Configuration
You can modify the following parameters at the beginning of the script:

* `HOST`: Server IP address (default `127.0.0.1`).
* `PORT`: Server TCP port (default `5556`).
* `TEMP_IMG_FILE`: Name of the temporary file for screenshot transfer.

## 🧪 Testing
The project includes unit tests using the **LuaUnit** framework (vendored in `tests/luaunit.lua`).

1. **Install Lua**:
   Ensure you have Lua installed (Lua 5.4 is recommended for compatibility with BizHawk 2.9+).
   ```bash
   sudo apt install lua5.4  # Debian/Ubuntu
   # or similar for your OS
   ```

2. **Run tests**:
   ```bash
   lua tests/test_bizhawk_agent.lua
   ```

Tests verify the correctness of JSON extraction and button mapping logic without needing to launch the emulator itself.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.