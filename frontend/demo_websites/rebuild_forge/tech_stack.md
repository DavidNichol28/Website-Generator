@@work_title="Tech Stack"
# Technical Stack: Empowerment Through Minimalism
Nerds waste too much time talking about which language - all it does is make things even more complicated. Sure, there are strengths and weaknesses, but who cares? 

Most of the languages were designed to make the engineering market as fragmented as possible to increase the price of labor of engineers: prove me wrong. I'm not saying we should have 5 in totality, but the ~100 or so "professional languages" on the StackOverflow surveys is a joke. We are taking a radical stance against that nonsense and using next to nothing - one language per use case (frontend, high-level backend, low-level backend, more as needed).

Why not just use one thing that's really good at most things so that everyone can help with anything rather than gatekeep the ability to help with nerdy obsessions for different ways of getting pissed off at a computer?

Every external dependency is a potential point of failure or control. Every framework adds complexity that excludes potential contributors. Every unnecessary tool creates another barrier between people and meaningful participation in building public infrastructure.

That's why we barely use anything.

## Core Technologies

### Programming Languages
#### Go
Go is chosen for its simplicity, high performance, and versatility. It provides an efficient backend foundation that is easy to maintain, highly concurrent, and well-suited for building scalable systems.

#### Flutter
Flutter is used for all frontend development due to its efficiency and the advantage of having a single codebase for all platforms. Also its important to note that the only alternative here is either **_JavaScript_** or introducing extreme complexity with building and maintaining different GUI frontends for everly platform.

#### Rust
Rust is used where strong typing, memory safety, and high performance are critical. Its to be used where Go is a bit too high-level like for parsers and compilers.

#### Trusting **_Google?_**
While it's true that Google developed, develops, and maintains both Go and Flutter, they are now deeply embedded in open-source communities, so even if Google dropped them all tomorrow, these tools have the corporate momentum and adoption to continue thriving without Google's soul-crushingly finnicky backing.

### Platform
Debian (GNU plus Linux) is our encouraged OS - it's stable, secure, and free from corporate control while staying useable without specialized knowledge.

Of course, nerds who can use more **_refined_** operating systems are fine - just no corporate malware users (if you don't know what I'm talking about - I'm talking about you).

### Version Control
We use Radicle for distributed source management. This eliminates dependency on Microsoft's infrastructure while maintaining familiar git workflows.

## Why This Matters

The goal isn't technical purity - it's practical independence. Every additional tool or framework we add:
- Increases the learning curve for new contributors
- Creates another potential point of failure
- Adds complexity to maintenance
- Makes forking and independence harder

We're building public infrastructure. That means optimizing for:
- Ease of contribution
- Long-term maintainability
- Independence from corporate control
- Practical sustainability

## Contribute

### Next Steps: 
1. Learn Go (back-end)[LINK]
  - Designed to be the simplest language for the workload of a Google engineer, it only takes basic programming knowledge to wield.
2. Learn Flutter (front-end)[LINK] 
  - Like JS frameworks but drastically less upsetting
  - If you know any programming language, it'll take less than a day to get comfy in Dart (the progamming language Flutter uses).
3. Go through the Radicle docs if you dare (version control)[LINK] 
  - it's basically git with five minutes of extra config'ing
