# Agent Skills Repository

This repository contains portable, reusable skills for coding agents.

## Mandatory sanitization before adding a skill

Before adding or updating any skill, remove personal, private, and
environment-specific information. This is a hard requirement, not an optional
cleanup step.

Do not commit:

- real names, usernames, email addresses, home-directory paths, tokens, keys,
  credentials, or private URLs;
- names of personal machines, hosts, servers, networks, VPNs, services, or
  internal projects;
- personal locations, employers, customer information, repository URLs, or other
  identifying context;
- copied logs, screenshots, configuration fragments, or examples that expose the
  information above.

Generalize infrastructure and personal context. Replace machine names with roles
such as `router`, `workstation`, `build-host`, `application-server`, or
`storage-node`. Replace real project and service names with neutral role-based
names. Use placeholders only when they preserve the meaning of the workflow.

After sanitization, verify that the skill still describes a reusable decision
process rather than a personal setup. Do not merely redact names: remove
assumptions that make the skill depend on one person's environment.

## Skill requirements

- Each skill lives in its own directory under `skills/`.
- Each skill has a `SKILL.md` with YAML frontmatter containing `name` and
  `description`.
- The `name` is lowercase kebab-case and matches the skill directory name.
- Keep `SKILL.md` concise. Move substantial explanations and references into
  `references/`.
- Preserve attribution, licenses, and upstream links for adapted or external
  material.
- Validate changed skills before committing them.

## Development flow

This repository intentionally has a small Nix flake. It formats Markdown files
only and uses the Git hook builder from `nix-devtools`.

- Run `nix fmt` to format Markdown files.
- Run `nix run .#install-git-hooks` once to install the pre-commit hook.
- The pre-commit hook runs the formatter in check mode and does not perform
  unrelated checks or builds.

## Review checklist

For every skill addition or update:

1. Identify whether the content is original, adapted, or copied from an external
   source.
2. Remove personal and environment-specific data using the sanitization rules
   above.
3. Check that the description clearly states when the skill applies.
4. Check that references are linked from `SKILL.md` and are loaded only when
   relevant.
5. Check for secrets, identifying strings, copied credentials, and accidental
   local paths.
6. Validate the skill structure and inspect the final diff before committing.
