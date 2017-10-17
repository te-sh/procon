import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, t = rd1[0].to!int, n = rd1[1].to!size_t, p = rd1[2].to!real;

  auto qxs = new real[](t), qs = new real[](t);
  qxs[] = 0;
  qs[] = 0;

  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto qi = rd2.front.to!real; rd2.popFront();
    auto xi = rd2.front.to!real; rd2.popFront();
    auto ti = rd2.front.to!int;

    qxs[min(t-1, ti)] += qi * xi;
    if (ti <= t-1) qs[ti] += qi;
  }

  foreach (i; 0..t-1) qs[i+1] += qs[i];
  foreach_reverse (i; 0..t-1) qxs[i] += qxs[i+1];

  auto qt = new real[](t);
  foreach (i; 1..t) qt[i] = qxs[i] + qs[i-1];

  auto bk = new real[](t);
  bk[0] = 1;
  foreach (i; 1..t) bk[i] = p * qt[i] + (1-p);

  foreach (i; 2..t) bk[i] *= bk[i-1];

  writefln("%f", bk.sum);
}
