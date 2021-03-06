ifeq ($(OS),Windows_NT)
    $(info Building on Windows/MinGW)
    GET_THE_BALL_ROLLIN = dir #summator_unittest.exe
    CC = g++
    FIN_C = g++ $(CPPFLAGS) $(CXXFLAGS) $^ -DWINVER=0x0500 -o $@
  else
      UNAME_S := $(shell uname -s)
      ifeq ($(UNAME_S),Linux)
        $(info Building from Linux)
          GET_THE_BALL_ROLLIN = ./summator_unittest
	  CC=i586-mingw32msvc-g++
	  FIN_C = g++ $(CPPFLAGS) $(CXXFLAGS) $^ -DWINVER=0x0500 -lpthread  -o $@
      endif
  endif


USER_DIR = ../
GTEST_DIR = external/googletest/googletest


CPPFLAGS += -I$(GTEST_DIR)/include
CPPFLAGS += -I$(USER_DIR)

CXXFLAGS += -g -Wall -Wextra 

TESTS = summator_unittest

GTEST_HEADERS := $(GTEST_DIR)/include/gtest/*.h \
	$(GTEST_DIR)/include/gtest/internal/*.h

CC_AND_OTHER := $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

FOR_TEST := $(wildcard $(CC_AND_OTHER))
SOURCE_FILES := $(wildcard $(GTEST_HEADERS))

###################################################################

all : $(TESTS) run

run:
	$(GET_THE_BALL_ROLLIN)

clean :
	rm -f $(TESTS) obj/gtest.a obj/gtest_main.a *.o obj/*.o

###################################################################
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

###################################################################
test/gtest-all.o : $(GTEST_SRCS_)
	g++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	$(GTEST_DIR)/src/gtest-all.cc -lpthread -DWINVER=0x0500 -o $@

test/gtest_main.o : $(GTEST_SRCS_)
	g++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
		$(GTEST_DIR)/src/gtest_main.cc -lpthread -o $@

test/gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

test/gtest_main.a : test/gtest-all.o test/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

###################################################################
test/summator.o : src/summator.cpp src/summator.h
	g++  -c src/summator.cpp -o $@

test/summator_unittest.o : test/summator_unittest.cpp \
	src/summator.h $(SOURCE_FILES)
	g++ $(CPPFLAGS) $(CXXFLAGS) -c test/summator_unittest.cpp -o $@

summator_unittest : \
	test/summator.o \
	test/summator_unittest.o \
	test/gtest_main.a
	$(FIN_C)
