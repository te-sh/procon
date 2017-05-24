import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

const long[] fermats = [3,5,17,257,65537];

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!long;

  auto count(long pf)
  {
    auto r = 0;
    for (; pf <= a; pf *= 2)
      if (pf >= 3) ++r;
    return r;
  }

  auto r = 0;
  foreach (i; 0..(1 << 5)) {
    auto pf = fermats.indexed(i.bitsSet).fold!"a * b"(1L);
    r += count(pf);
  }

  writeln(r);
}
