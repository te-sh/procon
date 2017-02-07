import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1], t = rd[2];

  auto ma = min((t + b - 1) / b, a / gcd(a, b) * b);
  auto r = long.max;
  foreach (y; 0..ma+1)
    r = min(r, y * b + (t - y * b + a - 1) / a * a);

  writeln(r);
}
