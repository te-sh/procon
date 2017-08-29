import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  n %= 30;

  auto c = [1,2,3,4,5,6];
  foreach (i; 0..n) swap(c[i%5], c[i%5+1]);

  foreach (ci; c) write(ci);
  writeln;
}
