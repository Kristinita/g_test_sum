
GTEST_DIR = external/googletest/googletest
USER_DIR = ../

CPPFLAGS += -I$(GTEST_DIR)\include
CPPFLAGS += -I$(USER_DIR)

CXXFLAGS += -g -Wall -Wextra

TESTS = summator_unittest

GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
$(GTEST_DIR)/include/gtest/internal/*.h

###################################################################

all : $(TESTS)

clean :
	rm -f $(TESTS) obj/gtest.a obj/gtest_main.a *.o obj/*.o

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

test/obj/gtest_main.a : obj/gtest-all.o obj/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

###################################################################
test/obj/summator.o : $(USER_DIR)/src/summator.cpp $(USER_DIR)/src/summator.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/src/summator.cpp -o $@

test/obj/summator_unittest.o : $(USER_DIR)/test/summator_unittest.cpp \
	$(USER_DIR)/src/summator.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/test/summator_unittest.cpp -o $@

test/summator_unittest : \
	test/obj/summator.o \
	test/obj/summator_unittest.o \
	test/obj/gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@
