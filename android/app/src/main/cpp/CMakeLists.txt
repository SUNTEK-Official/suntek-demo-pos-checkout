cmake_minimum_required(VERSION 3.22.1)
project(spi_lcd)

add_library(spi_lcd SHARED spi_lcd.c)
target_link_libraries(spi_lcd log)
