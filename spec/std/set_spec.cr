require "spec"
require "set"

describe "Set" do
  describe "set" do
    it "is empty" do
      Set(Nil).new.empty?.should be_true
    end

    it "has length 0" do
      Set(Nil).new.length.should eq(0)
    end
  end

  describe "add" do
    it "adds and includes" do
      set = Set(Int32).new
      set.add 1
      set.includes?(1).should be_true
      set.length.should eq(1)
    end
  end

  describe "delete" do
    it "deletes an object" do
      set = Set{1, 2, 3}
      set.delete 2
      set.length.should eq(2)
      set.includes?(1).should be_true
      set.includes?(3).should be_true
    end
  end

  describe "==" do
    it "compares two sets" do
      set1 = Set{1, 2, 3}
      set2 = Set{1, 2, 3}
      set3 = Set{1, 2, 3, 4}

      set1.should eq(set1)
      set1.should eq(set2)
      set1.should_not eq(set3)
    end
  end

  it "does &" do
    set1 = Set{1, 2, 3}
    set2 = Set{4, 2, 5, 3}
    set3 = set1 & set2
    set3.should eq(Set{2, 3})
  end

  it "does |" do
    set1 = Set{1, 2, 3}
    set2 = Set{4, 2, 5, 3}
    set3 = set1 | set2
    set3.should eq(Set{1, 2, 3, 4, 5})
  end

  it "does to_a" do
    Set{1, 2, 3}.to_a.should eq([1, 2, 3])
  end

  it "does to_s" do
    Set{1, 2, 3}.to_s.should eq("Set{1, 2, 3}")
    Set{"foo"}.to_s.should eq(%(Set{"foo"}))
  end

  it "does clear" do
    x = Set{1, 2, 3}
    x.to_a.should eq([1, 2, 3])
    x.clear.should be(x)
    x << 1
    x.to_a.should eq([1])
  end

  it "compares hashes of sets" do
    h1 = { Set{1, 2, 3} => 1 }
    h2 = { Set{1, 2, 3} => 1 }
    h1.should eq(h2)
  end

  it "gets each iterator" do
    iter = Set{1, 2, 3}.each
    iter.next.should eq(1)
    iter.next.should eq(2)
    iter.next.should eq(3)
    iter.next.should be_a(Iterator::Stop)

    iter.rewind
    iter.next.should eq(1)
  end
end
