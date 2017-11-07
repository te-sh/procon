import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!long;
  auto n = readln.chomp.to!size_t;
  auto a = new long[](n), d = new long[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    a[i] = rd.front.to!int; rd.popFront();
    d[i] = rd.front.to!int;
  }

  struct VKS { long v, k, s; }

  auto calc(long v)
  {
    auto k = 0L, s = 0L;
    foreach (i; 0..n) {
      if (v <= a[i]) continue;
      auto ki = (v - a[i] - 1) / d[i] + 1;
      k += ki;
      s += a[i] * ki + ki * (ki-1) / 2 * d[i];
    }
    return VKS(v, k, s);
  }

  auto vm = 0L;
  foreach (i; 0..n)
    vm = max(vm, a[i] + k * d[i]);

  auto r = iota(1, vm+1).map!(v => calc(v)).assumeSorted!"a.k < b.k".lowerBound(VKS(0, k, 0)).back;
  writeln(r.s + r.v * (k - r.k));
}
