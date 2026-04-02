# Outlook Signature Manager

## Project Overview
A Flutter Web app to centrally manage and generate HTML email signatures for 250+ employees. Employees visit a unique URL, copy their rendered signature, and paste it into Outlook's signature settings (one-time action per client). Images are hosted on our domain via absolute URLs, so swapping an image file automatically updates all signatures.

## Problem
- 250+ Outlook email accounts need consistent, branded signatures
- Manual updates are time-consuming and error-prone
- Signatures must work across Outlook Desktop (Win/Mac), OWA, and Outlook Mobile
- Image/banner and employee info changes happen monthly

## Architecture

### Two Roles
- **Admin**: Manages templates, employee data, and images
- **Employee**: Views their generated signature and copies it

### Core Flow
1. Admin creates/edits an HTML signature template with placeholders (`{{name}}`, `{{title}}`, `{{phone}}`, `{{email}}`, `{{photo}}`, etc.)
2. Admin imports employee data via Excel (.xlsx) upload or manual entry
3. System generates a unique signature page per employee
4. Employee visits their page, clicks "Copy Signature", pastes into Outlook settings
5. Admin can update images on the server — all signatures update automatically since images are URL-referenced

### Data Model
- **Template**: HTML content with mustache-style placeholders, metadata (name, created date, active flag)
- **Employee**: name, title, department, phone, email, photo URL, any custom fields
- **Image Assets**: uploaded files served from a static `/signatures/images/` path on our domain

## Critical Technical Constraints

### Outlook HTML Rendering (NON-NEGOTIABLE)
Outlook Desktop uses Microsoft Word's rendering engine. The generated signature HTML MUST follow these rules:
- **Table-based layout ONLY** — no `<div>`, no flexbox, no grid
- **Inline styles ONLY** — no `<style>` blocks, no CSS classes
- No shorthand CSS (use `padding-top: 10px; padding-right: 10px;` not `padding: 10px;`)
- No `background-image` on table cells — use `<img>` tags instead
- All `<img>` tags must have explicit `width` and `height` attributes
- All image `src` must be absolute HTTPS URLs
- No `max-width`, no `margin: auto`, no modern CSS
- Use `cellpadding`, `cellspacing`, `border` attributes on tables
- Use `align`, `valign` attributes for positioning
- `line-height` in px, not unitless
- Safe fonts only: Arial, Helvetica, Georgia, Times New Roman, Verdana, Tahoma
- `<a>` tags must have inline `color` and `text-decoration` styles

### Copy-to-Clipboard Mechanism
- Render the signature as actual DOM (not source code)
- Use Clipboard API to copy the rendered HTML from the DOM
- When pasted into Outlook, it should preserve the table layout and inline styles
- Test: copy from browser → paste into Outlook signature settings → send email → verify rendering

### Image Hosting
- All signature images served over HTTPS from our domain
- Absolute URLs only (e.g., `https://yourdomain.com/signatures/images/logo.png`)
- Same filename replacement = instant update across all signatures
- Set `Cache-Control: max-age=3600` (1 hour) so updates propagate reasonably fast
- Note: Outlook blocks remote images by default for recipients — this is expected behavior and cannot be avoided

## Tech Stack
- **Framework**: Flutter Web (Dart)
- **State Management**: GetX (project standard)
- **Data Import**: Excel (.xlsx) parsing via `excel` or `spreadsheet_decoder` dart package
- **Storage/Backend**: TBD (Firebase, Supabase, or self-hosted — decide later). For now, design with a repository pattern so the backend is swappable.
- **Signature Rendering**: Raw HTML string generation from templates + data. Rendered in an iframe or `HtmlElementView` for preview. Clipboard copy via `dart:js_interop` or `dart:html` calling the browser Clipboard API.

## Project Structure
```
lib/
├── main.dart
├── app/
│   ├── routes/
│   ├── bindings/
│   └── themes/
├── core/
│   ├── constants/
│   ├── utils/
│   │   ├── html_template_engine.dart    # Placeholder replacement logic
│   │   ├── clipboard_helper.dart        # Copy rendered HTML to clipboard
│   │   └── excel_parser.dart            # Parse .xlsx employee data
│   └── models/
│       ├── employee.dart
│       ├── signature_template.dart
│       └── image_asset.dart
├── data/
│   ├── repositories/
│   │   ├── employee_repository.dart     # Abstract repo (swappable backend)
│   │   ├── template_repository.dart
│   │   └── image_repository.dart
│   └── providers/
│       └── (firebase/supabase/local implementations)
├── modules/
│   ├── admin/
│   │   ├── dashboard/
│   │   ├── template_editor/             # Create/edit HTML templates
│   │   ├── employee_manager/            # CRUD employees, Excel import
│   │   └── image_manager/               # Upload/replace signature images
│   └── employee/
│       └── signature_view/              # View & copy personal signature
```

## Key Features to Build

### Phase 1 — MVP
- [ ] HTML template engine (placeholder replacement)
- [ ] Employee data model + manual CRUD
- [ ] Excel import for bulk employee data
- [ ] Signature preview (rendered HTML in iframe)
- [ ] Copy-to-clipboard (rendered HTML, not source)
- [ ] Unique employee signature page (shareable URL)

### Phase 2 — Admin Polish
- [ ] Template editor with live preview
- [ ] Image upload + management
- [ ] Bulk signature regeneration
- [ ] Department/role-based template assignment

### Phase 3 — Optional
- [ ] Auth (admin vs employee access)
- [ ] Signature versioning/history
- [ ] PowerShell/Graph API script export for automated deployment to OWA

## Testing Checklist
- [ ] Generated HTML renders correctly in Outlook Desktop (Windows)
- [ ] Generated HTML renders correctly in Outlook Desktop (Mac)
- [ ] Generated HTML renders correctly in OWA
- [ ] Generated HTML renders correctly in Outlook Mobile
- [ ] Copy-paste from browser to Outlook preserves layout
- [ ] Images load in sent emails (check Gmail, Outlook, Apple Mail recipients)
- [ ] Replacing an image on server updates the signature in previously sent emails (cached emails won't update, new emails will)
- [ ] Excel import handles 250+ rows without issues

## Notes
- The signature HTML output is pure HTML tables with inline styles — Flutter is only the admin/management app
- Never use Flutter widgets to render the actual signature — it must be raw HTML for Outlook compatibility
- The repository pattern is critical — backend will be decided later
- Keep the template engine simple: `{{placeholder}}` replacement, no conditionals or loops needed initially
