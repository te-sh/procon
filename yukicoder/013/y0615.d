import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto a = readln.split.to!(long[]);
  a.sort();

  if (k == 1) {
    writeln(a[n-1] - a[0]);
    return;
  }

  auto b = new long[](n-1);
  foreach (i; 0..n-1) b[i] = a[i+1]-a[i];

  b.sort!"a > b";

  writeln(a[n-1] - a[0] - b[0..k-1].sum);
}
