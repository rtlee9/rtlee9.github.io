# compiles all .Rmd files in _R directory into .md files in _posts directory,
# if the input file is older than the output file.
library(knitr)

KnitPost <- function(input, outfile, base.url="/") {
  # this function is a modified version of an example here:
  # http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/
  require(knitr);
  opts_knit$set(base.url = base.url)
  fig.path <- paste0("/Volumes/HDD/rtlee9.github.io/_cache/", sub(".Rmd$", "", basename(input)), "/")
  opts_chunk$set(fig.path = fig.path)
  opts_chunk$set(fig.cap = "testing")
  render_jekyll()
  knit(input, outfile, envir = parent.frame())
}

for (infile in list.files("_source/", pattern="*.Rmd", full.names=TRUE)) {
  fname <- sub(".Rmd$", ".md", basename(infile))
  if (is.numeric(substr(fname, 1, 4))) {
    outfile = paste0("references/", fname)
  } else {
    outfile = paste0("_posts/", fname)
  }
  
  # knit only if the input file is the last one modified
  if (!file.exists(outfile) |
      file.info(infile)$mtime > file.info(outfile)$mtime) {
    KnitPost(infile, outfile)
  }
}
