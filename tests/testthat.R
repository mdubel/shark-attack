# TODO: Don't explicitly set working directory, so this script works outside of Docker too.
# It is probably the cleanest solution for now, as R currently starts in `/mnt/src` by default
# (configured via `Rprofile` in the Dockerfile).
setwd("/mnt/tests")
testthat::test_dir("testthat")
