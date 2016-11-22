# A sample Makefile for building Google Test and using it in user
# tests. Please tweak it to suit your environment and project. You
# may want to move it to your project's root directory.
#
# SYNOPSIS:
#
# make [all] - makes everything.
# make TARGET - makes the given target.
# make clean - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file.
GTEST_DIR = external/googletest/googletest
# Where to find user code.
USER_DIR = ../

# Flags passed to the preprocessor.
CPPFLAGS += -I$(GTEST_DIR)\include
CPPFLAGS += -I$(USER_DIR)

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra

# All tests produced by this Makefile. Remember to add new tests you
# created to the list.
TESTS = summator_unittest

# All Google Test headers. Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
$(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.

all : $(TESTS)

clean :
	rm -f $(TESTS) obj/gtest.a obj/gtest_main.a *.o obj/*.o

# Builds gtest.a and gtest_main.a.

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized. This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
obj/gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	$(GTEST_DIR)/src/gtest-all.cc -o $@

obj/gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	$(GTEST_DIR)/src/gtest_main.cc -o $@

obj/gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

obj/gtest_main.a : obj/gtest-all.o obj/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

# Builds a sample test. A test should link with either gtest.a or
# gtest_main.a, depending on whether it defines its own main()
# function.
obj/summator.o : $(USER_DIR)/src/summator.cpp $(USER_DIR)/src/summator.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/src/summator.cpp -o $@

obj/summator_unittest.o : $(USER_DIR)/Test/summator_unittest.cpp \
	$(USER_DIR)/src/summator.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/Test/summator_unittest.cpp -o $@

summator_unittest : \
	obj/summator.o \
	obj/summator_unittest.o \
	obj/gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@
