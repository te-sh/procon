import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto c = new int[](n);
  foreach (i; 0..n) c[i] = readln.chomp.to!int;

  auto l = [c[0]];
  foreach (ci; c[1..$]) {
    if (l[$-1] < ci) {
      l ~= ci;
    } else {
      l.assumeSorted.upperBound(ci)[0] = ci;
    }
  }

  writeln(n - l.length);
}
