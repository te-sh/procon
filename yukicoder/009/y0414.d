import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!long;

  foreach (i; 2..m.nsqrt+1)
    if (m % i == 0) {
      writeln(i, " ", m/i);
      return;
    }

  writeln(1, " ", m);
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
