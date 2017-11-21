import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], k = rd[1];
  auto a = readln.split.to!(long[]).sort();
  auto b = readln.split.to!(long[]).sort();

  auto calc(long x)
  {
    auto ans = 0L;
    foreach (i; 0..n)
      ans += a.lowerBound(x/b[i]+1).length;
    return ans;
  }

  auto bsearch = iota(1, a[n-1]*b[n-1]+1).map!(x => tuple(x, calc(x))).assumeSorted!"a[1] < b[1]";
  writeln(bsearch.lowerBound(tuple(0, k)).back[0]+1);
}
