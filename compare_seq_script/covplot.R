# this is a R script to plot the depths of bam file(s)
# usage -
# Rscript script.R file.bam out.pdf
# require bedtools in the PATH

require(ggplot2, quiet=T)

## 1 read in 

args = commandArgs( trailingOnly = TRUE )

if( length(args) != 2){ stop( "Rscript file.bam out.pdf", call. = FALSE) }


## 2 bedtools 

outfile_name = gsub( ".pdf", ".depth.txt", args[2])

cml_1 = paste0( "bedtools genomecov -d -split -ibam ", args[1], " > ", outfile_name ) 

cat(cml_1, "\n")

system(cml_1)


## 3 plotting

outplot_name = gsub( ".pdf", ".depth.pdf", args[2])

if( !file.exists( outfile_name ) ){ stop( "no output from bedtools" ) }

readin = read.table( outfile_name )

p = 
ggplot(readin) + geom_line(aes(x = V2, y = V3)) + theme_minimal() + xlab("Position") + ylab("Depth") 

ggsave(p, filename=outplot_name, width=7, height=4, units="in")
