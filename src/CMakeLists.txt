# re2c will take our source `scan_string_list.c` and generate
# `scan_string_list.re.c` into the build/ directory.
re2c_compile(scan_string_list.c OPTIONS --no-debug-info --case-ranges)
add_executable(scan_string_list "${CMAKE_CURRENT_BINARY_DIR}/scan_string_list.re.c")

# lemon will take our source `calc.y` and generate
# `calc.c, calc.h, calc.out` into the build/ directory.
lemon_compile(calc.y)
add_executable(calc "${CMAKE_CURRENT_BINARY_DIR}/calc.c")
target_include_directories(calc
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
  "${CMAKE_CURRENT_BINARY_DIR}"
)

# Combining the two, first we generate `calc2.c` and then use re2c on
# it to generate `calc2.re.c`.
lemon_compile(calc2.y)
re2c_compile(calc2.c FROM_LEMON OPTIONS --no-debug-info --case-ranges)
add_executable(calc2 "${CMAKE_CURRENT_BINARY_DIR}/calc2.re.c")
target_include_directories(calc2
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
  "${CMAKE_CURRENT_BINARY_DIR}"
)
target_link_libraries(calc2 readline)
