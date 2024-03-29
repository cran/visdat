test_vis_gather_ <- vis_gather_(typical_data)

suppressWarnings(
  test_old_gather <- typical_data %>%
    dplyr::mutate(rows = seq_len(nrow(.))) %>%
    tidyr::gather_(key_col = "variable",
                   value_col = "valueType",
                   gather_cols = names(.)[-length(.)]) %>%
    dplyr::arrange(rows, variable, valueType)
)

test_that("vis_gather_ returns the same as previous",{

  expect_equal(test_vis_gather_,
               test_old_gather)

})

d_old <- typical_data %>%
  fingerprint_df() %>%
  vis_gather_()

suppressWarnings({
  d_old$value <-  tidyr::gather_(typical_data,
                                 "variables",
                                 "value", names(typical_data))$value

  d_old <- d_old %>% dplyr::arrange(value)
})

d_new <-
  typical_data %>%
  fingerprint_df() %>%
  vis_gather_() %>%
  dplyr::mutate(value = vis_extract_value_(typical_data)) %>%
  dplyr::arrange(value)
# get the values here so plotly can make them visible

test_that("vis_extract_value performs the same as old method",{
  expect_equal(d_old$value,d_new$value)
})

test_that("any_numeric returns TRUE for numeric dataframes and FALSE for dataframes containing non-numeric values",{

  expect_equal(all_numeric(airquality),TRUE)
  expect_equal(all_numeric(iris),FALSE)

})
test_that("fingerprint can deal with complete-cases list columns",{
  expect_equal(all(visdat:::fingerprint(dplyr::starwars$films)%>% is.na()),FALSE)
})

test_that("fingerprint can count n/a in list columns",{
  expect_equal(sum(visdat:::fingerprint(dplyr::starwars$vehicles)%>% is.na()),76)
})

