all: build

build: target/*.jar

target/*.jar: pom.xml $(shell find src -name '*')
	mvn package

test:
	mvn test

clean:
	rm -rf target
