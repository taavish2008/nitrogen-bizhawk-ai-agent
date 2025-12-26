# NitroGen BizHawk AI Agent

[![CI](https://github.com/artryazanov/nitrogen-bizhawk-ai-agent/actions/workflows/ci.yml/badge.svg)](https://github.com/artryazanov/nitrogen-bizhawk-ai-agent/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Lua 5.4](https://img.shields.io/badge/Lua-5.4-blue.svg)](https://www.lua.org/versions.html#5.4)
[![BizHawk 2.9+](https://img.shields.io/badge/Platform-BizHawk%202.9%2B-red.svg)](https://tasvideos.org/BizHawk)

This repository contains a lightweight Lua script for the **BizHawk** emulator, enabling the **NitroGen** neural network model to control gameplay in real-time.

## 🚀 Features

*   **Native .NET Integration**: Uses system .NET libraries directly within BizHawk (Lua + CLR) — no external Lua DLLs required!
*   **Smart Trajectory Handling**: Receives and executes multi-frame action sequences from the AI for smoother, less jittery gameplay.
*   **Direct Integration**: Works via TCP sockets with [NitroGen Server](https://github.com/artryazanov/nitrogen-server).
*   **Console Support**: Mappings automatically detected for **NES** and **SNES**.

## 📋 Requirements

### Runtime (for running the agent)
1.  [BizHawk Emulator](https://tasvideos.org/BizHawk) (v2.9+ recommended).
2.  Running [NitroGen Server](https://github.com/artryazanov/nitrogen-server).

### Development (for running tests)
1.  Lua 5.4 (e.g., `sudo apt install lua5.4`).
2.  [Luarocks](https://luarocks.org/) (for installing testing dependencies like `luacheck`).

## 🛠 Installation & Usage

1.  **Get the script**:
    *   **Option A (Recommended)**: Clone the repository to keep up with updates:
        ```bash
        git clone https://github.com/artryazanov/nitrogen-bizhawk-ai-agent.git
        ```
    *   **Option B (Simple)**: Just download [bizhawk_ai_agent.lua](https://raw.githubusercontent.com/artryazanov/nitrogen-bizhawk-ai-agent/main/bizhawk_ai_agent.lua) to your computer.

2.  **Start the server**:
    Ensure your NitroGen server is running and listening on port `5556`.

3.  **Run the script**:
    - Open BizHawk and load a ROM.
    - Go to **Tools -> Lua Console**.
    - **Script -> Open Script...** -> Select `bizhawk_ai_agent.lua`.
    - The bot should connect, automatically detect the system (NES/SNES), and start playing.

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