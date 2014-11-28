all: index masem 3level

index: index.Rmd
	R --no-save --no-restore -e "library(rmarkdown); render(\"index.Rmd\")"

masem: masem.Rmd
	R --no-save --no-restore -e "library(rmarkdown); render(\"masem.Rmd\")"

3level: 3level.Rmd
	R --no-save --no-restore -e "library(rmarkdown); render(\"3level.Rmd\")"

Manual:
	R --no-save --no-restore -e "setwd(\"./manual\"); library(knitr); knit_rd(\"metaSEM\")"
