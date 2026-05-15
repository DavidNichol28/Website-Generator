# Website Generator

A documentation-first static website generation system designed to turn structured writing into complete websites with minimal friction.

The project treats filesystem structure as navigational architecture and focuses on maintainability, portability, and long-term ownership of content.

---

## Goals

- Turn raw writing into navigable websites
- Preserve human-readable structure
- Minimize deployment complexity
- Avoid unnecessary platform dependence
- Keep generated output durable and portable
- Allow websites to be authored primarily through writing

---

## Philosophy

Most publishing systems optimize for platform retention.

This project optimizes for ownership.

Content should remain:

- portable
- inspectable
- versionable
- locally editable
- structurally meaningful

A website should be able to exist as a directory of writing without requiring a database, proprietary CMS, or complex deployment pipeline.

---

## Conceptual Flow

```text
content/
├── config.json
├── overview.md
├── essays/
│   ├── overview.md
│   ├── article-a.md
│   └── article-b.md
└── notes/
    └── overview.md
