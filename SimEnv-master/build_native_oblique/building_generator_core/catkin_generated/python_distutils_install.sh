#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/building_generator_core"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/install/lib/python3/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/install/lib/python3/dist-packages:/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/lib/python3/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique" \
    "/usr/bin/python3" \
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/building_generator_core/setup.py" \
     \
    build --build-base "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/building_generator_core" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/install" --install-scripts="/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/install/bin"
