pkg_check_modules(LIBUSERMETRICSOUTPUT REQUIRED libusermetricsoutput-1)

find_package(Qt5Core REQUIRED)
find_package(Qt5Quick REQUIRED)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}/plugins/Utils
    ${liblomiri-private_SOURCE_DIR}
    ${LIBUSERMETRICSOUTPUT_INCLUDE_DIRS}
)

set(QMLPLUGIN_SRC
    ../Utils/lomirisortfilterproxymodelqml.cpp
    DBusGreeter.cpp
    DBusGreeterList.cpp
    Greeter.cpp
    plugin.cpp
    PromptsModel.cpp
    SessionsModel.cpp
    UsersModel.cpp
    )

add_subdirectory(FullLightDM)
add_subdirectory(IntegratedLightDM)
