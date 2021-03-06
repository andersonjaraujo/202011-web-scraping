library(tidyverse)
library(httr)
library(rvest)


u_cdg_19 <- "http://www.chancedegol.com.br/br10.htm"
u_cdg_18 <- "http://www.chancedegol.com.br/br18.htm"

u <- "https://www.curso-r.com"
pags <- 1:5



tictoc::tic()
ufs <- unique(geobr::grid_state_correspondence_table$code_state)
for (i in ufs) {
  u <- stringr::str_glue("http://www.chancedegol.com.br/br{i}.htm")
  print(u)
}
tictoc::toc()




cdg_table <- cdg_html  %>%
  read_html() %>%
  xml_find_first('//table') %>%
  html_table() %>%
  tibble::as_tibble() %>%
  set_names(janitor::make_clean_names(.[1,])) %>%
  slice(-1)


cdg_html  %>%
  read_html() %>%
  xml_find_first('//table') %>%
  html_table(header = TRUE) %>%
  janitor::clean_names() %>%
  as_tibble()


cdg_table

cores <- cdg_html %>%
  read_html() %>%
  xml_find_all('//font[@color="#FF0000"]') %>%
  xml_text()

# codigo perigoso
cdg_table$vermelho <- cores

length(cores)
nrow(cdg_table)


# transformando texto em numero
# passo comum
# 1. utilizar {stringr} para simplificar texto
# 2. utilizar as.numeric

readr::parse_number(
  cdg_table$vitoria_do_mandante,
  locale = readr::locale(
    decimal_mark = ".",
    grouping_mark = ","
  )
)

# uma versao mais avancada
resultado_arrumado <- cdg_table %>%
  mutate(
    across(vitoria_do_mandante:vermelho,
           readr::parse_number)
  )

glimpse(resultado_arrumado)

resultado_arrumado <- cdg_table %>%
  mutate(
    across(-c(1:4),
           readr::parse_number)
  )

# mutate_all()
# mutate_at()
# mutate_if()

# filter_at(any_vars())
