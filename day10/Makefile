.PHONY: build run clean

build:
	python setup.py build_ext --inplace

run: build
	python -c "print('First: ', end=''); import first; print('Second: ', end=''); import second"

clean:
	rm -rf build *.c *.so 
