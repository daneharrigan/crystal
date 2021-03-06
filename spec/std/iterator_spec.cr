require "spec"
require "iterator"

describe Iterator do
  describe "map" do
    it "does map with Range iterator" do
      iter = (1..3).each.map &.*(2)
      iter.next.should eq(2)
      iter.next.should eq(4)
      iter.next.should eq(6)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(2)
    end
  end

  describe "select" do
    it "does select with Range iterator" do
      iter = (1..3).each.select &.>=(2)
      iter.next.should eq(2)
      iter.next.should eq(3)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(2)
    end
  end

  describe "reject" do
    it "does reject with Range iterator" do
      iter = (1..3).each.reject &.>=(2)
      iter.next.should eq(1)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(1)
    end
  end

  describe "take" do
    it "does take with Range iterator" do
      iter = (1..3).each.take(2)
      iter.next.should eq(1)
      iter.next.should eq(2)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(1)
    end

    it "does take with more than available" do
      (1..3).each.take(10).to_a.should eq([1, 2, 3])
    end
  end

  describe "skip" do
    it "does skip with Range iterator" do
      iter = (1..3).each.skip(2)
      iter.next.should eq(3)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(3)
    end
  end

  describe "zip" do
    it "does skip with Range iterator" do
      r1 = (1..3).each
      r2 = (4..6).each
      iter = r1.zip(r2)
      iter.next.should eq({1, 4})
      iter.next.should eq({2, 5})
      iter.next.should eq({3, 6})
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq({1, 4})
    end
  end

  describe "cycle" do
    it "does cycle from range" do
      iter = (1..3).each.cycle
      iter.next.should eq(1)
      iter.next.should eq(2)
      iter.next.should eq(3)
      iter.next.should eq(1)
      iter.next.should eq(2)

      iter.rewind
      iter.next.should eq(1)
    end

    it "cycles an empty array" do
      ary = [] of Int32
      values = ary.each.cycle.to_a
      values.empty?.should be_true
    end
  end

  describe "with_index" do
    it "does with_index from range" do
      iter = (1..3).each.with_index
      iter.next.should eq({1, 0})
      iter.next.should eq({2, 1})
      iter.next.should eq({3, 2})
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq({1, 0})
    end

    it "does with_index with offset from range" do
      iter = (1..3).each.with_index(10)
      iter.next.should eq({1, 10})
      iter.next.should eq({2, 11})
      iter.next.should eq({3, 12})
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq({1, 10})
    end
  end

  describe "with object" do
    it "does with object" do
      iter = (1..3).each.with_object("a")
      iter.next.should eq({1, "a"})
      iter.next.should eq({2, "a"})
      iter.next.should eq({3, "a"})
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq({1, "a"})
    end
  end

  describe "slice" do
    it "slices" do
      iter = (1..8).each.slice(3)
      iter.next.should eq([1, 2, 3])
      iter.next.should eq([4, 5, 6])
      iter.next.should eq([7, 8])
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq([1, 2, 3])
    end
  end

  describe "uniq" do
    it "without block" do
      iter = (1..8).each.map { |x| x % 3 }.uniq
      iter.next.should eq(1)
      iter.next.should eq(2)
      iter.next.should eq(0)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(1)
    end

    it "with block" do
      iter = (1..8).each.uniq { |x| x % 3 }
      iter.next.should eq(1)
      iter.next.should eq(2)
      iter.next.should eq(3)
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq(1)
    end
  end

  it "combines many iterators" do
    (1..100).each
            .select { |x| 50 <= x < 60 }
            .map { |x| x * 2 }
            .take(3)
            .to_a
            .should eq([100, 102, 104])
  end
end
