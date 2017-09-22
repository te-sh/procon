import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

static inf = 10 ^^ 8;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, ma = rd1[1].to!int, mb = rd1[2].to!int;
  auto d = new Chemical[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]), a = rd2[0], b = rd2[1], c = rd2[2];
    d[i] = Chemical(a, b, c);
  }

  auto n1 = (n+1)/2, n2 = n-n1;

  auto a2s = d[n1..$].map!"a.a".sum, da2 = (a2s+ma-1)/ma;
  auto b2s = d[n1..$].map!"a.b".sum, db2 = (b2s+mb-1)/mb;

  auto e = new Chemical[][][](ma, mb, da2+db2+1);
  foreach (i; 0..ma)
    foreach (j; 0..mb)
      e[i][j][] = Chemical(-1, -1, inf);
    
  foreach (i; 1..1<<n2) {
    auto f = d[n1..$].indexed(i.bitsSet).sum;
    auto ia = f.a % ma, ib = f.b % mb, id = (f.b+mb-1)/mb - (f.a+ma-1)/ma + da2;
    if (f.c < e[ia][ib][id].c) e[ia][ib][id] = f;
  }

  auto ans = inf;
  foreach (i; 0..1<<n1) {
    auto f = d.indexed(i.bitsSet).sum;
    if (f.a > 0 && f.b > 0 && f.a % ma == 0 && f.b % mb == 0 && f.a/ma == f.b/mb) {
      ans = min(ans, f.c);
    } else {
      auto ia = (ma - f.a % ma) % ma, ib = (mb - f.b % mb) % mb, id = f.a/ma - f.b/mb + da2;
      if (0 <= id && id <= da2 + db2)
        ans = min(ans, f.c + e[ia][ib][id].c);
    }
  }

  writeln(ans == inf ? -1 : ans);
}

struct Chemical
{
  int a, b, c;
  auto opBinary(string op: "+")(Chemical rhs) { return Chemical(a + rhs.a, b + rhs.b, c + rhs.c); }
}
