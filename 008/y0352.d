import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -6

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto r = real(1);
  foreach (i; 1..n) {
    auto s = i;
    foreach (a; 1..i+1)
      foreach (b; a+1..i+1)
        s += a * b;

    r += s.to!real * 2 / (i + 1) / i;
  }

  writefln("%.7f", r);
}
