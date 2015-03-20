DL_LINK   = http://bitbucket.org/eigen/eigen/get/3.2.1.tar.gz
DL_NAME   = 3.2.1.tar.gz
UNZIP_DIR = eigen-eigen-6b38706d90a9


#default_target: all

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

ifeq ($(shell echo $$OSTYPE),cygwin)
  BUILD_PREFIX:=$(shell cygpath -m $(BUILD_PREFIX))
endif

all: pod-build/Makefile
	cmake --build pod-build --config $(BUILD_TYPE) --target install

pod-build/Makefile:
	$(MAKE) configure

.PHONY: configure
configure: $(UNZIP_DIR)/CMakeLists.txt
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

	# create the temporary build directory if needed
	@mkdir -p pod-build

	# create the lib directory if needed, so the pkgconfig gets installed to the right place
	@mkdir -p $(BUILD_PREFIX)/lib
	@mkdir -p $(BUILD_PREFIX)/lib/pkgconfig

	# run CMake to generate and configure the build scripts
	@cd pod-build && cmake -DCMAKE_INSTALL_PREFIX=$(BUILD_PREFIX) \
		   -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ../$(UNZIP_DIR) \
       -DEIGEN_BUILD_PKGCONFIG=ON

$(UNZIP_DIR)/CMakeLists.txt:
	wget --no-check-certificate $(DL_LINK) && tar -xzf $(DL_NAME) && rm $(DL_NAME)
	$(SED) -i -e 's@share/pkgconfig@lib/pkgconfig@g' $(UNZIP_DIR)/CMakeLists.txt

clean:
	-if [ -e pod-build/install_manifest.txt ]; then rm -f `cat pod-build/install_manifest.txt`; fi
	-if [ -d pod-build ]; then cmake --build pod-build --target clean; rm -rf pod-build; fi

# other (custom) targets are passed through to the cmake-generated Makefile
%::
	cmake --build pod-build --config $(BUILD_TYPE) --target $@
