# win-vm

A throwaway **Windows VM** that runs in GitHub Actions and is started with the
`gh` CLI. No local virtualization, no credit card, no Windows license needed —
GitHub hosts the VM and gives you an Administrator shell.

```text
gh workflow run windows-vm.yml --repo fundedakosh1-lang/win-vm
```

## What you get

Each run provisions a fresh VM from the `windows-2022` runner image:

| | |
|---|---|
| OS | Windows Server 2022 (x64) |
| CPU / RAM | 4 vCPU / 16 GB |
| Disk | 14 GB SSD (`C:`) |
| Shell | PowerShell 7, plus bash via Git Bash and MSYS2 |
| User | Administrator |

Preinstalled on the image: Git, GitHub CLI, Node 22, Python 3.12, Go, Chrome,
Edge, Firefox, VS Build Tools, Docker, Chocolatey, `winget`, MSYS2, and more.

The VM lasts for the `keepalive` window (default 60 minutes, max 350) and is
destroyed when the job ends. Nothing persists between runs.

## Usage

Start the VM:

```bash
gh workflow run windows-vm.yml --repo fundedakosh1-lang/win-vm
```

Follow the run and see the printed VM identity:

```bash
gh run watch --repo fundedakosh1-lang/win-vm --exit-status
```

Start it with a longer lifetime and extra apps:

```bash
gh workflow run windows-vm.yml --repo fundedakosh1-lang/win-vm \
  -f keepalive=180 \
  -f install=Microsoft.PowerShell,Git.Git
```

Stop the VM early — cancel the run:

```bash
gh run cancel <run-id> --repo fundedakosh1-lang/win-vm
```

Or list runs and copy a run id:

```bash
gh run list --repo fundedakosh1-lang/win-vm
```

## Inputs

| Input | Default | Meaning |
|---|---|---|
| `keepalive` | `60` | Minutes to keep the VM alive (1–350). |
| `install` | *(empty)* | Comma-separated `winget` package IDs to install. |
| `install_git` | `false` | Reinstall/upgrade Git for Windows via `winget`. |

## Notes

- The runner is a **build agent**, not a desktop. There is no interactive
  Windows Explorer session; you get a shell. For a GUI, use
  [`mxschmitt/action-tmate`](https://github.com/mxschmitt/action-tmate) on
  Linux instead.
- The public tmate servers were shut down in 2025, so the tmate route needs a
  self-hosted server. See the repo's issues if you want an interactive session
  on Windows.
- `gh` here authenticates the GitHub CLI inside the VM. Runs are yours; keep
  the repo public and do not commit secrets.

## Files

- `.github/workflows/windows-vm.yml` — the workflow (the VM definition).
- `scripts/` — helper scripts used by the workflow.
