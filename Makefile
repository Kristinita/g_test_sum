USER_DIR = ../
GTEST_DIR = external/googletest/googletest


CPPFLAGS += -I$(GTEST_DIR)/include
CPPFLAGS += -I$(USER_DIR)

CXXFLAGS += -g -Wall -Wextra

TESTS = summator_unittest

GTEST_HEADERS := $(GTEST_DIR)/include/gtest/*.h \
$(GTEST_DIR)/include/gtest/internal/*.h

SOURCE_FILES := $(wildcard $(GTEST_HEADERS))

###################################################################

all : test/summator.o test/gtest_main.a test/summator_unittest.o
	#$(CC) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

clean :
	rm -f $(TESTS) obj/gtest.a obj/gtest_main.a *.o obj/*.o

###################################################################
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

###################################################################
test/gtest-all.o : $(GTEST_SRCS_)
	g++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
		$(GTEST_DIR)/src/gtest-all.cc -o $@

test/gtest_main.o : $(GTEST_SRCS_)
	g++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
		$(GTEST_DIR)/src/gtest_main.cc -o $@

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
	g++ $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@
