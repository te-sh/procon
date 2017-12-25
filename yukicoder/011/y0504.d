import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto kp = readln.chomp.to!int;
  writeln(1);

  auto r = 1;
  foreach (i; 0..n-1) {
    auto p = readln.chomp.to!int;
    if (p > kp) ++r;
    writeln(r);
  }
}
