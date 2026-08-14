# Fabric Minecraft Server

A Dockerized Fabric Minecraft server (1.20.1), built from a small Java base image without using a prebuilt Minecraft image.

## Table of Contents

- [Quickstart](#quickstart)
- [Project Goal](#project-goal)
- [Usage](#usage)
- [Additional Files](#additional-files)

## Quickstart

### Prerequisites

- Docker
- Docker Compose

### Steps

Clone the repository and move into the project folder:

```bash
git clone https://github.com/Gerth123/minecraft.git
cd minecraft
```

Build and start the server:

```bash
docker compose up -d --build
```

The first build installs Java dependencies and downloads the Fabric server, so it takes a few minutes. Once it's done, connect with a Minecraft Java Edition client (version 1.20.1) to `<your-vm-ip>:8888`, or verify it's reachable with [mcstatus](https://github.com/py-mine/mcstatus):

```bash
mcstatus <your-vm-ip>:8888 status
```

## Project Goal

This repository packages a Minecraft server (Fabric loader) as a Docker image, built from a small Java base image rather than a prebuilt Minecraft image. The `docker-compose.yaml` runs the built image as the `mc-server` service, exposes it on port 8888, and persists the server files and world save in a Docker volume so nothing is lost on restart. Runtime configuration (accepting the EULA, memory allocation) happens in `entrypoint.sh`, keeping the `Dockerfile` itself focused on building the image.

## Usage

The JVM memory allocation is configured through the `MEMORY` environment variable in `docker-compose.yaml`, with a default of `2G`. To change it, either edit the default value directly in `docker-compose.yaml`, or copy `.env.example` to `.env`, set `MEMORY` to your desired value in that file, then rebuild:

```bash
cp .env.example .env
docker compose up -d --build
```

Docker Compose automatically picks up values from `.env` and uses them in place of the default, without you needing to touch the tracked `docker-compose.yaml`. `.env` itself is git-ignored, so local overrides never end up in the repository.

The Minecraft version and Fabric loader version are set directly in the `RUN` command of the `Dockerfile` (currently Minecraft 1.20.1, Fabric loader 0.19.3). To use a different version, edit the version numbers in that line and rebuild.

The server files, world save, and configuration are stored in the named Docker volume `mc-data`, mounted at `/server` inside the container. This means the world and any manual configuration changes survive container restarts and rebuilds.

Fabric automatically creates a `mods` folder at `/server/mods` on first start. Since that folder lives inside the persistent volume, mods added to it survive restarts too. To add a mod, download a `.jar` file compatible with Minecraft 1.20.1 and Fabric (most mods also require the "Fabric API" mod as a dependency) from [modrinth.com](https://modrinth.com), then copy it into the running container and restart:

```bash
docker cp your-mod.jar mc-server:/server/mods/
docker compose restart mc-server
```

## Additional Files

- `docs/Minecraft Server Checkliste.pdf`: the official project checklist provided by Developer Akademie, kept here for reference during development. It is not part of the application itself.
- `.env.example`: a template showing which variables can be set in a local `.env` file (currently just `MEMORY`). Copy it to `.env` and adjust values there; `.env` itself is git-ignored.
- `entrypoint.sh`: the container's startup script. It accepts the Minecraft EULA and starts the Fabric server with the configured memory allocation.