PACKAGE_NAME=rJavaPackageExample
# Path to subproject. If there are more subprojects, more variables like this
# have to be added.
SUBPROJECT_PATH_NUMBER_ADDER=java/number-adder


# Directory where build package should be placed.
BUILD_TARGET=./target
# Place where the produced Jar files should go.
JAVA_BUILD_TARGET=./inst/java

all: build

# Create portable bundle package ready to be installed.
build: build-subprojects test docs
	mkdir -p $(BUILD_TARGET)
	Rscript -e "devtools::build(path = \"$(BUILD_TARGET)\")"

# Build subprojects. We assume that testing is a part of their building process.
build-subprojects:
	rm -rf $(JAVA_BUILD_TARGET)
	mkdir -p $(JAVA_BUILD_TARGET)
	# The "readlink" command below returns absolute path to the directory.
	$(MAKE) -C $(SUBPROJECT_PATH_NUMBER_ADDER) build \
		BUILD_TARGET=$(shell readlink -f $(JAVA_BUILD_TARGET))

# Generate documentation.
docs:
	Rscript -e "devtools::document()"

# Run all tests. Tests in subprojects are not run explicitly because we assume
# that building them requires them to pass tests anyway.
test: build-subprojects
	./run_all_tests.R

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
	rm -rf $(BUILD_TARGET)

clean-subprojects:
	$(MAKE) -C $(SUBPROJECT_PATH_NUMBER_ADDER) clean
