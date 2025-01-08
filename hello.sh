#!/bin/bash
clang_hello() {
	cat <<EOF > ~/iniproj/hello.c
#include <stdio.h>
int main() {
	printf("Hello World from C. ");
	return 0;
}
EOF
	clang -o hello_c hello.c
	./hello_c
}

cpp_hello() {
	cat <<EOF > ~/iniproj/hello.cpp
#include <iostream>
int main() {
	std::cout << "Hello World from C++. " << std::endl;
	return 0;
}
EOF
	clang++ -o hello_cpp hello.cpp
	./hello_cpp
}

java_hello() {
	cat <<EOF > ~/iniproj/hello.java
public class hello {
    public static void main(String[] args) {
        System.out.println("Hello World from Java. ");
    }
}
EOF
	javac hello.java && java hello
}

python_hello() {
	cat <<EOF > ~/iniproj/hello.py
print("Hello World from Python. ")
EOF
	python3 hello.py
}

julia_hello() {
	cat <<EOF > ~/iniproj/hello.jl
println("Hello World from Julia. ")
EOF
	julia ~/iniproj/hello.jl
}

js_hello() {
	cat <<EOF > ~/iniproj/hello.js
console.log("Hello World from Javascript. ")
EOF
	node ~/iniproj/hello.js
}

sql_hello() {
	cat <<EOF > ~/iniproj/hello.sql
CREATE DATABASE IF NOT EXISTS inidb;
USE inidb;
CREATE TABLE IF NOT EXISTS ini_table (
	id INT AUTO_INCREMENT PRIMARY KEY,
	message VARCHAR(255) NOT NULL
);
INSERT INTO ini_table (message) VALUES ('Hello World from MySQL. ');
SELECT * FROM ini_table;
EOF
	mysql -u root < ~/iniproj/hello.sql
}

r_hello() {
	LC_ALL=en_US.UTF-8 Rscript -e 'cat("Hello World from R.\n")'
}

open_vscode() {
	cd ~/iniproj
	code .
	code --
}

main_hello() {
	mkdir -p ~/iniproj
	cd ~/iniproj
	echo "Testing programming languages that work in terminal: "
	clang_hello
	cpp_hello
	java_hello
	python_hello
	js_hello
	sql_hello
	r_hello
	julia_hello
	open_vscode
}

main_hello