import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto vti = n.iota.map!(_ => readln.split.to!(int[])).map!(rd => VT(rd[0], rd[1])).array;
  vti.sort!"a.v + a.t < b.v + b.t";

  auto maxV = vti.back.v + vti.back.t;

  auto dp = BitArray();
  dp.length(maxV);
  dp[0] = true;

  foreach (vt; vti) {
    auto dp2 = dp & mask(vt.t, dp.length);
    dp2 <<= vt.v;
    dp |= dp2;
  }

  writeln(dp.bitsSet.tail(1).front);
}

auto mask(int t, size_t sz)
{
  auto b = new size_t[]((sz + 63) / 64);
  b[0..t/64][] = size_t.max;
  b[t/64] = (size_t(1) << (t % 64)) - 1;
  return BitArray(b, sz);
}

struct VT { int v, t; }
