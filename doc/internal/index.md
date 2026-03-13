# Implementation-Oriented Documentation

This section explains how Leansi works internally. It is intended for readers who want to understand the implementation choices behind the public API, especially for the university submission.

## What This Section Covers

- which exported declarations are part of the intended user-facing API and which are mainly support helpers
- how documents are measured, sliced, coalesced, and split into lines
- how alignment and fixed-width columns are assembled internally
- how color support detection, downsampling, ANSI encoding, and rendering fit together
- how the widgets for boxes, trees, and progress bars are built

## Reading Order

1. [Public API boundaries](public-api-boundaries.md)
2. [Document and layout internals](document-and-layout-internals.md)
3. [Color and rendering pipeline](color-and-rendering-pipeline.md)
4. [Widget implementation notes](widget-implementation-notes.md)

## Relationship To The User Docs

The user section documents the parts of the library that should normally be used directly in applications. This internal section explains the helpers and implementation structure that make those features work.

User-facing entry point:

- [User overview](../user/index.md)

