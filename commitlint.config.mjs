// Open edX commit message linting.
//
// This is the default configuration from openedx/edx-lint
// (edx_lint/files/commitlint.config.js), copied verbatim, plus one addition:
// the GRANDFATHERED_HEADERS allow-list at the top of the `ignores` section.
//
// Keeping a repo-local copy is the documented override for
// openedx/.github/.github/workflows/commitlint.yml, which downloads the shared
// default only when this file is absent.

// Squash-merge commits that landed on `develop` before conventional-commit
// subjects were enforced on merge in this repo. These are published, immutable
// history: they are reachable from `develop`, from release tags and from every
// fork, so they cannot be corrected without rewriting shared history.
//
// Each entry is a complete, exact header line including its PR number. PR
// numbers are never reused, so this list can only ever match these six specific
// historical commits; no future commit can accidentally match it.
//
// Do not add entries here. Fix the commit subject instead.
const GRANDFATHERED_HEADERS = new Set([
  'Fixes:  Assignment thumbnails  count, color coding for assignments in progress, word “Sections” was missing (#649)',
  'Fix: certificates not displayed after being earned (#651)',
  'Replace SwiftMocky with Mockolo for test mocks generation (#652)',
  'Migrate from ObservableObject to @Observable (Swift Observation) (#653)',
  'Fix/issue 581 (#635)',
  'Fix issues 640, 641, 652 (#661)',
]);

const Configuration = {
  extends: ['@commitlint/config-conventional'],

  helpUrl: 'https://open-edx-proposals.readthedocs.io/en/latest/oep-0051-bp-conventional-commits.html',

  rules: {
    'type-enum':
      [2, 'always', [
        'revert', 'feat', 'fix', 'perf', 'docs', 'test', 'build', 'refactor', 'style', 'chore', 'temp',
      ]],

    // Increase the header max length to account for PR numbers on squash merges
    'header-max-length': [2, 'always', 110],

    // Default rules we want to suppress:
    'body-leading-blank': [0, "always"],
    'body-max-line-length': [0, "always"],
    'footer-max-line-length': [0, "always"],
    'footer-leading-blank': [0, "always"],
    'subject-case': [0, "always", []],
    'subject-full-stop': [0, "never", '.'],
  },

  ignores: [
    // Allow GitHub revert messages, like:
    //    Revert "introduce a bug"
    //    Revert "introduce a bug" (#1234)
    message => /^Revert ".*"( \(#\d+\))?/.test(message),

    // Pre-enforcement squash commits; see GRANDFATHERED_HEADERS above.
    message => GRANDFATHERED_HEADERS.has(message.split('\n')[0]),

    // BTW: commitlint has a built-in list of ignores which are also applied.
    // Those include the typical "Merged" messages, so those are implicitly ignored:
    // https://github.com/conventional-changelog/commitlint/blob/master/%40commitlint/is-ignored/src/defaults.ts
  ],
};

export default Configuration;
