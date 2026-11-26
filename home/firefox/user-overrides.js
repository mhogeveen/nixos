
/*** MY OVERRIDES (session restore fix, 2026-11-14) ***/
user_pref("browser.startup.page", 3);                             // resume previous session
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false); // stay logged in on restored tabs
user_pref("browser.sessionstore.resume_from_crash", true);        // explicit (default)

/*** MY OVERRIDES (default theme, 2026-11-26) ***/
// "Dark" (nicedarktheme), force-installed by the policy in hosts/common.nix
user_pref("extensions.activeThemeID", "{7cbdf3df-936d-4b13-811f-320bf981f801}");

/*** MY OVERRIDES (keep everything on shutdown, 2026-11-26) ***/
// arkenfox 2810: don't sanitize on close at all. Clearing history, cookies or
// storage also wipes the restored session; per-item _v2 overrides weren't enough on FF160
user_pref("privacy.sanitize.sanitizeOnShutdown", false);
