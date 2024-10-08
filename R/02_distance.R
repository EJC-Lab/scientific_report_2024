# Functions in For-loop --------------------------------------------------------

## 2.1 distance_df -------------------------------------------------------------
#' Title Distance calculation
#'
#' @param lb_train
#' @param lb_test_ind
#' @param match_methods
#' @param match_time
#' @param id_var
#' @param outcome_var
#' @param time_var
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
distance_df <- function(lb_train,
                        lb_test_ind,
                        match_methods = c("euclidean", "mahalanobis", "single"),
                        match_time = NULL,
                        id_var,
                        outcome_var,
                        time_var,
                        ...) {
  outcome_var <- ensym(outcome_var)
  time_var <- ensym(time_var)
  id_var <- ensym(id_var)

  ## the matching subset
  lb_sub1 <- lb_train %>%
    pivot_wider(names_from = {{ id_var }},
                values_from = {{ outcome_var }}) %>%
    column_to_rownames(var = as.character({{ time_var }})) %>%
    mutate_all(as.numeric)

  center = as.numeric(unlist(lb_test_ind[, 3]))

  if (match_methods == "euclidean") {
    dist_df <<- euclidean_df(Dmatrix = lb_sub1,
                             center = center)
    # cat("\n using euclidean distance\n")
  }

  if (match_methods == "mahalanobis") {
      dist_df <<- mahalanobis_df(Dmatrix = lb_sub1,
                                 center = center)
    #  cat("\n using mahalanobis distance\n")
  }

  if (match_methods == "single") {
    if (is.null(match_time)) {
      stop("provide matching time points for single-time PLM methods")
    }
    dist_df <<- single_df(Dmatrix = lb_sub1,
                          match_time = match_time,
                          center = center)
    # cat("\n using single critical time point matching \n")
  }

  return(distance = dist_df)
}


## 2.2 matching ----------------------------------------------------------------

#' Title Finding the matches subset
#'
#' @param distance_df
#' @param train
#' @param test_one
#' @param id_var
#' @param outcome_var
#' @param time_var
#' @param match_alpha
#' @param match_number
#' @param match_plot
#'
#' @return
#' @export
#'
#' @examples
match <- function(distance_df = ddd,
                  train = train,
                  test_one,
                  id_var,
                  outcome_var,
                  time_var,
                  match_alpha = NULL,
                  match_number = NULL,
                  match_plot = FALSE) {

  outcome_var <- ensym(outcome_var)
  time_var <- ensym(time_var)
  id_var <- ensym(id_var)


  if (is.null(match_alpha)) {
    data <- distance_df %>%
      slice(1:match_number) %>%
      inner_join(train, by = as.character({{ id_var }}))
  }

  if (is.null(match_number)) {
    data <- distance_df %>%
      filter(pvalue >= match_alpha) %>%
      inner_join(train, by = as.character({{ id_var }}))
  }

  if (match_plot == TRUE) {

    matching_plot <- ggplot() +
      geom_line(data = data, aes(x = {{ time_var }}, y = {{ outcome_var }},
                    group = {{ id_var }}),
                color = "grey",
                linetype = "dashed") +
      geom_line(data = test_one,
                aes(x = {{time_var}}, y = {{outcome_var}}),
                color = "darkblue",
                linewidth = 1) +
      theme_bw()

    cat("\n plotting matching paired individual trajectories \n")
  } else {
    matching_plot = NULL
  }

  return(list(subset = data,
              plot = matching_plot,
              id = unique(test_one[[as_label(enquo(id_var))]]),
              alpha = match_alpha,
              number = match_number))
}

