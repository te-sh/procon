import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1] - 1;
  auto s = readln.chomp.split("").to!(int[]);

  auto ni = new int[](n);
  auto u = 0, v = 0;
  foreach (i, c; s) {
    ++u;
    if (v > 0) {
      --u;
      --v;
    }
    v += c;
    ni[i] = u;
  }

  if (k < n) {
    writeln(ni[k]);
  } else {
    auto r = ni[$-1];
    k -= n;
    r += (k / n) * max(0, ni[$-1] - v) + max(0, ni[k % n] - v);
    writeln(r);
  }
}
