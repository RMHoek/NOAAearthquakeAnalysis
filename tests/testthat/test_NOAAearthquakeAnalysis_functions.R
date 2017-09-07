context("test file for NOAAearthquakeAnalysis package")

dataFile <- system.file("extdata", "earthquakes.tsv.gz",
                        package = "NOAAearthquakeAnalysis")
theData <- readr::read_delim(dataFile, delim = "\t")
theCleanData <- theData %>% eq_clean_data()
g <- theCleanData %>%
    dplyr::filter(COUNTRY %in% c("GREECE", "ITALY"), lubridate::year(DATE) > 2000) %>%
    ggplot2::ggplot(ggplot2::aes(x = DATE,
                                 y = COUNTRY,
                                 color = TOTAL_DEATHS,
                                 size = EQ_PRIMARY))

testthat::test_that("eq_clean_data returns data.frame", {
    df <- theData %>% eq_clean_data()
    testthat::expect_is(df, "data.frame")
})

testthat::test_that("eq_clean_data returns df with 17 variables", {
    df <- theData %>% eq_clean_data()
    l <- ncol(df)
    testthat::expect_equal(l, 17)
})

testthat::test_that("eq_location_clean returns data.frame", {
    df <- NOAAearthquakeAnalysis::eq_location_clean(theData$LOCATION_NAME)
    testthat::expect_is(df, "data.frame")
})

testthat::test_that("eq_location_clean returns type character", {
    df <- NOAAearthquakeAnalysis::eq_location_clean(theData$LOCATION_NAME)
    temp <- as.vector(as.matrix(df[1,]))
    testthat::expect_is(temp, "character")
})

testthat::test_that("unite_YMD returns single column data.frame", {
    df <- theData %>% dplyr::select(YEAR, MONTH, DAY)
    df <- NOAAearthquakeAnalysis::unite_YMD(df)
    testthat::expect_is(df, "data.frame")
})

testthat::test_that("unite_YMD returns dates", {
    df <- theData %>% dplyr::select(YEAR, MONTH, DAY)
    df <- NOAAearthquakeAnalysis::unite_YMD(df)
    testthat::expect_true(sapply(df, class) == "Date")
})

testthat::test_that("as_BC_date returns date before 0AD", {
    BCD <- NOAAearthquakeAnalysis::as_BC_date(-1966, 10, 16)
    YearZero <- as.Date(0, origin = "0000-01-01")
    testthat::expect_true(BCD < YearZero)
})

testthat::test_that("eq_map returns a leaflet interactive map", {
    map <- theCleanData %>%
        dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
        eq_map(annot_col = "DATE")
    testthat::expect_is(map, "leaflet")
})

testthat::test_that("eq_create_label returns character vector", {
    popup_text = eq_create_label(theCleanData)
    testthat::expect_is(popup_text, "character")
})

testthat::test_that("eq_create_label returns vector of expected length", {
    popup_text = eq_create_label(theCleanData)
    testthat::expect_equal(length(popup_text), length(theCleanData[,1]))
})

testthat::test_that("GeomTimeline returns ggplot object", {
    gtest <- g + geom_timeline()
    expect_is(gtest, "ggplot")
})

testthat::test_that("GeomTimeline_label returns ggplot object", {
    gtest <- g + geom_timeline_label(aes(label = LOCATION))
    expect_is(gtest, "ggplot")
})

testthat::test_that("GeomTimeline_label with n_max returns ggplot object", {
    gtest <- g + geom_timeline_label(aes(label = LOCATION), n_max = 8)
    expect_is(gtest, "ggplot")
})

testthat::test_that("theme_timeline returns ggplot object", {
    gtest <- g + theme_timeline()
    expect_is(gtest, "ggplot")
})
