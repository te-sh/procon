import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), r = rd1[0], c = rd1[1], k = rd1[2];
  auto n = readln.chomp.to!size_t;
  auto y = new int[](n), x = new int[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]), yi = rd2[0], xi = rd2[1];
    y[i] = yi-1;
    x[i] = xi-1;
  }

  auto nr = new int[](r), nc = new int[](c);
  foreach (yi, xi; lockstep(y, x)) {
    ++nr[yi];
    ++nc[xi];
  }

  auto cn = new int[](n+1);
  foreach (nci; nc) ++cn[nci];

  auto ans = 0L;
  foreach (i; 0..r) {
    auto j = k - nr[i];
    if (j >= 0 && j <= n) ans += cn[j];
  }

  foreach (yi, xi; lockstep(y, x)) {
    if (nr[yi] + nc[xi] == k) --ans;
    if (nr[yi] + nc[xi] == k+1) ++ans;
  }

  writeln(ans);
}
