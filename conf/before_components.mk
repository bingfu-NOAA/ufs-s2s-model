# This file sets the location of configure.nems and modules.nems, and
# adds Make rules to create the tests/*.exe and tests/modules.* files.
# This file is included by the NEMS build system, within
# NEMS/GNUmakefile, just after platform logic is executed, but before
# the appbuilder file (if any) is read.

# IMPORTANT: This file MUST NOT CONTAIN any logic specific to building
# FV3, CCPP, FMS, or NEMS.  Otherwise, coupled FV3 applications will
# break.  There should only be logic specific to the NEMSfv3gfs test
# system and NEMSfv3gfs file naming in this makefile fragment.
#
# Logic specific to FV3, CCPP, FMS, or NEMS belong in NEMS/src/incmake.

# ----------------------------------------------------------------------
# Decide the conf and modulefile names.
# S2S_DEBUG_MODULE is defined in GNUmakefile
ifeq ($(S2S_DEBUG_MODULE),false)
  CHOSEN_MODULE=$(BUILD_TARGET)/fv3_coupled
else
  CHOSEN_MODULE=$(BUILD_TARGET)/fv3_coupled_debug
endif

#$(info CHOSEN_MODULE is $(CHOSEN_MODULE))

ifneq (,$(findstring INTEL16=Y,$(FV3_MAKEOPT)))
  ifeq ($(CHOSEN_MODULE),gaea.intel/fv3)
    override CHOSEN_MODULE=$(BUILD_TARGET)/fv3.intel-16.0.3.210
    $(warning Overriding CHOSEN_MODULE with $(CHOSEN_MODULE) as requested per MAKEOPT)
  endif
endif

CONFIGURE_NEMS_FILE=configure.fv3_coupled.$(BUILD_TARGET)

# ----------------------------------------------------------------------
# Exit for systems that are currently not supported
ifeq ($(BUILD_TARGET),theia.pgi)
  $(error NEMSfv3gfs currently not supported on $(BUILD_TARGET))
else ifeq ($(BUILD_TARGET),cheyenne.pgi)
  $(error NEMSfv3gfs currently not supported on $(BUILD_TARGET))
endif

# ----------------------------------------------------------------------
# Copy the executable and modules.nems files into the tests/ directory
# if a TEST_BUILD_NAME is specified.

ifneq ($(TEST_BUILD_NAME),)
$(info Will copy modules.nems and NEMS.x as $(TEST_BUILD_NAME) under tests/)
$(ROOTDIR)/tests/$(TEST_BUILD_NAME).exe: $(NEMS_EXE)
	set -xe ; cp "$<" "$@"

$(ROOTDIR)/tests/modules.$(TEST_BUILD_NAME): $(NEMSDIR)/src/conf/modules.nems
	set -xe ; cp "$<" "$@"

configure: $(ROOTDIR)/tests/modules.$(TEST_BUILD_NAME) ;
build: $(ROOTDIR)/tests/$(TEST_BUILD_NAME).exe ;
endif

