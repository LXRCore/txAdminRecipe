# txAdminRecipe for LXRCore RedM

This **txAdminRecipe** provides a streamlined deployment process for setting up a RedM server using the **LXRCore** framework. This recipe simplifies the configuration process and allows server administrators to deploy RedM with a robust roleplay framework in just a few steps.

## Requirements

- **txAdmin** installed and running.
- A server directory ready for RedM setup.
- Access to **LXRCore** framework.

## Installation

1. Clone the **LXRCore** repository or download it into your server’s `resources` directory.
2. Follow these steps to set up the recipe for txAdmin:

### Step 1: Recipe Configuration

Add the following configuration to your `txAdmin` setup:

```bash
# txAdmin Recipe for LXRCore RedM Setup

git clone https://github.com/LXRCore/lxr-core.git resources/lxr-core
git clone https://github.com/LXRCore/lxr-safecracker.git resources/lxr-safecracker
git clone https://github.com/LXRCore/lxr-target.git resources/lxr-target
git clone https://github.com/LXRCore/lxr-weaponsync.git resources/lxr-weaponsync
git clone https://github.com/LXRCore/lxr-stable.git resources/lxr-stable

ensure lxr-core
ensure lxr-safecracker
ensure lxr-target
ensure lxr-weaponsync
ensure lxr-stable
```

### Step 2: Configure `server.cfg`

Add the following lines to your `server.cfg` file to ensure proper startup:

```bash
# LXRCore and related resources
ensure lxr-core
ensure lxr-safecracker
ensure lxr-target
ensure lxr-weaponsync
ensure lxr-stable

# Optional settings for additional resources
# Add more custom resources as required
```

### Step 3: Server Settings

Configure your server settings in `server.cfg` as needed for roleplay experiences, weather, and more. Example:

```bash
set sv_maxclients 32
set sv_licenseKey "your-server-key-here"
set sv_hostname "LXRCore RedM Server"
```

## Recipe Overview

This recipe includes all the core resources needed to start a RedM roleplay server with **LXRCore** as the base. It includes the following:

- **LXRCore**: The primary framework for roleplay servers.
- **LXR-Safecracker**: A safe-cracking minigame for immersive gameplay.
- **LXR-Target**: A targeting system for interacting with entities and objects.
- **LXR-WeaponSync**: A weapon handling and synchronization resource for RedM.
- **LXR-Stable**: A stable management system for managing horses and mounts.

## Deployment

After configuring the recipe and server settings, start your txAdmin and enjoy your RedM roleplay server powered by **LXRCore**.

---

This recipe is specifically designed to be a hassle-free, plug-and-play solution for deploying **RedM** servers with **LXRCore**.