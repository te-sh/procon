import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto b = readln.split.to!(int[]);
  auto c = readln.split.to!(int[]);
  c.sort();

  auto ans = 0;
  do {
    ans = max(ans, (b[0]/c[0]) * (b[1]/c[1]) * (b[2]/c[2]));
  } while (c.nextPermutation);

  writeln(ans);
}
