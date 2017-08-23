import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  foreach (i; 3..n.nsqrt+1) {
    if (n % i == 0) {
      writeln(i);
      return;
    }
  }

  if (n % 2 == 0 && n > 4)
    writeln(n/2);
  else
    writeln(n);
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
