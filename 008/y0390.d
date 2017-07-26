import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto x = readln.split.to!(int[]);
  x.sort();

  auto maxX = x.back;

  auto b = new size_t[](maxX+1);
  b[] = n;
  foreach (i, xi; x) b[xi] = i;

  auto w = new int[](n);

  foreach (i, xi; x) {
    if (!w[i]) w[i] = 1;

    for (auto j = xi * 2; j <= maxX; j += xi)
      if (b[j] < n) w[b[j]] = max(w[b[j]], w[i] + 1);
  }

  writeln(w.maxElement);
}
