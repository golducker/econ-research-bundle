---
name: econ-research
description: Bundle and router for economics research and paper writing. Combines the academic-research-skills pack (academic-pipeline, academic-paper, academic-paper-reviewer, deep-research, sr-screener) with r-econometrics. Use when the user types /econ-research, asks for the "econ bundle" or "research bundle", or wants help with an economics paper, research idea, literature review, econometric analysis in R, or peer review of an economics paper, and has not named one specific skill.
---

# Econ Research Bundle

This skill only routes. Each task is done by one of the six skills installed next to it. Pick the matching skill, say in one line which one you chose and why, then load it and follow it:

- Claude Code / Claude.ai: load it with the Skill tool.
- Codex / ChatGPT desktop, Gemini CLI: activate the skill by name, or open its `SKILL.md` and follow it.

If the user's request is empty or unclear, show them the menu below (in their language) and ask which step they are at.

## Menu

| # | User is at this step | Load skill | Typical trigger to pass on |
|---|---|---|---|
| 1 | Has only a topic or vague idea, wants a research question | `deep-research` (socratic mode) | "guide my research on ..." |
| 2 | Needs a literature review or a systematic review | `deep-research` (lit-review or systematic-review mode) | "literature review on ..." |
| 3 | Has database exports or abstracts to screen against criteria | `sr-screener` | "screen these papers" |
| 4 | Has data and needs IV, DiD, RDD or panel regressions in R | `r-econometrics` | describe the design and data |
| 5 | Wants to plan or outline the paper | `academic-paper` (plan mode) | "guide my paper" |
| 6 | Wants a draft, abstract, citation check or format conversion | `academic-paper` (matching mode) | "draft the abstract", "check citations" |
| 7 | Has a draft and wants a simulated peer review | `academic-paper-reviewer` | "review my paper" |
| 8 | Got reviewer comments and must revise or rebut | `academic-paper` (revision-coach or rebuttal-audit) | "I got reviewer comments" |
| 9 | Wants the whole pipeline, idea to finished paper | `academic-pipeline` | "research to paper on ..." |

Name collision: some installs also have a general web-research skill called `deep-research` (for example `anthropic-skills:deep-research`). For rows 1 and 2 use the `deep-research` skill from this bundle.

## Rules that override the bundled skills

1. **Coursework comes first.** When the work is a graded assignment, the course's own brief, format, chapter structure and required software win over the bundled skills. The research question and topic belong to the student or group: offer options with reasons, but let them decide.
2. **Check data before committing to a topic.** For quantitative work, confirm that every variable exists for the chosen countries and years (for example World Bank WDI, IMF, national statistics offices) before the topic is approved. Report coverage, not just the source name.
3. **Notation.** Y is the dependent variable (the outcome being explained). X is an independent variable (the cause or driver). State the expected sign of every X with a reason from theory, and keep symbols the same in every chapter.
4. **Software.** `r-econometrics` uses the `fixest` package. If it is missing, ask before installing it (run `install.packages("fixest")` in the console, never inside an .Rmd). If the course requires Stata, EViews or base R, translate the method into that tool.
5. **Citations.** Every citation must be a real source that has been checked. Never fill in references from memory. If a source cannot be confirmed, leave it out and say so.
6. **Language.** Reply in the user's language. Keep standard technical terms (fixed effects, Hausman test, panel data) in English when the user's field does.
