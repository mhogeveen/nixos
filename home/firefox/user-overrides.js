
/*** MY OVERRIDES (session restore fix, 2026-11-14) ***/
user_pref("browser.startup.page", 3);                             // resume previous session
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false); // stay logged in on restored tabs
user_pref("browser.sessionstore.resume_from_crash", true);        // explicit (default)
