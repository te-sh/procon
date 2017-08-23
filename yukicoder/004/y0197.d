import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s1 = toInt(readln.chomp);
  auto n = readln.chomp.to!size_t;
  auto s2 = toInt(readln.chomp);

  writeln(calc(s1, s2, n) ? "SUCCESS" : "FAILURE");
}

auto toInt(string s)
{
  auto r = 0;
  foreach (c; s) {
    r <<= 1;
    r |= c == 'o' ? 1 : 0;
  }
  return r;
}

auto calc(int s1, int s2, size_t n)
{
  auto t1 = s1.popcnt, t2 = s2.popcnt;
  if (t1 != t2) return true;
  if (t1 == 0 || t1 == 3) return false;
  if (t1 == 2) { s1 = ~s1 & 7; s2 = ~s2 & 7; }

  auto i1 = s1.bsf, i2 = s2.bsf;
  if (n == 0)
    return i1 != i2;
  else if (n == 1)
    return i1 == 1 ? i2 == 1 : (i1 != i2 && i2 != 1);
  else
    return false;
}

pragma(inline) {
  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
