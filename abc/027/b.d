import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  if (a.sum % n != 0) {
    writeln(-1);
    return;
  }
  auto b = a.sum / n;

  auto r = 0, s = size_t(0);
  while (s < n) {
    auto t = s, u = a[s];
    while (u != b * (t-s+1)) {
      ++r;
      u += a[++t];
    }

    s = t+1;
  }

  writeln(r);
}
