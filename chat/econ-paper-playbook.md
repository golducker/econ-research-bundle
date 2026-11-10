# Econ Paper Playbook

Procedures for a quantitative economics paper, from topic to presentation. Each section matches one step of the menu in the instructions. This file is a condensed, chat-friendly version of the workflow in the econ-research skill bundle.

---

## 1. Choose a topic and research question

**Ask first:** course name and chapters covered, required paper structure, deadline, group size, what the lecturer likes (for example STEM, AI, real policy), qualitative or quantitative, preferred software.

**Good topic test (score each 1 to 5):**
- Feasible: all data exist and can be downloaded within a week.
- In scope: tied to a named chapter or theory of the course.
- Narrow: one outcome (Y), three to five drivers (X), a defined sample and period.
- Interesting: links to a current policy debate.
- Defensible: the group can explain every variable and sign in Q&A.

**For each candidate topic give:**

| Field | Content |
|---|---|
| Title | Specific: drivers, outcome, sample, period |
| Y | Dependent variable, unit, source code |
| X | Independent variables with expected signs |
| Controls | Variables theory says must be held constant |
| Scope | Course chapter and theory |
| Data | Source and coverage (share of non-missing observations) |
| Method | For example panel FE/RE with Hausman |
| Reason | Why it is worth studying, policy link |
| Main Q&A risk | The hardest question a lecturer could ask |

**Research question pattern:** "What is the effect of X1, X2, X3 on Y in [sample] over [period]?" plus one sub-question per hypothesis.

**Avoid:** topics where the key variable exists for only one or two years, topics with obvious reverse causality and no way to address it, and topics that need survey data the group cannot collect in time.

---

## 2. Literature review

**Goal:** show what is known, what is not, and where this paper fits.

**Search:** Google Scholar, ScienceDirect, SSRN, RePEc/IDEAS, IMF and World Bank working papers, and local journals. Use keywords for Y and each X plus the method ("panel data", "fixed effects").

**Build an evidence table:**

| Author (year) | Sample, period | Method | Variables | Main finding | Sign of key X |
|---|---|---|---|---|---|

**Write it by theme, not by paper.** For each X: what theory predicts, what most studies find, where findings disagree and why (sample, method, period).

**Close with the gap:** a sample, period, variable or method that earlier studies did not cover. That gap is the contribution in Chapter 1.

**Integrity:** cite only papers you have opened. Record the DOI or URL. Never cite from memory.

---

## 3. Find and check data

**Common free sources:**
- World Bank WDI (data.worldbank.org): GDP, productivity, R&D, internet use, trade, FDI, inflation, unemployment.
- IMF data (data.imf.org, IMF DataMapper): fiscal, monetary, exchange rate, AI Preparedness Index.
- National statistics offices (for Vietnam: GSO, gso.gov.vn), central banks.
- UNESCO UIS (education, STEM graduates), ILOSTAT (labour), UNCTAD (trade, FDI).

**Feasibility check, before the topic is approved:**
1. List every variable with its exact indicator code.
2. Download for all countries and years in the sample.
3. Compute coverage: non-missing observations divided by countries times years.
4. If a key variable is below about 70 percent, narrow the sample, shorten the period, switch to a close substitute, or use multi-year averages.

**Cleaning log:** record every change (dropped country, interpolated year, unit conversion) and the reason. It goes into Chapter 3.

**Download in R:**
```r
library(WDI)
wdi_data <- WDI(country = c("VN", "TH", "MY", "ID", "PH"),
                indicator = c(gdp_worker = "SL.GDP.PCAP.EM.KD",
                              rd_gdp     = "GB.XPD.RSDV.GD.ZS",
                              internet   = "IT.NET.USER.ZS"),
                start = 2000, end = 2023)
colMeans(!is.na(wdi_data[, c("gdp_worker", "rd_gdp", "internet")]))  # coverage
```

**Download in Stata:**
```stata
ssc install wbopendata
wbopendata, indicator(SL.GDP.PCAP.EM.KD) long clear
```

---

## 4. Build the model and expected signs

**Model equation (country panel):**

Y_it = b0 + b1 X1_it + b2 X2_it + ... + bk Controls_it + u_i + e_it

where i is country, t is year, u_i is the country effect and e_it is the error.

**Variable table (required in Chapter 3):**

| Symbol | Definition | Unit | Source (code) | Expected sign | Reason from theory |
|---|---|---|---|---|---|

**Rules:**
- Y is the dependent variable, X are independent variables. Never reverse them.
- Use the same symbol for a variable in every chapter, table and slide.
- Use logs for level variables (GDP per worker, population). A coefficient on ln(X) with ln(Y) is an elasticity: a 1 percent rise in X goes with a b percent change in Y. A coefficient on a percentage X with ln(Y): a 1 point rise in X goes with about 100 times b percent change in Y.
- Every expected sign needs a reason from the course theory (for example Solow: higher saving rate raises output per worker, higher population growth lowers it).
- Consider lags (X at t-1) when the effect takes time or to reduce reverse causality.

---

## 5. Run the regressions and read the output

**Order of work:**
1. Descriptive statistics (mean, sd, min, max, N).
2. Correlation matrix and VIF (VIF above 10 signals multicollinearity).
3. Pooled OLS, FE and RE.
4. Choose the model: F test (Pooled vs FE), Breusch-Pagan LM (Pooled vs RE), Hausman (FE vs RE; p < 0.05 favours FE).
5. Diagnostics on the chosen model: heteroskedasticity, serial correlation, cross-sectional dependence if N is small and T is long.
6. Fix problems: cluster-robust SE, Driscoll-Kraay SE, or FGLS. With few countries (about 10), cluster-robust SE are unreliable, so prefer Driscoll-Kraay or report both.
7. Robustness: drop one country at a time, use a different proxy, add lags.

