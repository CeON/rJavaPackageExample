all: build

build: build-assert-env-variables-are-set
	mvn package
	# Copy the produced JAR files to a directory specified by parent Makefile
	# in the variable used below.
	cp target/*.jar $(BUILD_TARGET)

# Write an error message and exit if the required variable is not set
build-assert-env-variables-are-set:
ifndef BUILD_TARGET
	$(error Variable BUILD_TARGET is undefined. It should be set as a parameter\
		when calling make)
endif

test:
	mvn test

clean:
	rm -rf target
