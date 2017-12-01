import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.to!int;
  auto t = s.map!(c => cast(int)(c - '0')).array;

  auto judge()
  {
    if (n == 1) return false;
    if (n.isPrime) return true;
    if (t[$-1] % 2 != 0 && t[$-1] != 5 && t.sum % 3 != 0) return true;
    return false;
  }

  writeln(judge ? "Prime" : "Not Prime");
}

auto isPrime(int n)
{
  foreach (i; 2..n.nsqrt+1)
    if (n % i == 0) return false;
  return true;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
