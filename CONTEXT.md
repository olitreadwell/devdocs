# freeCodeCamp/devdocs context
> refreshed 2026-09-09 | upstream default: main @ 0f9111bc

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
- `2026-09-09` — trivial doc cleanup PR (fork #5): dead `www.rubydoc.info/.../Nokogiri/XML/Node` links → `https://nokogiri.org/rdoc/Nokogiri/XML/Node.html` (2×, filter-reference.md); typos `can't reached→can't be reached` (filter-reference.md), `as follow→as follows` (maintainers.md), `miss-formatted→mis-formatted` (documentation_bug.md). Outcome: pr-opened.
- `2026-09-08` — issue #2728 (scoped external-search shortcuts throw) is real + verified in current code (const reassignment in `Search#externalSearch`), but ALREADY CLAIMED by open PR #2729 (dajiaohuang, opened 2026-09-08). Dropped — do not duplicate. Other open issues not maintainer-engaged (#2634 unreproducible on macOS, #2557 maintainer spamguy can't reproduce, #2322 claimed by open PR #2200, #2525/#2615 no maintainer response). No maintainer-engaged open issue survives → repo-audit self-found gap.
- `2026-09-09` — trivial cleanup PR (fork #7): broken `http://nokogiri.org/Nokogiri/XML/Node.html` link → `https://nokogiri.org/rdoc/Nokogiri/XML/Node.html` (scraper-reference.md, verified 404→200); typos `managment→management` (redis/entries.rb, user-facing type label), `mispelled→misspelled` (eslint/entries.rb comment), `clases→classes` (pandas/clean_html.rb comment), `aswell→as well` (updates.thor comment). Outcome: pr-opened. Deduped against open PR #2725 (covers only scraper-reference.md lines 87/189/204/284 + file-scrapers.md — not line 88) and fork PR #5.

## Mined gaps (discovered, not yet attempted)
- `2026-09-03` — no further verified trivial gaps found after full repo scan (external links 200, thor commands all present, docs path refs correct). Next trivial pass: re-check after scrapers/docs churn.
- `2026-09-09` — after this pass, remaining candidates judged non-actions: `rubydoc.info` fully replaced by nokogiri.org/rdoc; remaining prose is clean. Open upstream PR #2725 still covers only scraper-reference.md + file-scrapers.md (do not re-do; re-check its merge state next pass).
- `2026-09-08` — CI gap: `test/assets/search_hash_test.js` (Node, added PR #2695) is never run in CI; `.github/workflows/test.yml` only runs `bundle exec rake`. Repro: `node --test test/assets/search_hash_test.js` passes locally (2/2), but no workflow invokes it. Expected: CI runs the JS test so search-hash regressions are caught. Proposed fix: add a `node --test test/assets/search_hash_test.js` step/job to test.yml. Dedupe: no upstream issue/PR wires the JS test into CI (PR #2695 merged without it). — status: pr-opened (fork PR #6, 2026-09-08)
- `2026-09-08` — CI gap: `test/assets/search_hash_test.js` never ran in CI. Fix: added `javascript` job to `.github/workflows/test.yml` (`node --test test/assets/search_hash_test.js`), renamed workflow to "Tests". Outcome: pr-opened (fork PR #6, base=fork main, non-draft, CI green: test+javascript both success).
