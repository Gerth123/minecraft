# Fabric Minecraft Server

## Table of Contents

- [Quickstart](#quickstart)
- [Project Goal](#project-goal)
- [Usage](#usage)
- [Additional Files](#additional-files)

## Quickstart

Follow these steps to get the server running.

1. Install Docker and Docker Compose on your machine or cloud VM.
2. Clone this repository and move into the project folder.
3. Run `docker compose up -d --build` in the project folder.
4. Wait until the container finishes building, this installs Java and the Fabric server, so it takes a few minutes.
5. Connect with a Minecraft Java Edition client (version 1.20.1) to `<your-vm-ip>:8888`.

## Project Goal

This repository packages a Minecraft server (Fabric loader) as a Docker image, built from a plain Ubuntu base image rather than a prebuilt Minecraft or Java image. The `docker-compose.yaml` runs the built image as the `mc-server` service, exposes it on port 8888, and persists the server files and world save in a Docker volume so nothing is lost on restart.

## Usage

The JVM memory allocation is configured through the `MEMORY` environment variable in `docker-compose.yaml`, with a default of `2G`. To change it, either edit the default value directly in `docker-compose.yaml`, or copy `.env.example` to `.env` (`cp .env.example .env`) and adjust the value there. Docker Compose automatically picks up values from `.env` and uses them in place of the default, without you needing to touch the tracked `docker-compose.yaml`. `.env` itself is git-ignored, so local overrides never end up in the repository.

The Minecraft version and Fabric loader version are set directly in the `RUN` command of the `Dockerfile` (currently Minecraft 1.20.1, Fabric loader 0.19.3). To use a different version, edit the version numbers in that line and rebuild.

The server files, world save, and configuration are stored in the named Docker volume `mc-data`, mounted at `/server` inside the container. This means the world and any manual configuration changes survive container restarts and rebuilds.

Fabric automatically creates a `mods` folder at `/server/mods` on first start. Since that folder lives inside the persistent volume, mods added to it survive restarts too. To add a mod, download a `.jar` file compatible with Minecraft 1.20.1 and Fabric (most mods also require the "Fabric API" mod as a dependency), copy it into the running container with `docker cp your-mod.jar mc-server:/server/mods/`, then run `docker compose restart mc-server` so Fabric picks it up.

## Additional Files

- `docs/Minecraft Server Checkliste.pdf`: the official project checklist provided by Developer Akademie, kept here for reference during development. It is not part of the application itself.
- `.env.example`: a template showing which variables can be set in a local `.env` file (currently just `MEMORY`). Copy it to `.env` and adjust values there; `.env` itself is git-ignored.