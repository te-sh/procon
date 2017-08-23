import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], d = rd[1], k = rd[2];

  auto comSum(int i, int j) {
    return i > j ? 0 : (j * (j + 1) - (i - 1) * i) / 2;
  }

  auto calc(int a, int b) {
    return comSum(1, a) + comSum(b, n);
  }

  auto a = k, b = n + 1, c = -1;
  if (comSum(1, k) > d || comSum(n - k + 1, n) < d) {
    writeln(-1);
  } else {
    while (calc(a, b) < d) {
      if (calc(a - 1, b - 1) < d) {
        --a;
        --b;
      } else {
        c = a + d - calc(a, b);
        --a;
        break;
      }
    }

    auto r = iota(1, a+1).array ~ (c > 0 ? [c] : []) ~ iota(b, n+1).array;
    writeln(r.to!(string[]).join(" "));
  }
}
