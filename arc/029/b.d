import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(real[]), a = rd1[0], b = rd1[1];
  auto a2 = atan2(b, a), b2 = atan2(a, b);
  auto n = readln.chomp.to!size_t;
  foreach (_; 0..n) {
    auto rd2 = readln.split.to!(int[]), c = rd2[0], d = rd2[1];
    auto c2 = c / sqrt(a^^2+b^^2), d2 = d / sqrt(a^^2+b^^2);

    if (c2 >= 1) {
      if (d2 >= 1) {
        writeln("YES");
      } else {
        auto ds = asin(d2);
        writeln(ds - a2 >= 0 || PI - ds - a2 <= PI/2 ? "YES" : "NO");
      }
    } else {
      auto cs = asin(c2);
      if (d2 >= 1) {
        writeln(cs - b2 >= 0 || PI - cs - b2 <= PI/2 ? "YES" : "NO");
      } else {
        auto ds = asin(d2);
        writeln(min(cs - b2, ds - a2) >= 0 ||
                max(PI - cs - b2, PI - ds - a2) <= PI/2 ||
                cs - b2 >= PI - ds - a2 ||
                ds - a2 >= PI - cs - b2 ? "YES" : "NO");
      }
    }
  }
}
