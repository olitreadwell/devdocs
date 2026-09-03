# freeCodeCamp/devdocs context
> refreshed 2026-09-03 | upstream default: main @ 77abbf24

## Identity & policies
- upstream: freeCodeCamp/devdocs, default branch main, primary language Ruby (Sinatra) + vanilla JS frontend, English-first (yes).
- CLA/DCO: none found (CONTRIBUTING has no CLA/signup requirement; recent external PRs merged without sign-up).
- AI-assisted PR policy: unstated (no ban, no disclosure requirement).
- signed commits required: no (branch protection none found).
- PR template: `.github/PULL_REQUEST_TEMPLATE.md` — section A (new scraper) / section B (docs version update checklists); no generic section.
- external tracker: GitHub issues; docs updates tracked via bot "Documentation versions report" issues.
- CONTRIBUTING present (`.github/CONTRIBUTING.md`): issue-first for significant PRs, small simple PRs encouraged, squash commits "when it makes sense", docs-content PRs must fill the section-B checklist (only for version-update PRs).

## Conventions (verified)
- branch naming: mixed / no dominant pattern across merged PRs — doc-name branches (`har`, `pytest`, `tokio`, `rabbitmq`, `celery`, `odin`) and fix-name branches (`fix-url-search-plus-hash`, `fix/retry-failed-downloads`, `no-twitter`, `initial_path`). No clear convention → fall back to `type/kebab-description`.
- test/lint/CI: CI = `.github/workflows/test.yml` runs `bundle exec rake` (Ruby, require all `test/**/*_test.rb`) on PR to main. No separate lint step.
- merge behaviour: outside PRs get merged; recent examples include docs/scraper additions (tokio, pytest, mapLibre GL, celery) and repo-hygiene fixes (remove twitter references, fix broken version checkers). Responsive maintainers.
- icon + sprites: icons live at `public/icons/docs/<slug>/` (16.png + 16@2x.png + SOURCE), read by `lib/tasks/sprites.thor`.

## Maintainer picture
- Team `@freeCodeCamp/devdocs` (CODEOWNERS * -> @freeCodeCamp/devdocs); active maintainers include simon04, jmerle, j-f1, ojeytonwilliams; Discord available.
- Actively shipping new scrapers + doc updates + infra hygiene fixes.

## Issue-area health
- No contested signals observed for docs-content/typo-level work. Big redesigns (e.g. cursor/editor) are out of scope for trivial work.
- Docs content is scraped/generated from third-party sources — never edit `public/docs/**`; the repo's own editable content is `README.md`, `docs/*.md`, scrapers/filters (`lib/`), views/assets.

## Gap ledger (dedupe)
- `2026-08-24` — dropped-no-tractable-issue (wheelhouse thin; shortcut/UI issues not reproducible). Lesson: docs-content bundle is the bread-and-butter for the trivial loop.
- `2026-09-03` — trivial doc cleanup PR: broken `lib/docs/scrapers/minitest.rb` link → `lib/docs/scrapers/rdoc/minitest.rb`; stale `openjdk-16-jre-headless` → `openjdk-$VERSION-jre-headless` (2 lines); typos `runned→run`, `can modified→can be modified`, `to modified→to modify` (scraper-reference.md). Outcome: pr-opened.

## Mined gaps (discovered, not yet attempted)
- `2026-09-03` — no further verified trivial gaps found after full repo scan (external links 200, thor commands all present, docs path refs correct). Next trivial pass: re-check after scrapers/docs churn.
