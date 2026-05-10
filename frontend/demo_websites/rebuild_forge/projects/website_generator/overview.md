@@work_title="Projects Website Generator Overview"
# Markdown to Website

## Fast, Simple, Effective, Free, Accessible
---

### Problem
Its 2025, and yet there are still companies making tens of billions of dollars per year helping people with their websites.

Why?

### Vision
Its long past time to make it dead simple to turn ideas into websites fast, free, and so simply that it only takes one's structured notes to have a website ready to go.

The design is modular so that the project can be continually added to, but also forked to make it different in whatever way anyone so chooses.

The future this technology allows is one where you don't have to ever see or hear a god-awful WordPress or Wix ad ever again.

### Purpose
Websites are old tech. A substantial portion of the world's population came into existence after the word "website" became a part of daily vocabulary, yet these companies still squeeze money out of the need for websites - even though their products are just terrible.

Making websites free and accessible is a big step to building a ${"Free, Open, and Accessible Digital Public Infrastructure"work_title:Blog Free, Open, and Accessible Digital Public Works}$.

### Tech

#### Design
Starting with markdown (because developer-first is convenient), but extending to whatever other formats, a parser takes the root directory of a bunch of organized writing, crawls it to get all the files and file structure, processing the files into a general format, and saving them into a HashMap in the same layout as the original file structure.

This allows for someone who doesn't want to spend time putting their work into a website to just drop their work into the progam to get a website out.

Currently we are beginning work on ${"a styling system"work_title:Projects Website Generator Timeline}$ to allow dynamic style importing like WordPress and Friends bleeds so much money out of us for.

${"Come check out our design choices in building this."work_title:Website Generator Design Overview}$

**[NOTE: This project will not be handling the issue of hosting as that is sufficiently its own thing.]**

#### Stack
* **Rust**
  - Crawling writing
  - Parsing writing
  - Writing/Updating processed data
  - Generating static code (future)
* **Flutter**
  - Go-to frontend tech

${"Come see what we're doing."work_title:Website Generator Tech Overview}$
