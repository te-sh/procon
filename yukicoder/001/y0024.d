import std.algorithm, std.conv, std.range, std.stdio, std.string;
import core.bitop;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto c = toBuf(10.iota);

  foreach (_; n.iota) {
    auto rd = readln.split, ai = rd[0..4].to!(int[]), yn = rd[4];

    auto b = toBuf(ai);
    c = yn.predSwitch("YES", c & b, "NO", c & ~b);
  }

  writeln(bsr(c));
}

auto toBuf(Range)(Range ai)
  if (isInputRange!Range)
{
  return ai.map!"1 << a".reduce!"a | b";
}

unittest
{
  assert(toBuf([0]) == 1);
  assert(toBuf([0, 1]) == 3);
}
