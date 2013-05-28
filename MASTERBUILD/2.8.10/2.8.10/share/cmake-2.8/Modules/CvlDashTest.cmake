include(CTest)

set(CTEST_PROJECT_NAME "CvlProject")
set(CTEST_NIGHTLY_START_TIME "01:30:00 UTC")
set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "cvlrepo.massive.org.au")
set(CTEST_DROP_LOCATION "/CDash/submit.php?project=${CTEST_PROJECT_NAME}")
set(CTEST_DROP_SITE_CDASH TRUE)

