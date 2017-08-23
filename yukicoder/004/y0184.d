import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(ulong[]);

  auto find(ulong[] ai, size_t i, size_t j) {
    return ai[i..$].countUntil!(a => a.bitTest(j));
  }

  size_t i, j;
  while (i < n && j < 61) {
    auto i2 = find(ai, i, j);
    if (i2 == -1) {
      ++j;
      continue;
    }

    swap(ai[i], ai[i + i2]);

    auto ab = ai[i];
    foreach (ref a; ai[i+1..$])
      if (a.bitTest(j)) a ^= ab;

    ++i; ++j;
  }

  writeln(BigInt(2) ^^ ai.count!"!!a");
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
}
