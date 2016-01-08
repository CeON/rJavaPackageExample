all: build

build:
	mvn package
	# Copy the produced JAR files to a directory specified by parent Makefile
	# in the variable used below.
	cp target/*.jar $(JAVA_BUILD_TARGET_ABSOLUTE)

test:
	mvn test

clean:
	rm -rf target