dis_match <- function(lb_train,
                      lb_test_ind,
                      train = train,
                      match_methods = c("euclidean", "mahalanobis", "single"),
                      id_var,
                      outcome_var,
                      time_var,
                      match_alpha = NULL,
                      match_number = NULL,
                      match_time = NULL,
                      match_plot,
                      ...) {


  outcome_var <- ensym(outcome_var)
  time_var <- ensym(time_var)
  id_var <- ensym(id_var)
  ## the matching subset
  lb_sub1 <- lb_train %>%
    pivot_wider(names_from = {{ id_var }},
                values_from = {{ outcome_var }}) %>%
    column_to_rownames(var = as.character({{ time_var }})) %>%
    mutate_all(as.numeric)

  center = as.numeric(unlist(lb_test_ind[, outcome_var]))

  if (match_methods == "euclidean") {
    # dist_df <<- lb_sub1 %>%
    #   apply(2, norm, type = "2") %>%
    #   as.data.frame() %>%
    #   dplyr::select(diff = 1) %>%
    #   rownames_to_column("id") %>%
    #   arrange(diff) %>%
    #   slice(1:match_number)

    dist_df <<- euclidean_df(Dmatrix = lb_sub1,
                             center = center)
    # cat("\n using euclidean distance\n")
  }

  if (match_methods == "mahalanobis") {
    dist_df <<- mahalanobis_df(Dmatrix = lb_sub1,
                               center = center)
    # cat("\n using mahalanobis distance\n")
  }

  if (match_methods == "single") {
    if (is.null(match_time)) {
      stop("provide matching time points for single-time PLM methods")
    }
    dist_df <<- single_df(Dmatrix = lb_sub1,
                          match_time = match_time,
                          center = center)
    # cat("\n using single critical time point matching \n")
  }

  if (is.null(match_alpha)) {
    data1 <- dist_df %>%
      as.data.frame() %>%
      mutate(ww = 1 / diff) %>%
      slice(1:match_number) %>%
      inner_join(train, by = as.character({{ id_var }}))
  }

  if (is.null(match_number)) {
    data1 <- dist_df %>%
      as.data.frame() %>%
      mutate(ww = 1 / diff) %>%
      filter(pvalue >= match_alpha) %>%
      inner_join(train, by = as.character({{ id_var }}))
  }

  if (match_plot == TRUE) {

    matching_plot <- ggplot() +
      geom_line(data = data1, aes(x = {{ time_var }}, y = {{ outcome_var }},
                                 group = {{ id_var }}),
                color = "grey",
                linetype = "dashed") +
      geom_line(data = lb_test_ind,
                aes(x = {{time_var}}, y = {{outcome_var}}),
                color = "darkblue",
                linewidth = 1) +
      theme_bw()

    cat("\n plotting matching paired individual trajectories \n")
  } else {
    matching_plot = NULL
  }

  return(list(subset = data1,
              target = lb_test_ind,
              plot = matching_plot))
}




dyn_match <- function(lb_train,
                      lb_test_ind,
                      train = train,
                      match_methods = c("euclidean", "mahalanobis", "single"),
                      id_var,
                      outcome_var,
                      time_var,
                      match_alpha = NULL,
                      match_number = NULL,
                      match_time = NULL,
                      match_plot,
                      ...) {

  outcome_var <- ensym(outcome_var)
  time_var <- ensym(time_var)
  id_var <- ensym(id_var)

  ## the matching subset
  # lb_sub1 <- lb_train %>%
  #   pivot_wider(names_from = {{ id_var }},
  #               values_from = {{ outcome_var }}) %>%
  #   column_to_rownames(var = as.character({{ time_var }})) %>%
  #   mutate_all(as.numeric)
  # center = as.numeric(unlist(lb_test_ind[, outcome_var]))

  center = as.numeric(unlist(lb_test_ind))

  if (match_methods == "euclidean") {
    dist_df <<- lb_train %>%
      apply(2, norm, type = "2") %>%
      as.data.frame() %>%
      dplyr::select(diff = 1) %>%
      rownames_to_column("id") %>%
      arrange(diff) %>%
      slice(1:match_number)
    # cat("\n using euclidean distance\n")
  }


  # Wed Feb 28 22:52:05 2024 ------------------------------
  ## need to change the function to work
  if (match_methods == "mahalanobis") {
    def <- nrow(lb_train)
    df <- lb_train %>%
      as.matrix() %>%
      t()

    x <- sweep(df, 2L, center)
    invcov <- MASS::ginv(cov(df))

    value <- rowSums(x %*% invcov * x)
    pvalue <- pchisq(value, df = def, lower.tail = FALSE)
    dist_df <<- data.frame(diff = value,
                            pvalue = pvalue) %>%
      arrange(desc(pvalue)) %>%
      rownames_to_column("id")

    # dist_df <<- mahalanobis_df(Dmatrix = lb_sub1,
    #                            center = center)
    # cat("\n using mahalanobis distance\n")
  }

  if (match_methods == "single") {
    if (is.null(match_time)) {
      stop("provide matching time points for single-time PLM methods")
    }
    dist_df <<- single_df(Dmatrix = lb_train,
                          match_time = match_time,
                          center = center)
    # cat("\n using single critical time point matching \n")
  }

  if (is.null(match_alpha)) {
    data1 <- dist_df %>%
      as.data.frame() %>%
      mutate(ww = 1 / diff) %>%
      slice(1:match_number) %>%
      inner_join(train, by = as.character({{ id_var }}))
  }

  if (is.null(match_number)) {
    data1 <- dist_df %>%
      as.data.frame() %>%
      mutate(ww = 1 / diff) %>%
      filter(pvalue >= match_alpha) %>%
      inner_join(train, by = as.character({{ id_var }}))
  }

  if (match_plot == TRUE) {

    matching_plot <- ggplot() +
      geom_line(data = data1, aes(x = {{ time_var }}, y = {{ outcome_var }},
                                  group = {{ id_var }}),
                color = "grey",
                linetype = "dashed") +
      # geom_line(data = lb_test_ind,
      #           aes(x = {{time_var}}, y = {{outcome_var}}),
      #           color = "darkblue",
      #           linewidth = 1) +
      theme_bw()

    # cat("\n plotting matching paired individual trajectories \n")
  } else {
    matching_plot = NULL
  }

  return(list(subset = data1, plot = matching_plot))
}








