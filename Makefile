PACKAGE_NAME=rJavaPackageExample
SUBPROJECT_PATH_NUMBER_ADDER=java/number-adder
# Place where the produced Jar files should go.
JAVA_BUILD_TARGET=./inst/java
$(shell mkdir -p $(JAVA_BUILD_TARGET))

# Absolute path to the directory. This is needed by subproject Makefiles.
JAVA_BUILD_TARGET_ABSOLUTE=$(shell readlink -f $(JAVA_BUILD_TARGET))

all: build

# Create portable bundle package ready to be installed.
build: build-subprojects docs
	Rscript -e "devtools::test()"
	Rscript -e "devtools::build()"

# Build subprojects. We assume that testing is a part of their building process.
build-subprojects:
	$(MAKE) -C $(SUBPROJECT_PATH_NUMBER_ADDER) build \
		BUILD_TARGET=$(JAVA_BUILD_TARGET_ABSOLUTE)

# Generate documentation.
docs:
	Rscript -e "devtools::document()"

# Run all tests. Tests in subprojects are not run explicitly because we assume
# that building them requires them to pass tests anyway.
test: build-subprojects
	Rscript -e "devtools::test()"

test-subprojects:
	$(MAKE) -C $(SUBPROJECT_PATH_NUMBER_ADDER) test

# Check the code and package structure for common problems; run tests.
# The number of ERRORs and WARNINGs should be zero. Ideally, the number of
# NOTE's also should be zero. Currently there's one NOTE that says that the
# paths to some of the files are too long (see README).
check: build
	Rscript -e "devtools::check()"

# Install the package in the system.
install: test docs
	R CMD INSTALL .

# Uninstall the package.
uninstall:
	R CMD REMOVE $(PACKAGE_NAME)

clean: clean-subprojects
	rm -rf man NAMESPACE *.tar.gz
	rm -rf $(JAVA_BUILD_TARGET)

clean-subprojects:
	$(MAKE) -C $(SUBPROJECT_PATH_NUMBER_ADDER) clean
