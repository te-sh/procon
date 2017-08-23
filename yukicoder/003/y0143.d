import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), k = rd[0], n = rd[1], f = rd[2];
  auto ai = readln.split.to!(int[]);

  auto sumA = ai.sum;
  if (sumA > k * n)
    writeln(-1);
  else
    writeln(k * n - sumA);
}
