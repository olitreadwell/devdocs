// @ts-check

import assert from "node:assert/strict";
import test from "node:test";

import { Searcher } from "../../assets/javascripts/app/searcher.js";

// Search normalizes both the entries (normalizeString) and the query
// (normalizeQuery) to the same lowercased, dot-collapsed form, so a query
// matches an entry whose name differs only in punctuation or case. The rules
// are subtle and have no other direct coverage, so they're locked down here.

test("normalizeString lowercases and collapses dots and punctuation to dots", () => {
  assert.equal(
    Searcher.normalizeString("Array.prototype.map"),
    "array.prototype.map",
  );
  assert.equal(Searcher.normalizeString("String.prototype.slice"), "string.prototype.slice");
  assert.equal(Searcher.normalizeString("foo::bar"), "foo.bar");
  assert.equal(Searcher.normalizeString("foo -> bar"), "foo.bar");
  assert.equal(Searcher.normalizeString("foo bar"), "foo.bar");
});

test("normalizeString strips the decoration a documentation name may carry", () => {
  assert.equal(Searcher.normalizeString("console.log (class)"), "console.log");
  assert.equal(Searcher.normalizeString("CSS.calc()"), "css.calc");
  assert.equal(Searcher.normalizeString("foo...bar"), "foobar");
  // Only the "event" suffix is dropped; a method that contains the letters is
  // not truncated.
  assert.equal(Searcher.normalizeString("foo event"), "foo");
  assert.equal(Searcher.normalizeString("addEventListener"), "addeventlistener");
});

test("normalizeString leaves a language's own characters alone", () => {
  // A plus is not a separator, so C++ stays searchable as-is.
  assert.equal(Searcher.normalizeString("C++"), "c++");
  // A hash becomes a dot, matching the doc's normalized name.
  assert.equal(Searcher.normalizeString("C#"), "c.");
  // Underscores and forward slashes are left untouched.
  assert.equal(Searcher.normalizeString("a.b_c.d"), "a.b_c.d");
  assert.equal(Searcher.normalizeString("foo/bar"), "foo/bar");
});

test("normalizeQuery keeps a trailing separator meaningful", () => {
  assert.equal(Searcher.normalizeQuery("array#"), "array.");
  assert.equal(Searcher.normalizeQuery("foo:"), "foo.");
  assert.equal(Searcher.normalizeQuery("c++"), "c++");
});

test("a query of only whitespace normalizes to the invalid dot", () => {
  assert.equal(Searcher.normalizeQuery(" "), ".");
});
