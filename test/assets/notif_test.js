// @ts-check

import assert from "node:assert/strict";
import test from "node:test";

// Evaluate the app singleton first, the way application.js does: the asset
// modules import each other in cycles and only initialise cleanly in that
// order.
import "../../assets/javascripts/app/app.js";
import { Notif } from "../../assets/javascripts/views/misc/notif.js";
import { News } from "../../assets/javascripts/views/misc/news.js";
import { Tip } from "../../assets/javascripts/views/misc/tip.js";
import { Updates } from "../../assets/javascripts/views/misc/updates.js";

// A notification merges its subclass's `defaultOptions` over the base class's.
// Tip and Updates used to declare `defautOptions` (the name misspelled), so the
// base class never saw the override and both fell back to Notif's 15s
// auto-hide: a tip dismissed itself even though it is meant to stay up until it
// is clicked, and the updates notice hid in half its intended 30s.
test("each notification keeps its own auto-hide default", () => {
  assert.equal(Notif.defaultOptions.autoHide, 15000);
  assert.equal(News.defaultOptions.autoHide, 30000);
  assert.equal(Updates.defaultOptions.autoHide, 30000);
  assert.equal(Tip.defaultOptions.autoHide, false);
});
