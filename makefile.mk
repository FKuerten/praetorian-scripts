# Automatic section

# Start with no include directories
INCLUDEDIRS:=

# If we have dependencies, calculate transitive dependencies
iftrue ${DEPENDENCIES}
	TRANSITIVE_DEPENDENCIES=$(shell ${MODULEDIR}/scripts/findTransitiveDependencies.sh ${MODULEDIR} ${DEPENDENCIES})
else
	TRANSITIVE_DEPENDENCIES:=
endif

# If we have transitive dependencies, include their headers
iftrue ${TRANSITIVE_DEPENDENCIES}
	INCLUDEDIRS+=${MODULEDIR}/../${TRANSITIVE_DEPENDENCIES}/src/main/c++
endif

# Include our generated sources
INCLUDEDIRS+=${MODULEDIR}/target/generated

# Include transitive dependencies generated sources
# (skipped for now)


CPPFLAGS+=-I${INCLUDEDIRS}

PROJECT_NAME=${MODULE_NAME}
include scripts/objectsMakeppfile.mk
include scripts/version.mk

$(phony FORCE):
    @true

LIBS+=$(addprefix -l,${TRANSITIVE_DEPENDENCIES})
LDFLAGS+=-L${CURDIR}/../${TRANSITIVE_DEPENDENCIES}/target/
OWN_LIB_FILES=$(shell ./scripts/expandModules.sh ${TRANSITIVE_DEPENDENCIES})

iftrue ${DEPENDENCIES}
	DEPENDENCY_FILES:=${CURDIR}/../${TRANSITIVE_DEPENDENCIES}/target/dependencies
	DEPLIBS=$(shell cat ${DEPENDENCY_FILES})
else
	DEPENDENCY_FILES:=
	DEPLIBS:=
endif

load_makefile ${MODULEDIR}/target/objects/Makeppfile
load_makefile ${MODULEDIR}/../${TRANSITIVE_DEPENDENCIES}

OBJECTS:=$(shell ${MODULEDIR}/scripts/findObjects.sh)
ALLLIBS=${LIBS} ${DEPLIBS}

target/dependencies: ${DEPENDENCY_FILES}
    echo ${ALLLIBS} > ${output}
