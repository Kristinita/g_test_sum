#include <limits.h>
#include "../src/summator.h"
#include "gtest/gtest.h"

TEST(SummTest, Positive_result_summ)
{
  EXPECT_EQ(5, sum(2, 3));
  EXPECT_EQ(6, sum(3, 3));
  EXPECT_EQ(7, sum(4, 3));
}
