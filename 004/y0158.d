import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.concurrency;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), am = Money(rd1[0], rd1[1], rd1[2]);
  auto db = readln.chomp.to!int;
  auto rd2 = readln.split.to!(int[]), bm = Money(rd2[0], rd2[1], rd2[2]);
  auto dc = readln.chomp.to!int;
  auto rd3 = readln.split.to!(int[]), cm = Money(rd3[0], rd3[1], rd3[2]);

  auto sumA = am.sum;
  auto dp = new int[][][](sumA / 1000 + 1, sumA / 100 + 1, sumA + 1);
  foreach (dpi; dp)
    foreach (dpj; dpi)
      dpj[] = -1;

  int calc(Money m) {
    if (dp[m.a1000][m.a100][m.a1] >= 0)
      return dp[m.a1000][m.a100][m.a1];

    auto r = 0;
    auto pb = m.pay(db);
    if (pb.valid) {
      auto n = calc(pb + bm);
      r = max(r, n + 1);
    }
    auto pc = m.pay(dc);
    if (pc.valid) {
      auto n = calc(pc + cm);
      r = max(r, n + 1);
    }

    return dp[m.a1000][m.a100][m.a1] = r;
  }

  writeln(calc(am));
}

struct Money
{
  int a1000, a100, a1;

  auto opBinary(string op: "+")(Money r) {
    return Money(a1000 + r.a1000, a100 + r.a100, a1 + r.a1);
  }

  auto sum() { return a1000 * 1000 + a100 * 100 + a1; }

  auto valid() { return a1000 >= 0; }

  auto pay(int d) {
    auto m = Money(a1000, a100, a1);

    auto p1000 = min(m.a1000, d / 1000);
    m.a1000 -= p1000;
    d -= p1000 * 1000;

    auto p100 = min(m.a100, d / 100);
    m.a100 -= p100;
    d -= p100 * 100;

    auto p1 = min(m.a1, d);
    m.a1 -= p1;
    d -= p1;

    return d == 0 ? m : Money(-1, -1, -1);
  }
}
