pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr/2+1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}

pure T ncbrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr/3+1);
  return iota(1, m).map!"a * a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}

unittest
{
  assert(nsqrt(1) == 1);
  assert(nsqrt(2) == 1);
  assert(nsqrt(3) == 1);
  assert(nsqrt(4) == 2);
  assert(nsqrt(5) == 2);
  assert(nsqrt(8) == 2);
  assert(nsqrt(9) == 3);
}

unittest
{
  assert(ncbrt(1) == 1);
  assert(ncbrt(2) == 1);
  assert(ncbrt(3) == 1);
  assert(ncbrt(8) == 2);
  assert(ncbrt(9) == 2);
  assert(ncbrt(26) == 2);
  assert(ncbrt(27) == 3);
}
