import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto r = 1L;
  foreach (i; 1..n+1) {
    (r *= i) %= 10L^^12;
    if (r == 0) break;
  }

  if (n > 14)
    writefln("%012d", r);
  else
    writeln(r);
}
