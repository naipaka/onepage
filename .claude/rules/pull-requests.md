# Pull Request Guidelines

## Before Writing a PR

- **Template**: Start from `.github/pull_request_template.md` and follow the sections and conventions below
- **Language**: Always English (code, PR body, commit messages)
- **Never link to external GitHub repositories** in PR bodies, comments, or commit messages
  - GitHub creates permanent "mentioned this pull request" cross-references that cannot be deleted
  - Reference external repos by name/version in plain text only
  - Never use `org/repo#123` syntax or full GitHub URLs to external repos
  - Internal references (e.g., `#251`) are fine

## Required Sections

All PR bodies must include these sections:

```
## What's Done
## What's Not Done
## Additional Notes
## Image Differences
## Pre-launch Checklist
```

- **What's Not Done**: Write "None" if nothing is pending
- **Additional Notes**: Write "None" if no notes
- **Image Differences**: Write "None (description of change type, no UI changes)" if no UI changes
- **Pre-launch Checklist**: Always include `- [x] I have reviewed my own code (e.g., updated tests and documentation)`
- Do not skip sections regardless of PR size
- Write the section headings exactly as above, without emoji

## Writing the Sections

- **Related issue**: Put `Part of #123.` or `Closes #123.` on the first line, above the sections
- **What's Done**: One bullet for each change, starting with a verb in the present tense (Add, Remove, Keep). Put details in nested bullets
- **Additional Notes**:
  - Explain each reason under its own `### Why ...` heading
  - End with `### Verification`, listing each command with its result after `→` (e.g., `fvm dart analyze` → No issues found!)
  - For checks on a device, name the device, the OS version, and the build (e.g., iOS 27.2 simulator (dev, debug)), then what was checked
- **Image Differences**: For UI changes, add the Before and After screenshots in the table of the template, or describe the change when a screenshot cannot show it

## Attribution

- Never add "Generated with Claude Code" or any AI attribution to PR bodies

## After a PR Is Merged

When the user says a PR was merged, clean up before starting anything else:

1. Leave the worktree session.
2. Run `git checkout main` in the main checkout.
3. Run `git pull --rebase origin main`.
4. Run `gh poi` to delete the local branches whose PRs are merged.
5. Remove the merged PR's worktree if it is still there, and check with `git worktree list`.
