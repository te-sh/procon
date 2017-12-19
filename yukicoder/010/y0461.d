import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto f = new Frac[][](3);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    auto p = rd.front.to!int; rd.popFront();
    auto a = rd.front.to!int; rd.popFront();
    auto b = rd.front.to!int;
    auto g = gcd(b, a+b);
    f[p] ~= Frac(b/g, (a+b)/g);
  }

  foreach (i; 0..3) {
    f[i] ~= Frac(0, 1);
    f[i] = f[i].sort().uniq.array;
  }

  auto ans = 0L, u = Frac(1, 1);
  foreach (f0; f[0])
    foreach (f1; f[1]) {
      if (f0+f1 > u) continue;
      ans += f[2].length;
      ans -= f[2].assumeSorted.equalRange(u-f0-f1).length;
      ans -= f[2].assumeSorted.upperBound(u-max(f0, f1)).length;
    }

  writeln(ans);
}

struct Frac
{
  long num, den;

  auto opCmp(Frac rhs)
  {
    return num * rhs.den - rhs.num * den;
  }

  auto opBinary(string op: "+")(Frac rhs)
  {
    return Frac(num * rhs.den + rhs.num * den, den * rhs.den);
  }

  auto opBinary(string op: "-")(Frac rhs)
  {
    return Frac(num * rhs.den - rhs.num * den, den * rhs.den);
  }
}
