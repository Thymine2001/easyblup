#' Launch the easyblup Shiny application
#'
#' This helper looks up the packaged Shiny app and launches it via `shiny::runApp()`.
#' Any arguments supplied are forwarded to `shiny::runApp()`, allowing callers to
#' override defaults such as `launch.browser`.
#'
#' @param ... Additional arguments passed to `shiny::runApp()`.
#'
#' @return This function is called for its side effect of starting the Shiny app.
#' @export
run_app <- function(...) {
  app_dir <- system.file("shiny_app", package = "easyblup")

  if (app_dir == "") {
    stop("Could not find the packaged Shiny application directory.", call. = FALSE)
  }

  shiny::runApp(appDir = app_dir, ...)
}
