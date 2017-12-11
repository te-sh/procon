import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];

  auto t = [1, 3, 2, 4];

  foreach (i; 0..n) {
    write(i < n-k ? t[i%4] : t[(n-k-1)%4]);
    if (i < n-1) write(" ");
  }

  writeln;
}
