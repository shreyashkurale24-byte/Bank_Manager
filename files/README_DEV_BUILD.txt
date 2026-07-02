BANK MANAGER PRO — INTERNAL DEV / TEST BUILD
==============================================
Version:    0.8.0-dev
Build type: Internal development & QA testing ONLY
Audience:   Internal engineering / QA team members

------------------------------------------------------------
WHAT THIS BUILD IS
------------------------------------------------------------
A PyQt5 desktop shell wrapping a local Flask app (127.0.0.1:5001)
that exposes auto-generated Create/Read/Update/Delete screens for
all 36 tables in the core banking schema (Dumptables.sql), including:

  - atmcard / atmcardrequest / atmtrn   (ATM cards & transactions)
  - chqissue / chqbchrg                  (cheque issuance & charges)
  - cashbal / cashlimit                  (cash balances & limits)
  - chartofac                            (chart of accounts)
  - groupinstr / groupinstrexec          (standing instructions)
  - ...and 27 more.

------------------------------------------------------------
WHY THIS IS LABELED "DEV / TEST" AND NOT A PRODUCT
------------------------------------------------------------
As of this build, app.py has not been confirmed to include:

  [ ] Authentication enforced on every route (login.html exists,
      but verify it actually gates access to table CRUD endpoints)
  [ ] Role-based permissions (who can edit vs. just view)
  [ ] Audit logging (who changed what, and when)
  [ ] Input validation / business-rule checks before writes
  [ ] Protection against accidental bulk delete

Until those are verified and added, this tool can directly edit or
delete live banking records with no trace. That is appropriate for
a local dev/test environment with disposable test data. It is NOT
appropriate to install on any machine that touches real customer
or production data, and it should not be handed to bank staff or
customers as-is.

------------------------------------------------------------
RULES FOR THIS BUILD
------------------------------------------------------------
1. Internal use only. Do not forward this installer outside the
   engineering/QA team.
2. Only point it at test/dummy data. Never connect it to a
   production database (see README.md's MySQL connection notes).
3. Note: app.py's own __main__ block runs with debug=True on
   host 0.0.0.0 (all network interfaces) — that path is NOT used
   by this desktop build (which binds to 127.0.0.1 only), but
   don't reuse that block for any server deployment.
4. Before this becomes a real product: add auth + RBAC + audit
   logging, get a security review, then we build a properly
   branded, code-signed customer installer.

------------------------------------------------------------
UNINSTALLING
------------------------------------------------------------
Use "Uninstall Bank Manager Pro (DEV)" from the Start Menu folder,
or Windows Settings > Apps > Bank Manager Pro [DEV-TEST BUILD].
