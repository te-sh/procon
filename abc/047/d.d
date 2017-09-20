import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], t = rd[1];
  auto a = readln.split.to!(int[]);

  auto b = new int[](n-1), m = a[0];
  foreach (i; 0..n-1) {
    b[i] = a[i+1] - m;
    m = min(m, a[i+1]);
  }

  auto c = b.reduce!max;
  writeln(b.count(c));
}
