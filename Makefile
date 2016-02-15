# You may need to edit this file to reflect the type and capabilities of your system.
# The defaults are for a Linux system and may need to be changed for other systems (eg. Mac OS X).  

# location of the Python header files
 
PYTHON_VERSION = 2.7
PYTHON_INCLUDE = /usr/include/python$(PYTHON_VERSION)
 
# location of the Boost Python include files and library
 
BOOST_INC = /usr/include
BOOST_LIB = /usr/lib/x86_64-linux-gnu
USR_LIB = /usr/lib
ARMA_LIB = /home/<name>/armadillo-6.300.2
 
# compile mesh classes
TARGET = primary
CXX=g++

#CXX=CC
## When using the Sun Studio compiler


# flags configured by CMake
#ifeq (unix,macos)
#else
  #LIB_FLAGS = -O2 -I /home/blah/armadillo-5.600.2/include -DARMA_DONT_USE_WRAPPER -llapack -lblas -lgfortran -larmadillo
#  ## NOTE: on Ubuntu and Debian based systems you may need to add -lgfortran
  
  # LIB_FLAGS = -larmadillo -library=sunperf
  ## When using the Sun Studio compiler
#endif

OPT = -O2

CXXFLAGS = $(DEBUG) $(FINAL) $(OPT) $(EXTRA_OPT)
OBJ_FILE = example1.o example2.o example3.o
LIB_FLAGS = -larmadillo -llapack -lblas -lgfortran

$(TARGET).so: $(TARGET).o secondary.o $(OBJ_FILE)
	g++ -shared -Wl,--export-dynamic $(TARGET).o -L$(BOOST_LIB) -lboost_python -L/usr/lib/python$(PYTHON_VERSION)/config -L$(ARMA_LIB) -lpython$(PYTHON_VERSION) -L$(USR_LIB) -o $(TARGET).so secondary.o $(OBJ_FILE) $(USR_LIB)/libblas.so $(USR_LIB)/liblapack.so $(ARMA_LIB)/libarmadillo.so

$(TARGET).o: $(TARGET).cpp
	g++ -I$(PYTHON_INCLUDE) -I$(BOOST_INC) -fPIC -c $(TARGET).cpp

secondary.o: secondary.cpp
	$(CXX) $(CXXFLAGS) -L$(ARMA_LIB) $(LIB_FLAGS) -I$(PYTHON_INCLUDE) -DARMA_DONT_USE_WRAPPER -I$(BOOST_INC) -fPIC -c secondary.cpp

example3.o: example3.cpp
	$(CXX) $(CXXFLAGS) $(LIB_FLAGS) -fPIC -c example3.cpp

example2.o: example2.cpp
	$(CXX) $(CXXFLAGS) $(LIB_FLAGS) -fPIC -c example2.cpp

example1.o: example1.cpp
	$(CXX) $(CXXFLAGS) $(LIB_FLAGS) -fPIC -c example1.cpp

test: test.cpp
	$(CXX) $(CXXFLAGS)  -o $@  $<  $(LIB_FLAGS)

clean:
	rm -f ${OBJ_FILE} ${EXE_FILE}
