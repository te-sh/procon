import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t, n2 = n * 2 - 1;

  auto ref newBitArray(size_t n) {
    auto r = BitArray();
    r.length = n;
    return r;
  }

  size_t[][int] c;
  auto rda = readln.chomp.splitter;
  foreach (i; 0..n) {
    c[rda.front.to!int] ~= i;
    rda.popFront();
  }

  auto b = newBitArray(n2), rdb = readln.chomp.splitter;
  foreach (i; 0..n) {
    b[i] = rdb.front.to!int.to!bool;
    rdb.popFront();
  }

  auto r = newBitArray(n2), d = newBitArray(n2), tb = newBitArray(n2);
  foreach (ci; c.byValue) {
    (cast(size_t[]) d)[] = 0;
    (cast(size_t[]) tb)[] = (cast(size_t[]) b)[];
    auto p = size_t(0), h = size_t(0);
    foreach (cii; ci) {
      if (cii > 0) tb.shift(cii - p);
      d |= tb;
      p = cii;
    }
    r ^= d;
  }

  foreach (i; 0..n2)
    writeln(r[i] ? "ODD" : "EVEN");
}

auto shift(ref BitArray ba, size_t i)
{
  if (i > 0 && i % 64 == 0) {
    ba <<= 1;
    ba <<= i-1;
  } else {
    ba <<= i;
  }
}
