import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], r = rd[1];
  auto s = readln.chomp;

  auto k = s.lastIndexOf('.');
  k = max(k-r+1, 0);
  if (k == -1) {
    writeln(0);
    return;
  }

  auto t = 0;
  while (!s.empty) {
    auto i = s.lastIndexOf('.');
    if (i == -1) break;
    ++t;
    i = max(i-r+1, 0);
    s = s[0..i];
  }

  writeln(k+t);
}
