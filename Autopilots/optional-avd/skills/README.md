# Importable skills

Two AI agent skills for this kit, in the [Agent Skills](https://agentskills.io/specification.md) open format (`SKILL.md` with YAML frontmatter). The same format is used by Microsoft Scout, Copilot Cowork, GitHub Copilot CLI, VS Code, Claude Code, and others.

| Skill | What it does | Needs a terminal? |
|---|---|---|
| [`frontier-scout-avd`](frontier-scout-avd/) | **Deploys** the environment. Drives `deploy.ps1` and the scripts in this kit. | **Yes.** Azure CLI, Owner on the subscription. |
| [`scout-avd-advisor`](scout-avd-advisor/) | **Plans, costs, documents, and diagnoses.** Decision briefs, readiness checklists, onboarding guides, symptom triage. | **No.** Runs anywhere. |

## Why two skills and not one

They share a file format but not a runtime, so one skill cannot serve both hosts honestly.

| | Microsoft Scout / Copilot CLI | Copilot Cowork |
|---|---|---|
| Local filesystem | Yes | **No.** OneDrive and SharePoint only |
| Shell / Azure CLI | Yes | **No** documented terminal |
| Execution model | Local machine | Temporary isolated sandbox in the M365 service boundary |
| Authoring guidance | — | *"Don't hardcode file paths or system commands"* |

`frontier-scout-avd` is built entirely on `az` commands, `az vm run-command`, and local script paths. Dropping it into Cowork would produce a skill that confidently issues instructions it cannot carry out. `scout-avd-advisor` covers the same subject matter within what Cowork can actually do: it reasons, plans, and writes documents, and it hands off execution explicitly.

If you only want one, pick by whether your host has a terminal.

## Import into Microsoft Scout

Copy the skill folder to your Scout skills directory, keeping the folder name identical to the `name` in the frontmatter:

```
~/.scout/m-skills/frontier-scout-avd/SKILL.md
~/.scout/m-skills/scout-avd-advisor/SKILL.md
```

On Windows that is `%USERPROFILE%\.scout\m-skills\`. Restart Scout, or start a new session, and invoke with `/frontier-scout-avd`.

## Import into Copilot Cowork

Any one of these works.

**OneDrive folder drop.** Copy the skill folder to `/Documents/Cowork/skills/` in OneDrive, for example `/Documents/Cowork/skills/scout-avd-advisor/SKILL.md`. Cowork discovers custom skills automatically at the start of each session.

**UI upload.** Choose **+** → **Customize** → **Skills** → **Add** → **Upload skill**, then upload either the `SKILL.md` on its own or a `.zip` with `SKILL.md` at the archive root.

**Plugin package.** For wider distribution, reference the skill folder from an M365 Unified App Manifest and publish through the admin center or App Store:

```json
"agentSkills": [ { "folder": "./skills/scout-avd-advisor" } ]
```

Cowork limits: 50 custom skills per user, 1 MB per `SKILL.md`, 20 companion files, 10 MB per skill. Custom skills are not supported on mobile.

> `scout-avd-advisor` is the one to import into Cowork. `frontier-scout-avd` will load, but it depends on a shell that Cowork does not provide.

## Import into GitHub Copilot CLI or VS Code

```
~/.copilot/skills/<skill-name>/SKILL.md
```

## Import into Claude Code or other Agent Skills hosts

The folders are already in the standard layout. Copy them into whatever skills directory the host uses. No conversion needed.

## Authoring notes

If you edit these, keep them valid:

- `name` must be **kebab-case, 1 to 64 characters, and match the folder name exactly**. A mismatch is the most common cause of a skill failing to load.
- `description` must be **1 to 1024 characters** and should contain explicit trigger phrases. A description over the limit means the skill never loads at all.
- Keep the body under roughly 5,000 tokens. Push detail into a `references/` subfolder, which is loaded only on demand.
- Do not embed secrets, tenant IDs, or object IDs. Everything environment-specific in these two skills is a `<PLACEHOLDER>`.
