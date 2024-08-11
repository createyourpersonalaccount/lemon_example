cmake_minimum_required(VERSION 3.16)
project(
  lemon_example
  VERSION 0.1
  DESCRIPTION "lemon and re2c example"
  LANGUAGES C
)

find_program(LEMON lemon)
if(NOT LEMON)
  message(
    FATAL_ERROR
    "lemon is missing. Please install it, see <https://sqlite.org/src/doc/trunk/doc/lemon.html>."
  )
endif()

find_program(RE2C re2c)
if(NOT RE2C)
  message(
    FATAL_ERROR
    "re2c is missing. Please install it, see <https://re2c.org/>."
  )
endif()

function(re2c_compile input)
  # FROM_LEMON tells re2c_compile to expect the source file in the
  # build directory because it was placed there by lemon in a previous step.
  #
  # OPTIONS are the underlying options to pass to the re2c program.
  set(options FROM_LEMON)
  set(oneValueArgs "")
  set(multiValueArgs OPTIONS)
  cmake_parse_arguments(
    RE2C_COMPILE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  # Compile .c sources to .re.c output from re2c.
  string(REGEX REPLACE "[.]c$" ".re.c" re2c_output "${input}")
  if(RE2C_COMPILE_FROM_LEMON)
    set(working_dir "${CMAKE_CURRENT_BINARY_DIR}")
  else()
    set(working_dir "${CMAKE_CURRENT_SOURCE_DIR}")
  endif()
  add_custom_command(
    OUTPUT "${re2c_output}"
    WORKING_DIRECTORY "${working_dir}"
    COMMAND "${RE2C}"
    ARGS "${input}"
         -o "${CMAKE_CURRENT_BINARY_DIR}/${re2c_output}"
         ${RE2C_COMPILE_OPTIONS}
    DEPENDS "${input}"
    VERBATIM
  )
endfunction()

function(lemon_compile input)
  # OPTIONS are the underlying options to pass to the lemon program.
  set(options "")
  set(oneValueArgs "")
  set(multiValueArgs OPTIONS)
  cmake_parse_arguments(
    LEMON_COMPILE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  # Compile .y sources to .c output from lemon.
  string(REGEX REPLACE "[.]y$" "" lemon_output ${input})
  add_custom_command(
    OUTPUT "${lemon_output}.c" "${lemon_output}.h" "${lemon_output}.out"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMAND "${LEMON}"
    ARGS "${input}"
         "-d${CMAKE_CURRENT_BINARY_DIR}"
         ${LEMON_COMPILE_OPTIONS}
    DEPENDS ${input}
    VERBATIM
  )
endfunction()

add_subdirectory(src)
