import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = readln.split.to!(int[]);

  a.sort!"a > b";

  auto ans = 0;
  foreach (i; 0..(n+1)/2)
    ans += a[i*2];

  writeln(ans);
}
