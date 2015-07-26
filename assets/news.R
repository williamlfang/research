require(knitr, quietly=TRUE, warn.conflicts=FALSE)
require(rmarkdown)
library(rvest)

setwd("~/finance/_posts/快报/_Drafts")


dir=getwd()
images.dir=dir
images.url='/finance/assets/images/'
out_ext='.md'
in_ext='.Rmd'
recursive=FALSE

f <- "快报.Rmd"

  message(paste("Processing ", f, sep=''))
  content <- readLines(f)
  frontMatter <- which(substr(content, 1, 3) == '---')
  if(length(frontMatter) >= 2 & 1 %in% frontMatter) {
    statusLine <- which(substr(content, 1, 7) == 'status:')
    publishedLine <- which(substr(content, 1, 10) == 'published:')
    if(statusLine > frontMatter[1] & statusLine < frontMatter[2]) {
      status <- unlist(strsplit(content[statusLine], ':'))[2]
      status <- sub('[[:space:]]+$', '', status)
      status <- sub('^[[:space:]]+', '', status)
      if(tolower(status) == 'process') {
        #This is a bit of a hack but if a line has zero length (i.e. a
        #black line), it will be removed in the resulting markdown file.
        #This will ensure that all line returns are retained.
        content[nchar(content) == 0] <- ' '
        message(paste('Processing ', f, sep=''))
        content[statusLine] <- 'status: publish'
        content[publishedLine] <- 'published: true'
        outFile <- paste(substr(f, 1, (nchar(f)-(nchar(in_ext)))), out_ext, sep='')
        render_markdown(strict=TRUE)
        opts_knit$set(out.format='md')
        opts_knit$set(base.dir=images.dir)
        opts_knit$set(base.url=images.url)
        ######################################################################
        ## 产生的图片存储位置 `/assets/images/r-figures/`
        #fig.path <- paste0("r-figures/", sub(".Rmd$", "", basename(files)), "/")
        #opts_chunk$set(fig.path = fig.path)
        ## opts_chunk$set(fig.cap = "center")  ## figure position
        ## render_jekyll()       
        ######################################################################
        
        try(knit(text=content, output=outFile), silent=FALSE)
      } else {
        warning(paste("Not processing ", f, ", status is '", status, 
                      "'. Set status to 'process' to convert.", sep=''))
      }
    } else {
      warning("Status not found in front matter.")
    }
  } else {
    warning("No front matter found. Will not process this file.")
  }
  
  library(beepr);beep()


# file.new <- paste0(Sys.Date(), "-快报.md")
file.new <- paste0("2015-12-31", "-快报.md")
to.file = paste0("~/finance/_posts/快报/", file.new)
file.copy("快报.md", to = to.file,  recursive=TRUE)












