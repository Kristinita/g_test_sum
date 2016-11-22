USER_DIR = ../
GTEST_DIR = external/googletest/googletest


CPPFLAGS += -I$(GTEST_DIR)/include
CPPFLAGS += -I$(USER_DIR)

CXXFLAGS += -g -Wall -Wextra

TESTS = summator_unittest

GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
$(GTEST_DIR)/include/gtest/internal/*.h

###################################################################

all : $(TESTS)

###################################################################
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

###################################################################
test/obj/gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	$(GTEST_DIR)/src/gtest-all.cc -o $@

test/obj/gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
	$(GTEST_DIR)/src/gtest_main.cc -o $@

test/obj/gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

test/obj/gtest_main.a : test/obj/gtest-all.o test/obj/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

###################################################################
test/obj/summator.o : src/summator.cpp src/summator.h
	$(CXX)  -c src/summator.cpp -o $@

test/obj/summator_unittest.o : test/summator_unittest.cpp \
	src/summator.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c test/summator_unittest.cpp -o $@

summator_unittest :
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) src/summator.cpp test/summator_unittest.cpp -o $@
