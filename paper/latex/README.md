# LaTeX source

Open `template.tex` with a full TeX Live installation. Run from this directory:

```sh
pdflatex -interaction=nonstopmode -halt-on-error template.tex
pdflatex -interaction=nonstopmode -halt-on-error template.tex
```

References are embedded in the manuscript's `thebibliography` environment; BibTeX is not required. The figure paths are relative. The OAE class and publisher image assets are included as template dependencies, not as original research contributions. Template source: https://www.oaepublish.com/ir/manuscript_templates

Verified on 2026-09-24 with TeX Live 2026: 15 pages, with no undefined references or overfull-box warnings after the second pass. This is the working manuscript, not a published article. The corresponding compiled PDF is available at `../PP_AT_manuscript.pdf`.
