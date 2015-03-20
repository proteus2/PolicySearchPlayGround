DL_LINK   = https://bullet.googlecode.com/files/bullet-2.81-rev2613.tgz
DL_NAME   = bullet-2.81-rev2613.tgz
UNZIP_DIR = bullet-2.81-rev2613


default_target: all

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

SED=sed
ifeq ($(shell uname), Darwin)
  SED=gsed
endif

BULLET_INSTALL_LIBS = libBulletCollision.2.81.dylib \
	libBulletDynamics.2.81.dylib \
	libBulletMultiThreaded.2.81.dylib \
	libBulletSoftBody.2.81.dylib \
	libBulletSoftBodySolvers_OpenCL_Apple.2.81.dylib \
	libBulletSoftBodySolvers_OpenCL_Mini.2.81.dylib \
	libLinearMath.2.81.dylib \
	libMiniCL.2.81.dylib

all: pod-build/Makefile
	$(MAKE) -C pod-build all install
ifeq ($(shell uname), Darwin)
	@for lib in $(BULLET_INSTALL_LIBS); do \
		install_name_tool -id $(BUILD_PREFIX)/lib/$$lib $(BUILD_PREFIX)/lib/$$lib; \
		for deplib in $(BULLET_INSTALL_LIBS); do \
			install_name_tool -change $$deplib $(BUILD_PREFIX)/lib/$$deplib $(BUILD_PREFIX)/lib/$$lib; \
		done; \
	done
endif

pod-build/Makefile:
	$(MAKE) configure

.PHONY: configure
configure: $(UNZIP_DIR)/CMakeLists.txt
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

	# create the temporary build directory if needed
	@mkdir -p pod-build

	# run CMake to generate and configure the build scripts
	@cd pod-build && cmake -DCMAKE_INSTALL_PREFIX=$(BUILD_PREFIX) \
		-DBUILD_SHARED_LIBS=on \
                -DINSTALL_LIBS=on \
		-DBUILD_DEMOS=off \
		-DUSE_DOUBLE_PRECISION=on \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ../$(UNZIP_DIR)

$(UNZIP_DIR)/CMakeLists.txt: bullet_gjk_accuracy_patch.diff
	wget --no-check-certificate $(DL_LINK) && tar -xzf $(DL_NAME) && rm $(DL_NAME)
	$(SED) -i -e 's@share/pkgconfig@lib/pkgconfig@g' $(UNZIP_DIR)/CMakeLists.txt
	patch -p0 -i bullet_gjk_accuracy_patch.diff
	mv $(UNZIP_DIR)/src/LinearMath/btScalar.h $(UNZIP_DIR)/src/LinearMath/btScalar.h.in
	patch -p0 -i bullet_double_precision_patch.diff

clean:
	-if [ -e pod-build/install_manifest.txt ]; then rm -f `cat pod-build/install_manifest.txt`; fi
	-if [ -d pod-build ]; then $(MAKE) -C pod-build clean; rm -rf pod-build; fi
