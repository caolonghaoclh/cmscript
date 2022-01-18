
bmp_test(names "a" "b" paths "qwe" "abc")
bmp_find_package(testlib)
bmp_find_package(testlib ON)
bmp_find_package(testlib ON ON)
bmp_find_package(testlib ON ON 3.0)