**R (package plm):**
```r
library(plm); library(lmtest); library(car)
panel_data <- pdata.frame(wdi_data, index = c("country", "year"))
model_formula <- log(gdp_worker) ~ rd_gdp + internet + invest_gdp + pop_growth

pooled <- plm(model_formula, data = panel_data, model = "pooling")
fe     <- plm(model_formula, data = panel_data, model = "within")
re     <- plm(model_formula, data = panel_data, model = "random")

pFtest(fe, pooled)                    # Pooled vs FE
plmtest(pooled, type = "bp")          # Pooled vs RE
phtest(fe, re)                        # Hausman: FE vs RE
vif(lm(model_formula, data = wdi_data))
bptest(model_formula, data = wdi_data) # heteroskedasticity
pbgtest(fe)                           # serial correlation
coeftest(fe, vcov = vcovSCC(fe))      # Driscoll-Kraay SE
coeftest(fe, vcov = vcovHC(fe, cluster = "group", type = "HC1"))
```

**Stata:**
```stata
encode country, gen(id)
xtset id year
reg lny rd internet invest popg
vif
xtreg lny rd internet invest popg, fe
estimates store fe
xtreg lny rd internet invest popg, re
estimates store re
xttest0                      // after re: Breusch-Pagan LM
hausman fe re
quietly xtreg lny rd internet invest popg, fe
xttest3                      // ssc install xttest3: heteroskedasticity
xtserial lny rd internet invest popg   // ssc install xtserial
xtscc lny rd internet invest popg, fe  // ssc install xtscc: Driscoll-Kraay
```

**Reading a coefficient (template):** "Holding other factors constant, a one [unit] increase in [X] is associated with a [b] [unit] change in [Y]. The effect is significant at the [1/5/10] percent level. The sign [matches / does not match] the expected sign because [mechanism]."

**When a sign is unexpected:** check data errors and units first, then multicollinearity, then omitted variables, then reverse causality, then the economic story (threshold effects, time lags, absorptive capacity). Report it honestly; an explained surprise is a strong discussion point.

**Never** write results that did not come from the pasted output.

---

## 6. Write a chapter

**Outline first.** Agree the headings (1.1, 1.2, ...) before drafting. Lecturers often approve the outline before any writing.

**Chapter checklists:**

- **Chapter 1 Introduction:** background with two or three facts and sources; problem and gap; objectives; research questions; scope (sample, period, variables); contribution; structure.
- **Chapter 2 Theory and literature:** concepts; theoretical framework from the course textbook; empirical review by theme; evidence table; hypotheses H1, H2, ... with expected signs.
- **Chapter 3 Methodology:** model equation; variable table; data sources and coverage; cleaning log; estimation steps and tests, with the reason for each.
- **Chapter 4 Results and discussion:** descriptive table; correlation and VIF; model selection; final model with robust SE; interpretation of each key coefficient; comparison with earlier studies; robustness.
- **Chapter 5 Conclusion and policy:** answer each research question in one or two sentences; one or more policy recommendations per finding, naming who should act (government, central bank, ministry, firms); limitations; future research.

**Abstract (150 to 250 words):** context, objective, data and method, main results with signs, policy implication.

**Writing rules:** formal and plain; one idea per paragraph; every number traceable to a table or source; same notation everywhere.

---

## 7. Check citations

For each reference:
1. Find it on Google Scholar or the publisher site.
2. Confirm authors, year, title, journal, volume, pages, DOI.
3. Confirm the claim in the paper is actually in the source.
4. Match every in-text citation with one reference-list entry, and the other way round.
5. Use one style throughout (APA 7 unless the course says otherwise).

Mark each reference: Verified, Details wrong (fix), or Not found (remove). Never keep a reference that cannot be found.

---

## 8. Mock peer review

Review a draft from five angles, then list issues by severity (Critical, Major, Minor):

1. **Fit:** does it answer the research question and match the course scope?
2. **Method:** is the model right for the data; are tests reported and correctly read; are signs explained?
3. **Evidence:** do the claims follow from the tables; are the citations real and relevant?
4. **Writing:** logic between sections, notation consistency, clarity.
5. **Devil's advocate:** the strongest objection (reverse causality, omitted variable, weak proxy, small sample) and how the paper answers it.

End with the three changes that would most improve the grade.

---

## 9. Revise after the lecturer's comments

1. Paste every comment. Number them.
2. For each: what it asks, where in the paper it applies, the planned change, and who in the group does it.
3. Make the change. Write a short response line per comment ("Done: added Hausman test, Table 4.3").
4. Re-check notation, table numbers and references after edits.

Lecturers usually expect each chapter to be sent at least twice; keep a version log.

---

## 10. Slides and Q&A preparation

**10-minute deck (about 10 to 12 slides):**
1. Title and members
2. Why this matters (one striking fact)
3. Research question and objectives
4. Theory and hypotheses (diagram)
5. Data and variables (table)
6. Model and method
7. Results (one clean table, key coefficients highlighted)
8. Discussion (mechanisms, comparison with studies)
9. Policy implications
10. Limitations and conclusion

One message per slide, large numbers, no paragraphs.

**Q&A bank (every member must be able to answer all of these):**
- Why this topic, sample and period?
- Why is Y the dependent variable and not the other way round? Could causality run in reverse?
- Why these X and controls? What important variable is missing?
- Why FE (or RE)? What did the Hausman test show?
- What does the coefficient on [key X] mean in plain words? Is it large?
- Why is [variable] not significant or the wrong sign?
- How reliable is the data? How much is missing?
- Is [proxy] a good measure of [concept]?
- Which policy follows directly from your results, and who should implement it?
- What would you do with more time or data?

Practise with members answering questions from sections they did not write.
