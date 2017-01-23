import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

const real eps = 1e-10;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto li = readln.split.to!(real[]);
  auto k = readln.chomp.to!size_t;

  li.sort!"a > b";

  bool canCreate(real a, real _) {
    auto i = size_t(0);
    foreach (l; li) {
      if (l < a) break;
      i += (l / a).floor.to!size_t;
      if (i >= k) return true;
    }
    return false;
  }
  
  auto r = iota(eps, li[0] + eps, eps).assumeSorted!canCreate.lowerBound(0.to!real);
  writefln("%.10f", r.back);
}
