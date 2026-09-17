# Notes App (Flutter + BLoC + SQLite)

A local-first notes app styled to match the approved Android mockup:
gradient splash screen, flat bottom navigation, `NOTE-001`-style id
badges, colored label badges, Sora + Inter typography — built on a shared
widget library and a single `AppBlocProvider` for state management.

## Architecture

```
lib/
  main.dart                     # Registers AppBlocProvider, builds the AppTheme-driven MaterialApp
  app_bloc_provider.dart        # The ONE place every Bloc/Cubit is created and provided

  theme/
    app_theme.dart              # AppColors, AppText (Sora/Inter via google_fonts),
                                 # label badge colors, shared radius constant —
                                 # every screen and widget pulls from this file only

  models/
    note.dart                   # Note model — toMap()/fromMap() for SQLite rows
    note_labels.dart            # Preset label list + lookup helper
    note_colors.dart            # Preset color swatches

  services/
    database_service.dart       # Raw sqflite connection + schema (CREATE TABLE)
    note_repository.dart        # Domain-level CRUD API on top of DatabaseService —
                                 # NotesBloc only ever talks to this, never to SQL directly

  bloc/
    notes_event.dart            # Every user/system action on notes
    notes_state.dart            # allNotes, visibleNotes, search/filter/view state
    notes_bloc.dart             # Single source of truth for notes — talks to NoteRepository
    theme_cubit.dart            # Persisted light/dark mode (SharedPreferences — one boolean,
                                 # doesn't need a database table)

  screens/
    splash_screen.dart          # Gradient bg, floating logo, bouncing dot loader
    home_screen.dart            # Bottom nav shell (4 tabs), built from AppBottomNav
    notes_tab.dart              # List/grid, search, label-filter chip, FAB
    note_edit_screen.dart       # Title/body fields + 6-icon toolbar (color, label,
                                 # reminder, pin, lock, more) — a SEPARATE screen from
                                 # note_view_screen.dart, reached via the pencil icon
    note_view_screen.dart       # Read-only details; watches NotesBloc live by id
    labels_screen.dart          # Label list with live counts, tap to filter
    reminders_screen.dart       # Notes that have a reminder date/time set
    settings_screen.dart        # Dark mode toggle, clear all notes

  widgets/                      # Shared, reusable building blocks used across every screen
    app_top_bar.dart            # AppTopBar — the top bar every screen uses
    app_icon_button.dart        # AppIconButton — every icon button in the app (top bar,
                                 # note editor toolbar, bottom sheets) is one of these
    app_text_field.dart         # AppTextField — title/body/search input, one component
    app_button.dart             # AppButton — primary/outlined/danger button variants
    app_card.dart                # AppCard — bordered, tappable container (notes, labels,
                                 # reminders all sit inside one of these)
    app_chip.dart                # AppChip — pill/badge used for labels, filters, tags
    app_bottom_nav.dart          # AppBottomNav — the 4-tab bottom navigation bar
    app_empty_state.dart        # AppEmptyState — generic "nothing here yet" placeholder
    note_card.dart              # NoteCard — note-specific composition of AppCard + AppChip
```

### Why one `AppBlocProvider`

`main.dart` never creates a Bloc itself — it just wraps the app in
`AppBlocProvider`, which is the single place `ThemeCubit` and `NotesBloc`
(with `NoteRepository` injected into it) are constructed and registered
via `MultiBlocProvider`. If a new feature needs its own Bloc later, it
gets added to this one file, not scattered across screens.

### Why a shared widget library

Every screen is built from the same handful of primitives —
`AppTopBar`, `AppIconButton`, `AppTextField`, `AppButton`, `AppCard`,
`AppChip` — instead of each screen hand-rolling its own `Container` +
`BoxDecoration` + `TextStyle`. Change a border radius or a font size in
one widget file, and every screen picks it up. `AppTheme` is the only
place colors and fonts are defined; nothing hardcodes a hex color or
calls `GoogleFonts.sora(...)` directly outside of it.

### Why SQLite (sqflite) instead of SharedPreferences

`DatabaseService` owns the raw `sqflite` connection and the `notes`
table schema. `NoteRepository` sits on top of it with a plain
insert/update/delete/getAll API — `NotesBloc` only ever calls
`NoteRepository`, never SQL directly. This is a real relational table on
disk rather than one big JSON blob, so it scales better as note count
grows. `shared_preferences` is kept for exactly one thing — the
dark-mode boolean — since a whole database table would be overkill for
a single flag.

### Why the edit and view screens are separate

Tapping a note opens `note_view_screen.dart` — read-only, watching
`NotesBloc` live by id. Tapping the pencil icon there pushes
`note_edit_screen.dart`, a completely separate screen with the actual
form fields. `NoteEditScreen` just dispatches `AddNote`/`UpdateNote` and
pops; `NoteViewScreen` re-reads the note from state, so it reflects the
edit immediately without any result object being threaded back up the
navigation stack.

## Notifications

There is no push-notification service in this build — reminders are
stored as a date/time on the note and listed under the Reminders tab,
but nothing schedules an OS-level alert. This was a deliberate choice to
avoid the native Gradle/Kotlin plugin setup that a notification package
requires. The natural place to add one back later is inside
`NotesBloc`'s `_onAddNote` / `_onUpdateNote` / `_onDeleteNote` handlers.

## Honest simplifications vs. the mockup

- **Multiple free-form tags per note** — the mockup's note details screen
  shows several arbitrary chips together (e.g. "Work", "Important",
  "Team"). This app keeps the single-preset-label model, shown as one
  badge plus status chips (pinned/locked/reminder). A full freeform
  multi-tag system is a bigger model change — happy to add it as a
  follow-up.
- **Lock** is a visual toggle only (a padlock icon/status), not an actual
  passcode or biometric gate on the note's content.
- Material icons stand in for the mockup's emoji (📝, 🔍, ⏰) for
  crisper rendering at small sizes — colors, spacing, and layout match
  the mockup directly.

## Getting started

```
flutter pub get
flutter run
```

Works in the browser too (`flutter run -d chrome`) — `sqflite` needs a
web-specific setup to persist there, so on web notes will still work
within a single session but may not survive a full page reload. On
Android/iOS/desktop, `sqflite` persists to a real on-disk database file
as normal.

## Publishing to GitHub

```bash
git init
git add .
git commit -m "Notes app: BLoC, SQLite (sqflite), shared widget library, matches mockup"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo-name>.git
git push -u origin main
```

Set the repo to **Public** under Settings, copy the URL, and submit it
in the Ostad assignment section.
