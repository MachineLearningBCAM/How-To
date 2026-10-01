# Direct connection to hyperion

The idea is to configure an SSH alias so you do not have to type the username, the full host, or the key path every time.

This is just required for Codex or for integrating it in your IDE, but not for Claude Code. Nevertheless, is good to have it in general. 

## 1. Create an SSH key

If you do not have an SSH key yet, you can create one with:

```
ssh-keygen -t ed25519
```

## 2. Copy the public key to the server

If you know your username and the actual Hyperion hostname:

```
ssh-copy-id your_username@hyperion.sw.ehu.es
```

If `ssh-copy-id` does not work, you can do it manually:

```
cat ~/.ssh/id_ed25519.pub
```

Copy the output and add it on the server to the file:

```
~/.ssh/authorized_keys
```

## 3. Create the `ssh hyperion` alias

Edit or create the file:

```
nano ~/.ssh/config
```

Add an entry like this:

```
Host hyperion
    HostName hyperion.sw.ehu.es
    User your_username
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 10m
```

Then you can connect with:

```
ssh hyperion
```

# Install npm

This is just required for Codex or for integrating it in your IDE, but not for Claude Code. Nevertheless, is good to have it in general. 

To install **Node.js and npm** across different operating systems, using a **Version Manager** is highly recommended. It allows you to switch versions easily and avoids permission errors.

Here is how to install it on Windows, macOS, and Linux.

---

## **💻 Windows**

## **Method 1: Using nvm-windows (Recommended)**

1. Download the `nvm-setup.exe` file from the nvm-windows releases page.
2. Run the installer and follow the prompts.
3. Open a new Command Prompt or PowerShell window as **Administrator** and run:
    
    ```bash
    nvm install lts
    nvm use lts
    ```
    

## **Method 2: Official Installer**

1. Download the Windows Installer (`.msi`) from the official [Node.js website](https://nodejs.org/).
2. Run the installer and accept the defaults (ensure the "Add to PATH" option is checked).

---

## **🍏 macOS**

## **Method 1: Using nvm (Recommended)**

1. Open your Terminal and run the install script:
    
    ```bash
    curl -o-https://githubusercontent.com | bash
    ```
    
2. Restart your terminal or run `source ~/.zshrc` (or `source ~/.bash_profile`).
3. Install the latest stable version:
    
    ```bash
    nvm install --lts
    ```
    

## **Method 2: Using Homebrew**

1. If you use the Homebrew package manager, simply run:
    
    ```bash
    brew install node
    ```
    

---

## **🐧 Linux (Ubuntu / Debian / Fedora)**

## **Method 1: Using nvm (Recommended for all distributions)**

1. Open your terminal and run the install script:
    
    ```bash
    curl -o-https://githubusercontent.com | bash
    ```
    
2. Restart your terminal or run `source ~/.bashrc`.
3. Install Node.js and npm:
    
    ```bash
    nvm install --lts
    ```
    

## **Method 2: Using NodeSource (Native Package Manager)**

If you prefer standard system packages on Ubuntu/Debian:

1. Run the NodeSource setup script for the current LTS version:
    
    ```bash
    curl -fsSLhttps://nodesource.com | sudo -E bash -
    ```
    
2. Install Node.js:
    
    ```bash
    sudo apt-get install -y nodejs
    ```
    

---

## **🔍 Verify the Installation**

No matter which OS or method you used, close and reopen your terminal, then run these commands to ensure everything is working:

- `node -v`
- `npm -v`

If both commands return a version number, your installation is complete.

# **Connecting Codex to the Hyperion Cluster via SSH**

This guide provides a step-by-step walkthrough to link your local **Codex session** (or PyCharm AI Assistant) to your remote **hyperion** cluster using the Model Context Protocol (MCP).

The agent runs locally on your machine and uses your pre-existing SSH keys to safely securely pass commands to the cluster. No installation is required on the remote `hyperion` machine.

---

# **📋 Prerequisites**

Before you start, make sure you have:

1. **Node.js** installed on your local computer.
2. An active **SSH Key** set up for passwordless login to `hyperion`.

---

# **🛠️ Step-by-Step Installation**

### **Step 1: Install the Local SSH-MCP Server**

The MCP server acts as an adapter on your laptop. It translates Codex's human conversational phrasing into programmatic SSH strings.

Run this command in your local terminal to install the bridging utility:

```
npm install -g @zibdie/ssh-mcp-server
```

---

### **Step 3: Link the Server to Claude Code/Codex**

Choose the method which is better for you. 

#### **Method A: If using Claude Code**

Go to ClaudeCode. Select Remote in environment and connect to the ssh.  

#### **Method B: If using Codex**

If `codex` is not on `PATH`:

```
alias codex="/Applications/ChatGPT.app/Contents/Resources/codex"
```

Configure MCP (only if chatty cannot write in the cache):

```
mkdir -p /tmp/codex-npm-cache

codex mcp add hyperion-ssh \
  --env npm_config_cache=/tmp/codex-npm-cache \
  -- npx @zibdie/ssh-mcp-server --host hyperion
```

Check it:

```
codex mcp list
codex mcp get hyperion-ssh
```

And then ask chatty if it can access hyperion (it will finalize the configs itself)

#### **Method C: If using PyCharm (JetBrains AI Chat)**

If you interact with Codex via PyCharm's AI chat window, add the server through the system UI:

1. Open PyCharm and go to **Settings** ➡️ **Tools** ➡️ **AI Assistant** ➡️ **Model Context Protocol (MCP)**.
2. Click **Add (`+`)** and select **STDIO**.
3. Paste the following JSON initialization script into the block:`{"mcpServers": {"hyperion-ssh": {"command": "npx","args": ["-y", "@zibdie/ssh-mcp-server"],"env": {"SSH_HOST": "hyperion"}}}}`
4. Click **Apply** and close the panel.

---

# **🚀 Step 4: Verification & Usage**

Open a fresh Codex chat session or type `/mcp` inside your active prompt line to confirm the server initialized successfully.

You can now use phrases like:

- "Check if my batch training jobs are still running on hyperion."
- "List the files inside my scratch folder on the cluster."
- "Show me the tail logs of the active service running on hyperion."