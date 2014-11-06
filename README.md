# shinyBTC

GUI for [Rbitcoin](https://github.com/jangorecki/Rbitcoin) package using shiny app.

**Current version**: 0.1.1

## Installation & Usage

```R
# dependency, install (update) if you miss any:
install.packages("devtools")
install.packages("data.table") # 1.9.6+
install.packages("shiny")
install.packages("rmarkdown")
install.packages("Rbitcoin") # 0.9.4+

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

`J.Gorecki@wit.edu.pl`
