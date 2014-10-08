# shinyBTC

GUI for [Rbitcoin](https://github.com/jangorecki/Rbitcoin) package using shiny app.

**Current version**: 0.1.1

## Installation & Usage

```R
# dependency, install (update) if you miss any:
install.packages("devtools")
install.packages("data.table")
install.packages("shiny")
install.packages("rmarkdown")
devtools::install_github("jangorecki/Rbitcoin")

# run shiny app
shiny::runGitHub("jangorecki/shinyBTC")

# if you hit pandoc error you should update it, for example by copy from RStudio:
#sudo cp /usr/lib/rstudio/bin/pandoc/* /usr/local/bin/

# Rbitcoin introduction
vignette("introduction", package="Rbitcoin")
```

## License

[MIT license](http://opensource.org/licenses/MIT)

## Contact

`j.gorecki@wit.edu.pl`
