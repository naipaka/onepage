# Pull Request Guidelines

## Before Writing a PR

- **Read the full body of at least 5 non-dependabot PRs** to match format, language, section structure, and conventions
  - Use `gh pr view <number> --json body --jq '.body'` for each PR individually — never batch with `head` or truncate output
  - List PRs first, identify non-dependabot ones, then read each body one by one
- **Language**: Always English (code, PR body, commit messages)
- **Never link to external GitHub repositories** in PR bodies, comments, or commit messages
  - GitHub creates permanent "mentioned this pull request" cross-references that cannot be deleted
  - Reference external repos by name/version in plain text only
  - Never use `org/repo#123` syntax or full GitHub URLs to external repos
  - Internal references (e.g., `#251`) are fine

## Required Sections

All PR bodies must include these sections:

```
## 🙌 What's Done
## ✍️ What's Not Done
## 📝 Additional Notes
## 🖼️ Image Differences
## Pre-launch Checklist
```

- **What's Not Done**: Write "None" if nothing is pending
- **Additional Notes**: Write "None" if no notes
- **Image Differences**: Write "None (description of change type, no UI changes)" if no UI changes
- **Pre-launch Checklist**: Always include `- [x] I have reviewed my own code (e.g., updated tests and documentation)`
- Do not skip sections regardless of PR size

## Attribution

- Never add "Generated with Claude Code" or any AI attribution to PR bodies
