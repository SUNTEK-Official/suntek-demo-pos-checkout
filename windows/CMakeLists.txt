cmake_minimum_required(VERSION 3.16)

project(printer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 COMPONENTS QuickControls2 REQUIRED)


# Windows ,
qt_add_executable(appprinter
    main.cpp
    posdllloader.cpp
    printermanager.cpp
    posdllloader.h
    printermanager.h
    appprinter.rc
)

qt_add_qml_module(appprinter
    URI printer
    VERSION 1.0
    QML_FILES
        Main.qml
        Cashier.qml
        ProductList.qml
        CartPanel.qml
        Numpad.qml
        PrinterSettings.qml
        ESPOSPrint.qml
        TSPLPrint.qml
        CPCLPrint.qml
)

#
qt_add_resources(appprinter "images"
    PREFIX "/printer"
    FILES
        images/apple.png
        images/banana.png
        images/kele.png
        images/water.png
        images/cigarette.png
        images/milk.png
        images/Tissue.png
        images/bread.png
        images/app_icon.svg
        images/app_icon.ico
)

# Windows ( Windows )
if(WIN32)
 #
    set_target_properties(appprinter PROPERTIES
        WIN32_EXECUTABLE TRUE
        WIN32_ICON "${CMAKE_CURRENT_SOURCE_DIR}/images/app_icon.ico"
    )
endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
# set_target_properties(appprinter PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appprinter
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )

target_link_libraries(appprinter
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appprinter
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

#
set(OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/output)
file(MAKE_DIRECTORY ${OUTPUT_DIR})

# DLL ( , DLL)
# add_custom_command(TARGET appprinter POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different
#         "${CMAKE_CURRENT_SOURCE_DIR}/POS_SDK.dll"
#         "$<TARGET_FILE_DIR:appprinter>/POS_SDK.dll"
# COMMENT " POS_SDK.dll "
# )
