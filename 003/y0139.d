import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, l = rd1[1].to!int;
  auto xi = new int[](n), wi = new int[](n), ti = new int[](n);
  foreach (i; n.iota) {
    auto rd2 = readln.split.to!(int[]);
    xi[i] = rd2[0];
    wi[i] = rd2[1];
    ti[i] = rd2[2];
  }

  auto ct = 0, cx = 0;
  foreach (x, w, t; lockstep(xi, wi, ti)) {
    ct += x - cx;
    cx = x;
    if (ct / t % 2 == 1 || (ct + w) / t % 2 == 1 && (ct + w) % t != 0)
      ct = (ct / (2 * t) + 1) * (2 * t);
    ct += w;
    cx += w;
  }
  ct += l - cx;

  writeln(ct);
}
