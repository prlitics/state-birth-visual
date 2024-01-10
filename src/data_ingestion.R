library(here)
library(ggplot2)
library(tidyverse)
library(tidycensus)
library(geofacet)
library(infixit) # for %+% and %nin%

setwd("C:/Users/prlic/Research Projects/state-birth-visual")

dat <- readr::read_csv(file.path(here::here(),"data","usa_00003.csv"))

## FIPS data from tidycensus
fips_dat <- tidycensus::fips_codes %>%
  dplyr::distinct(state,state_code) %>%
  dplyr::rename(STATEFIP = state_code)


props <- dat %>%
  dplyr::mutate(STATEFIP = ifelse(nchar(STATEFIP) < 2, "0" %+% STATEFIP, STATEFIP),
                BPL_t = ifelse(nchar(BPL) < 2, "0" %+% BPL, BPL)) %>%
  dplyr::mutate(BPL_c = dplyr::case_when(
    STATEFIP == BPL_t ~ 1, # Same state as birth
    (STATEFIP != BPL_t) & BPL %in% 1:120 ~ 2, # Different than birth, in US state/territory
    (STATEFIP != BPL_t) & BPL %nin% 1:120 ~ 3 # Different than birth, born outside US

  )) %>%
  dplyr::left_join(fips_dat, by = "STATEFIP") %>%
  dplyr::count(state, BPL_c, wt = PERWT) %>%
  dplyr::group_by(state) %>%
  dplyr::mutate(prop = n/sum(n)) %>%
  dplyr::mutate(l = ifelse(prop > 0.1, round(100*prop) %+% "%",""))

write_csv(props, file.path(here::here(),"data","props.csv"))
